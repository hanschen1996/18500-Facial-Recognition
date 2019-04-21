/** @file vj_cascade_classifier.c
 *  @brief Viola-Jones cascading classifier
 */

#include "int_img_calc.h"
#include "detect_face.h"
#include "vj_types.h"
#include "vj_weights.h"
#include "downscale.h"

// code adapted from online source that does integer square root
unsigned int int_sqrt(unsigned int value) {
  int i;
  unsigned int a = 0, b = 0, c = 0;

  for ( i = 0 ; i < 16 ; i++ )
  {
    #pragma HLS unroll
    c<<= 2;   
    #define UPPERBITS(value) (value>>30)
    c += UPPERBITS(value);
    #undef UPPERBITS
    value <<= 2;
    a <<= 1;
    b = (a<<1) | 1;
    if ( c >= b )
    {
      c -= b;
      a++;
    }
  }
  return a;
}

void cascade_classifier(
    unsigned int integral_image[IMG_HEIGHT][IMG_WIDTH],
    unsigned int height,
    unsigned int width,
    float factor,
    unsigned int window_size,
    unsigned char best_coords[5],
    int best_score[1]) {
#pragma HLS array_partition variable=best_coords complete dim=0
#pragma HLS array_partition variable=best_score complete dim=0

    int total_stage_accum, stage_accum;
    char passed;
    unsigned int stddev, mean;
    unsigned int row, col;
    unsigned int feature_index, s, f;

    int stage_thresh;
    unsigned int stage_feature_count;
    int above, below;
    int feature_thresh;
    unsigned int A, B, C, D;
    unsigned int rect1_x1, rect1_y1, rect1_x2, rect1_y2, rect1_weight, rect1_sum,
                 rect2_x1, rect2_y1, rect2_x2, rect2_y2, rect2_weight, rect2_sum,
                 rect3_x1, rect3_y1, rect3_x2, rect3_y2, rect3_weight, rect3_sum;
    int rects_sum;

    unsigned int curr_start_x, curr_start_y;

    for (row = 0; row < height - WINDOW_SIZE; row ++) {
        for (col = 0; col < width - WINDOW_SIZE; col ++) {
            // pass the subwindow through the cascading classifier

            D = integral_image[row + WINDOW_SIZE][col + WINDOW_SIZE];
            C = integral_image[row + WINDOW_SIZE][col];
            B = integral_image[row][col + WINDOW_SIZE];
            A = integral_image[row][col];

            // get standard deviation of the current window
            stddev = D*D - C*C + A*A - B*B;
            mean = D - C + A - B;
            stddev = int_sqrt(stddev * 576 - mean * mean);

            feature_index = 0;
            passed = 1;
            total_stage_accum = 0;
            for (s = 0; s < NUM_STAGE; s ++) {
                stage_thresh = STAGE_THRESH[s];
                stage_feature_count = STAGE_NUM_FEATURE[s];
                stage_accum = 0;

                for (f = 0; f < stage_feature_count; f ++) {
#pragma HLS pipeline
                    feature_thresh = FEATURE_THRESH[feature_index] * (int)stddev;
                    above = FEATURE_ABOVE[feature_index];
                    below = FEATURE_BELOW[feature_index];

                    rect1_x1 = col + RECT1_X[feature_index];
                    rect1_y1 = row + RECT1_Y[feature_index];
                    rect1_x2 = rect1_x1 + RECT1_WIDTH[feature_index];
                    rect1_y2 = rect1_y1 + RECT1_HEIGHT[feature_index];
                    rect1_weight = RECT1_WEIGHT[feature_index];

                    rect2_x1 = col + RECT2_X[feature_index];
                    rect2_y1 = row + RECT2_Y[feature_index];
                    rect2_x2 = rect2_x1 + RECT2_WIDTH[feature_index];
                    rect2_y2 = rect2_y1 + RECT2_HEIGHT[feature_index];
                    rect2_weight = RECT2_WEIGHT[feature_index];

                    rect3_x1 = col + RECT3_X[feature_index];
                    rect3_y1 = row + RECT3_Y[feature_index];
                    rect3_x2 = rect3_x1 + RECT3_WIDTH[feature_index];
                    rect3_y2 = rect3_y1 + RECT3_HEIGHT[feature_index];
                    rect3_weight = RECT3_WEIGHT[feature_index];

                    rect1_sum = integral_image[rect1_y2][rect1_x2] -
                                integral_image[rect1_y1][rect1_x2] +
                                integral_image[rect1_y1][rect1_x1] -
                                integral_image[rect1_y2][rect1_x1];
                    rect2_sum = integral_image[rect2_y2][rect2_x2] -
                                integral_image[rect2_y1][rect2_x2] +
                                integral_image[rect2_y1][rect2_x1] -
                                integral_image[rect2_y2][rect2_x1];
                    rect3_sum = integral_image[rect3_y2][rect3_x2] -
                                integral_image[rect3_y1][rect3_x2] +
                                integral_image[rect3_y1][rect3_x1] -
                                integral_image[rect3_y2][rect3_x1];

                    rects_sum = rect1_weight * (int)rect1_sum +
                                rect2_weight * (int)rect2_sum +
                                rect3_weight * (int)rect3_sum;

                    // accumulate to stage sum
                    stage_accum += (rects_sum >= feature_thresh ? above : below);

                    feature_index ++;
                }

                if (stage_accum < stage_thresh) {
                    passed = 0;
                    break;
                }

                total_stage_accum += stage_accum;
            }

            if (passed) {
                curr_start_x = col*factor;
                curr_start_y = row*factor;
                printf("%d,%d,%d,%d,%d\n", curr_start_x,curr_start_y,curr_start_x+window_size,curr_start_y+window_size, total_stage_accum);
                if (best_coords[0] == 0) {
                    best_coords[0] = 1;
                    best_coords[1] = curr_start_x;
                    best_coords[2] = curr_start_y;
                    best_coords[3] = curr_start_x + window_size;
                    best_coords[4] = curr_start_y + window_size;
                    best_score[0] = total_stage_accum;
                } else {
                    if (total_stage_accum > best_score[0]) {
                        best_coords[1] = curr_start_x;
                        best_coords[2] = curr_start_y;
                        best_coords[3] = curr_start_x + window_size;
                        best_coords[4] = curr_start_y + window_size;
                        best_score[0] = total_stage_accum;
                    }
                }
            }
        }
    }
}

char detect_face(
    unsigned char pixel,
    unsigned char result_x1[1],
    unsigned char result_y1[1],
    unsigned char result_x2[1],
    unsigned char result_y2[1]) {
#pragma HLS array_partition variable=result_x1 complete dim=0
#pragma HLS array_partition variable=result_y1 complete dim=0
#pragma HLS array_partition variable=result_x2 complete dim=0
#pragma HLS array_partition variable=result_y2 complete dim=0

    static unsigned char input_image[IMG_HEIGHT][IMG_WIDTH];
    static unsigned int read_row = 0;
    static unsigned int read_col = 0;

    input_image[read_row][read_col] = pixel;
    if (read_col == IMG_WIDTH - 1) {
        if (read_row < IMG_HEIGHT - 1) {
            read_row ++;
            read_col = 0;
            return 0;
        }
    } else {
        read_col ++;
        return 0;
    }

    unsigned char curr_image[IMG_HEIGHT][IMG_WIDTH];
    unsigned int curr_height = IMG_HEIGHT;
    unsigned int curr_width = IMG_WIDTH;
    unsigned int curr_window_size = WINDOW_SIZE;
    float factor = 1;
    unsigned int integral_image[IMG_HEIGHT][IMG_WIDTH];
    unsigned int row, col;

    // best_coords[0] to indicate whether face is already found
    // best_coords[1] to indicate x1
    // best_coords[2] to indicate y1
    // best_coords[3] to indicate x2
    // best_coords[4] to indicate y2
    // best_score[0] to indicate score
    unsigned char best_coords[5];
    int best_score[1];
#pragma HLS array_partition variable=best_coords complete dim=0
#pragma HLS array_partition variable=best_score complete dim=0
    best_coords[0] = 0;

    while (curr_height > WINDOW_SIZE && curr_width > WINDOW_SIZE) {
        downscale(input_image, curr_image, curr_height, curr_width);
        GET_II(curr_image, integral_image, curr_height, curr_width, row, col);
        cascade_classifier(integral_image,
                           curr_height,
                           curr_width,
                           factor,
                           curr_window_size,
                           best_coords,
                           best_score);

        factor *= SCALE_FACTOR;
        curr_window_size = WINDOW_SIZE * factor;
        curr_height = IMG_HEIGHT / factor;
        curr_width = IMG_WIDTH / factor;
    }

    read_row = 0;
    read_col = 0;
    if (best_coords[0]) {
        result_x1[0] = best_coords[1];
        result_y1[0] = best_coords[2];
        result_x2[0] = best_coords[3];
        result_y2[0] = best_coords[4];
        return 1;
    }

    // -1 to indicate no face is found
    return 0xff;
}

/** @file vj_cascade_classifier.c
 *  @brief Viola-Jones cascading classifier
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "inc/vj_cascade_classifier.h"
#include "inc/vj_types.h"
#include "inc/vj_utils.h"

int alr_found = 0;
int best_accum;
int best_start_x;
int best_start_y;
int best_end_x;
int best_end_y;

void cascade_classifier(unsigned int integral_image[IMAGE_HEIGHT][IMAGE_WIDTH],
                        unsigned int integral_image_sq[IMAGE_HEIGHT][IMAGE_WIDTH],
                        unsigned int height,
                        unsigned int width,
                        float factor) {
    for (unsigned int row = 0; row < height - WINDOW_SIZE; row ++) {
        for (unsigned int col = 0; col < width - WINDOW_SIZE; col ++) {
            // pass the subwindow through the cascading classifier

            // get standard deviation of the current window
            unsigned int std = get_window_std(integral_image, integral_image_sq, row, col);
            unsigned int feature_index = 0;
            bool passed = true;
            int total_stage_accum = 0;
            for (unsigned int s = 0; s < NUM_STAGE; s ++) {
                Stage stage = STAGES[s];
                int stage_accum = 0;

                for (unsigned int f = 0; f < stage.feature_count; f ++) {
                    Feature feature = FEATURES[feature_index];
                    int thresh = feature.threshold * std;

                    int val1 = get_rect_val(integral_image, row, col, &feature.rect1);
                    int val2 = get_rect_val(integral_image, row, col, &feature.rect2);
                    int val3 = get_rect_val(integral_image, row, col, &feature.rect3);
                    int total_val = val1 + val2 + val3;

                    int stage_val = total_val >= thresh ? feature.above : feature.below;

                    // accumulate to stage value
                    stage_accum += stage_val;
                    feature_index ++;
                }

                if (stage_accum < stage.threshold) {
                    passed = false;
                    break;
                }

                total_stage_accum += stage_accum;
            }

            if (passed) {
                unsigned int curr_start_x = col*factor;
                unsigned int curr_start_y = row*factor;
                unsigned int curr_end_x = curr_start_x + WINDOW_SIZE*factor;
                unsigned int curr_end_y = curr_start_y + WINDOW_SIZE*factor;

                if (!alr_found) {
                    alr_found = 1;
                    best_accum = total_stage_accum;
                    best_start_x = curr_start_x;
                    best_start_y = curr_start_y;
                    best_end_x = curr_end_x;
                    best_end_y = curr_end_y;
                } else {
                    if (total_stage_accum > best_accum) {
                        best_start_x = curr_start_x;
                        best_start_y = curr_start_y;
                        best_end_x = curr_end_x;
                        best_end_y = curr_end_y;
                        best_accum = total_stage_accum;
                    }
                }

                printf("Face:(%d,%d,%d,%d,%d)\n",
                       curr_start_x,
                       curr_start_y,
                       curr_end_x,
                       curr_end_y,
                       total_stage_accum);
            }
        }
    }
}

void detect_face(
    unsigned char orig_image[IMAGE_HEIGHT][IMAGE_WIDTH],
    int *success) {

    unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH];
    memcpy(image, orig_image, IMAGE_HEIGHT * IMAGE_WIDTH * sizeof(char));

    unsigned int curr_height = IMAGE_HEIGHT;
    unsigned int curr_width = IMAGE_WIDTH;
    float factor = 1;
    unsigned int integral_image[IMAGE_HEIGHT][IMAGE_WIDTH];
    unsigned int integral_image_sq[IMAGE_HEIGHT][IMAGE_WIDTH];

    while (curr_height >= WINDOW_SIZE && curr_width >= WINDOW_SIZE) {
        get_integral_image(image, integral_image, integral_image_sq, curr_height, curr_width);
        cascade_classifier(integral_image,
                           integral_image_sq,
                           curr_height,
                           curr_width,
                           factor);

        factor *= SCALE_FACTOR;
        curr_height = IMAGE_HEIGHT / factor;
        curr_width = IMAGE_WIDTH / factor;
        scale(orig_image, IMAGE_HEIGHT, IMAGE_WIDTH, image, curr_height, curr_width);
    }

    *success = alr_found;
    if (alr_found) {
        draw_rectangle(orig_image, best_start_x, best_start_y, best_end_x, best_end_y);
    } else {
        printf("ERROR:No face found!\n");
    }
}

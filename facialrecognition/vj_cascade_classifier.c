/** @file vj_cascade_classifier.c
 *  @brief Viola-Jones cascading classifier
 */

#define MAX_PASS_COUNT 20

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "inc/vj_cascade_classifier.h"
#include "inc/vj_types.h"
#include "inc/vj_utils.h"

unsigned int cascade_classifier(unsigned int integral_image[IMAGE_HEIGHT][IMAGE_WIDTH],
                                unsigned int integral_image_sq[IMAGE_HEIGHT][IMAGE_WIDTH],
                                unsigned int height,
                                unsigned int width,
                                float factor,
                                Rect final_pass_rects[],
                                unsigned int final_pass) {
    for (unsigned int row = 0; row < height - WINDOW_SIZE; row ++) {
        for (unsigned int col = 0; col < width - WINDOW_SIZE; col ++) {

            // pass the subwindow through the cascading classifier

            // get standard deviation of the current window
            unsigned int std = get_window_std(integral_image, integral_image_sq, row, col);
            unsigned int feature_index = 0;
            bool passed = true;
            for (unsigned int s = 0; s < NUM_STAGE; s ++) {
                Stage stage = STAGES[s];
                int stage_accum = 0.0;

                for (unsigned int f = 0; f < stage.feature_count; f ++) {
                    Feature feature = FEATURES[feature_index];
                    int thresh = feature.threshold * std;

                    int val1 = get_rect_val(integral_image, row, col, &feature.rect1);
                    int val2 = get_rect_val(integral_image, row, col, &feature.rect2);
                    int val3 = get_rect_val(integral_image, row, col, &feature.rect3);
                    int total_val = val1 + val2 + val3;

                    //printf("total_val: %f\n", total_val);
                    int stage_val = total_val > thresh ? feature.above : feature.below;

                    // accumulate to stage value
                    stage_accum += stage_val;
                    feature_index ++;
                }

                if (stage_accum < stage.threshold) {
                    passed = false;
                    break;
                }
            }
            //exit(0);
            if (passed) {
                final_pass_rects[final_pass].x = col*factor;
                final_pass_rects[final_pass].y = row*factor;
                final_pass_rects[final_pass].width = WINDOW_SIZE*factor;
                final_pass_rects[final_pass].height = WINDOW_SIZE*factor;
                printf("face region: left corner: (x=%d,y=%d), size: (w=%d,h=%d)\n", final_pass_rects[final_pass].x, final_pass_rects[final_pass].y, final_pass_rects[final_pass].width, final_pass_rects[final_pass].height);
                final_pass ++;
                if (final_pass == MAX_PASS_COUNT) {
                    printf("Set MAX_PASS_COUNT to a bigger value!\n");
                    return final_pass;
                }
            }
        }
    }
    return final_pass;
}

void detect_face(
    unsigned char orig_image[IMAGE_HEIGHT][IMAGE_WIDTH],
    int *success) {

    unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH];
    memcpy(image, orig_image, IMAGE_HEIGHT * IMAGE_WIDTH * sizeof(char));
    unsigned int final_pass = 0;
    unsigned int curr_height = IMAGE_HEIGHT;
    unsigned int curr_width = IMAGE_WIDTH;
    float factor = 1;
    unsigned int integral_image[IMAGE_HEIGHT][IMAGE_WIDTH];
    unsigned int integral_image_sq[IMAGE_HEIGHT][IMAGE_WIDTH];
    Rect final_pass_rects[MAX_PASS_COUNT];

    while (curr_height >= WINDOW_SIZE && curr_width >= WINDOW_SIZE) {
        printf("using image size width=%d, height=%d\n", curr_width, curr_height);
        get_integral_image(image, integral_image, integral_image_sq, curr_height, curr_width);
        final_pass = cascade_classifier(integral_image, integral_image_sq, curr_height, curr_width, factor, final_pass_rects, final_pass);

        factor *= SCALE_FACTOR;
        scale(image, curr_height, curr_width, image, IMAGE_HEIGHT / factor, IMAGE_WIDTH / factor);
        curr_height = IMAGE_HEIGHT / factor;
        curr_width = IMAGE_WIDTH / factor;
    }

    if (final_pass == 0) {
        *success = 0;
        printf("no face found\n");
    } else {
        *success = 1;
        merge_bounding_box(final_pass, final_pass_rects);
        printf("Final face region: left corner: (x=%d,y=%d), size: (w=%d,h=%d)\n",         final_pass_rects[0].x, final_pass_rects[0].y, final_pass_rects[0].width, final_pass_rects[0].height);
        draw_rectangle(orig_image, &final_pass_rects[0]);
    }
}

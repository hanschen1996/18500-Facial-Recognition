/** @file vj_cascade_classifier.c
 *  @brief Viola-Jones cascading classifier
 */

#define MAX_PASS_COUNT 20

#include <stdio.h>
#include <string.h>
#include "inc/vj_cascade_classifier.h"
#include "inc/vj_types.h"
#include "inc/vj_utils.h"

void cascade_classifier(
    unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH]) {

    unsigned int curr_height = IMAGE_HEIGHT;
    unsigned int curr_width = IMAGE_WIDTH;
    unsigned int integral_image[IMAGE_HEIGHT][IMAGE_WIDTH];
    unsigned int num_passed = 0;
    unsigned int passed_row[MAX_PASS_COUNT];
    unsigned int passed_col[MAX_PASS_COUNT];

    while (curr_height >= WINDOW_SIZE && curr_width >= WINDOW_SIZE) {
        get_integral_image(image, integral_image, curr_height, curr_width);

        printf("using image size width=%d, height=%d\n", curr_width, curr_height);
        for (unsigned int row = 0; row < IMAGE_HEIGHT - WINDOW_SIZE; row ++) {
            for (unsigned int col = 0; col < IMAGE_WIDTH - WINDOW_SIZE; col ++) {
                //printf("subwindow left corner: (%d, %d)\n, starting cascading classifier", row, col);

                // pass the subwindow through the cascading classifier
                unsigned int feature_index = 0;
                bool passed = true;
                for (unsigned int s = 0; s < NUM_STAGE; s ++) {
                    Stage stage = STAGES[s];
                    float stage_accum = 0.0;

                    for (unsigned int f = 0; f < stage.feature_count; f ++) {
                        Feature feature = FEATURES[feature_index];
                        float val1 = get_rect_val(integral_image, row, col, &feature.rect1);
                        float val2 = get_rect_val(integral_image, row, col, &feature.rect2);
                        float val3 = get_rect_val(integral_image, row, col, &feature.rect3);
                        float total_val = val1 + val2 + val3;

                        float stage_val =
                            total_val > feature.threshold ? feature.above : feature.below;
                        // accumulate to stage value
                        stage_accum += stage_val;
                        feature_index ++;
                    }
                    if (stage_accum <= stage.threshold) {
                        passed = false;
                        break;
                    }
                }

                if (passed) {
                    passed_row[num_passed] = row;
                    passed_col[num_passed] = col;
                    num_passed++;
                    printf("subwindow with left corner row=%d, col=%d passed!\n", row, col);

                    if (num_passed == MAX_PASS_COUNT) {
                        printf("Set MAX_PASS_COUNT to a bigger value!\n");
                        return;
                    }
                }
            }
        }
        if (num_passed > 0) {
            printf("at image size (%d, %d), %d face candidates found", curr_width, curr_height, num_passed);
            for (unsigned int i = 0; i < num_passed; i ++) {
                printf("row: %d, col%d\n", passed_row[i], passed_col[i]);
            }
            break;
        }

        scale(image, curr_height, curr_width, curr_height / SCALE_FACTOR, curr_width / SCALE_FACTOR);
        curr_height /= SCALE_FACTOR;
        curr_width /= SCALE_FACTOR;
    }
}

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
    unsigned int integral_image[IMAGE_HEIGHT][IMAGE_WIDTH]) {

    unsigned int window_image[WINDOW_SIZE][WINDOW_SIZE];
    unsigned int num_passed = 0;
    unsigned int passed_row[MAX_PASS_COUNT];
    unsigned int passed_col[MAX_PASS_COUNT];

    for (unsigned int row = 0; row < IMAGE_HEIGHT - WINDOW_SIZE; row ++) {
        for (unsigned int col = 0; col < IMAGE_WIDTH - WINDOW_SIZE; col ++) {
            // extract the current subwindow of the image
            // use HDL bit indexing to achieve this
            for (unsigned int sub_row = 0; sub_row < WINDOW_SIZE; sub_row ++) {
                memcpy(window_image[sub_row],
                       integral_image[row + sub_row],
                       sizeof(unsigned int) * WINDOW_SIZE);
            }

            printf("subwindow left corner: (%d, %d)\n, starting cascading classifier", row, col);

            // pass the subwindow through the cascading classifier
            unsigned int feature_index = 0;
            bool passed = true;
            for (unsigned int s = 0; s < NUM_STAGE; s ++) {
                Stage stage = STAGES[s];
                float stage_accum = 0.0;
                for (unsigned int f = 0; f < stage.feature_count; f ++) {
                    Feature feature = FEATURES[feature_index];
                    float val1 = get_rect_val(window_image, &feature.rect1);
                    float val2 = get_rect_val(window_image, &feature.rect2);
                    float val3 = get_rect_val(window_image, &feature.rect3);
                    float total_val = val1 + val2 + val3;

                    // use a MUX to select some values??
                    float stage_val =
                        total_val > feature.threshold ? feature.above : feature.below;
                    // accumulate to stage value
                    stage_accum += stage_val;
                    feature_index ++;
                }
                if (stage_accum > stage.threshold) {
                    printf("subwindow passed stage %d, entering next stage\n", s);
                } else {
                    printf("subwindow failed stage %d\n", s);
                    passed = false;
                    break;
                }
            }

            if (passed) {
                passed_row[num_passed] = row;
                passed_col[num_passed] = col;
                num_passed++;
                if (num_passed == MAX_PASS_COUNT) {
                    printf("Set MAX_PASS_COUNT to a bigger value!\n");
                    return;
                }
            }
        }
    }
    printf("There are %d face candidates passed\n", num_passed);
    for (unsigned int i = 0; i < num_passed; i ++) {
        printf("row:%d, col:%d\n", passed_row[i], passed_col[i]);
    }
}

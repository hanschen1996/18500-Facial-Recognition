/** @file vj_utils.c
 *  @brief implementations to calculate integral image and rectangle value
 */

#include "inc/vj_utils.h"

void get_integral_image(unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH],
                        unsigned int result[IMAGE_HEIGHT][IMAGE_WIDTH]) {
    for (unsigned int row = 0; row < IMAGE_HEIGHT; row ++) {
        if (row == 0) {
            for (unsigned int col = 0; col < IMAGE_WIDTH; col ++) {
                result[row][col] = result[row][col-1] + image[row][col];
            }
        } else {
            for (unsigned int col = 0; col < IMAGE_WIDTH; col ++) {
                if (col == 0) {
                    result[row][col] = result[row - 1][col] + image[row][col];
                } else {
                    result[row][col] = result[row - 1][col] + result[row][col - 1] + image[row][col];
                }
            }
        }
    }
}

float get_rect_val(unsigned int image[WINDOW_SIZE][WINDOW_SIZE],
                   Rect *r) {
    float weight = r->weight;
    unsigned int start_x = r->x;
    unsigned int start_y = r->y;
    unsigned int width = r->width;
    unsigned int height = r->height;

    unsigned int D = image[start_y + height - 1][start_x + width - 1];
    unsigned int A = image[start_y][start_x];
    unsigned int B = image[start_y][start_x + width - 1];
    unsigned int C = image[start_y + height - 1][start_x];
    return weight * ((float)(D+A-B-C));
}

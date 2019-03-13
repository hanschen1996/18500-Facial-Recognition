/** @file vj_utils.c
 *  @brief implementations to calculate integral image and rectangle value
 */

#include <stdio.h>
#include "inc/vj_utils.h"

void get_integral_image(unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH],
                        unsigned int result[IMAGE_HEIGHT][IMAGE_WIDTH],
                        unsigned int height,
                        unsigned int width) {
    for (unsigned int row = 0; row < height; row ++) {
        for (unsigned int col = 0; col < width; col ++) {
            unsigned int val = image[row][col];
            if (row != 0) {
                val += result[row - 1][col];
            }
            if (col != 0) {
                val += result[row][col - 1];
            }
            if (row != 0 && col != 0) {
                val -= result[row - 1][col - 1];
            }
            result[row][col] = val;
        }
    }
}

float get_rect_val(unsigned int image[IMAGE_HEIGHT][IMAGE_WIDTH],
                   unsigned int window_row,
                   unsigned int window_col,
                   Rect *r) {
    float weight = r->weight;
    unsigned int start_x = r->x;
    unsigned int start_y = r->y;
    unsigned int width = r->width;
    unsigned int height = r->height;
    if (start_x + width > 24 || start_y + height > 24 ||
        window_row + start_y + height >= IMAGE_HEIGHT ||
        window_col + start_x + width >= IMAGE_WIDTH) {
        printf("alert!!!\n");
    }

    unsigned int D = image[window_row + start_y + height][window_col + start_x + width];
    unsigned int A = image[window_row + start_y][window_col + start_x];
    unsigned int B = image[window_row + start_y][window_col + start_x + width];
    unsigned int C = image[window_row + start_y + height][window_col + start_x];
    return weight * ((float)(D+A-B-C));
}

void scale(unsigned char src[IMAGE_HEIGHT][IMAGE_WIDTH],
           unsigned int h1,
           unsigned int w1,
           unsigned int h2,
           unsigned int w2) {
    unsigned char temp[h2][w2];
    unsigned int x_ratio = ( (w1<<16)/w2 ) + 1;
    unsigned int y_ratio = ( (h1<<16)/h2 ) + 1;
    for (unsigned int h = 0; h < h2; h++) {
        for (unsigned int w = 0; w < w2; w++) {
            unsigned int x2 = (w * x_ratio) >> 16;
            unsigned int y2 = (h * y_ratio) >> 16;
            temp[h][w] = src[y2][x2];
        }
    }
    for (unsigned int h = 0; h < h2; h++) {
        for (unsigned int w = 0; w < w2; w++) {
            src[h][w] = temp[h][w];
        }
    }
}

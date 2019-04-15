/** @file vj_utils.c
 *  @brief implementations to calculate integral image and rectangle value
 */

#include <stdio.h>
#include <math.h>
#include "inc/vj_utils.h"

#define BOX_COLOR 0

/* tested */
void get_integral_image(unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH],
                        unsigned int result[IMAGE_HEIGHT][IMAGE_WIDTH],
                        unsigned int result_sq[IMAGE_HEIGHT][IMAGE_WIDTH],
                        unsigned int height,
                        unsigned int width) {
    for (unsigned int row = 0; row < height; row ++) {
        unsigned int accum = 0;
        unsigned int accum_sq = 0;
        for (unsigned int col = 0; col < width; col ++) {
            accum += image[row][col];
            accum_sq += image[row][col] * image[row][col];

            if (row == 0) {
                result[row][col] = accum;
                result_sq[row][col] = accum_sq;
            } else {
                result[row][col] = accum + result[row - 1][col];
                result_sq[row][col] = accum_sq + result_sq[row - 1][col];
            }
        }
    }
}

int get_rect_val(unsigned int image[IMAGE_HEIGHT][IMAGE_WIDTH],
                 unsigned int window_row,
                 unsigned int window_col,
                 Rect *r) {
    int weight = r->weight;
    unsigned int start_x = r->x;
    unsigned int start_y = r->y;
    unsigned int width = r->width;
    unsigned int height = r->height;

    unsigned int D = image[window_row + start_y + height][window_col + start_x + width];
    unsigned int A = image[window_row + start_y][window_col + start_x];
    unsigned int B = image[window_row + start_y][window_col + start_x + width];
    unsigned int C = image[window_row + start_y + height][window_col + start_x];
    return weight * (int)(D-B+A-C);
}

unsigned int get_window_std(unsigned int integral_image[IMAGE_HEIGHT][IMAGE_WIDTH],
                            unsigned int integral_image_sq[IMAGE_HEIGHT][IMAGE_WIDTH],
                            unsigned int start_row,
                            unsigned int start_col) {
    unsigned int D = integral_image[start_row + WINDOW_SIZE][start_col + WINDOW_SIZE];
    unsigned int A = integral_image[start_row][start_col];
    unsigned int B = integral_image[start_row][start_col + WINDOW_SIZE];
    unsigned int C = integral_image[start_row + WINDOW_SIZE][start_col];
    unsigned int DD = integral_image_sq[start_row + WINDOW_SIZE][start_col + WINDOW_SIZE];
    unsigned int AA = integral_image_sq[start_row][start_col];
    unsigned int BB = integral_image_sq[start_row][start_col + WINDOW_SIZE];
    unsigned int CC = integral_image_sq[start_row + WINDOW_SIZE][start_col];
    unsigned int mean = D-B+A-C;
    return sqrt((DD - BB + AA - CC) * WINDOW_SIZE * WINDOW_SIZE - mean * mean);
}

/* tested */
void scale(unsigned char src[IMAGE_HEIGHT][IMAGE_WIDTH],
           unsigned int h1,
           unsigned int w1,
           unsigned char dest[IMAGE_HEIGHT][IMAGE_WIDTH],
           unsigned int h2,
           unsigned int w2) {
    unsigned char temp[h2][w2];
    unsigned int x_ratio = (int)( ((int)w1<<16)/w2 ) + 1;
    unsigned int y_ratio = (int)( ((int)h1<<16)/h2 ) + 1;

    printf("image size:(width=%d,height=%d), (x_ratio=%d,y_ratio=%d)\n", w2, h2, x_ratio, y_ratio);
    for (unsigned int h = 0; h < h2; h++) {
        for (unsigned int w = 0; w < w2; w++) {
            unsigned int x2 = (w * x_ratio) >> 16;
            unsigned int y2 = (h * y_ratio) >> 16;
            temp[h][w] = src[y2][x2];
        }
    }

    for (unsigned int h = 0; h < h2; h ++) {
        for (unsigned int w = 0; w < w2; w ++) {
            dest[h][w] = temp[h][w];
        }
    }
}

void draw_rectangle(unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH],
                    unsigned int start_x,
                    unsigned int start_y,
                    unsigned int end_x,
                    unsigned int end_y) {
    for (unsigned int x = start_x; x < end_x; x ++) {
        image[start_y][x] = BOX_COLOR;
        image[end_y - 1][x] = BOX_COLOR;
    }

    for (unsigned int y = start_y; y < end_y; y ++) {
        image[y][start_x] = BOX_COLOR;
        image[y][end_x - 1] = BOX_COLOR;
    }
}

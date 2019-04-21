/** @file  downscale.c
 *  @brief implementation to downscale an image
 */

#include "downscale.h"

void downscale(unsigned char src[IMG_HEIGHT][IMG_WIDTH],
               unsigned char dest[IMG_HEIGHT][IMG_WIDTH],
               unsigned int dest_height,
               unsigned int dest_width) {
    unsigned int x_ratio = 10485760 / dest_width + 1; // 10485760 = 160 << 16
    unsigned int y_ratio = 7864320 / dest_height + 1; // 7864320 = 120 << 16
    unsigned int row, col;

    for (row = 0; row < IMG_HEIGHT; row ++) {
        for (col = 0; col < IMG_WIDTH; col ++) {
#pragma HLS pipeline
            if (row < dest_height && col < dest_width) {
                dest[row][col] = src[(row*y_ratio) >> 16][(col*x_ratio) >> 16];
            }
        }
    }
}

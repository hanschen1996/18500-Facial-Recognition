/** @file vj_utils.c
 *  @brief implementations to calculate integral image and rectangle value
 */

#include <stdio.h>
#include <math.h>
#include "inc/vj_utils.h"

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

float get_window_std(unsigned int integral_image[IMAGE_HEIGHT][IMAGE_WIDTH],
                     unsigned int integral_image_sq[IMAGE_HEIGHT][IMAGE_WIDTH],
                     unsigned int start_row,
                     unsigned int start_col) {
    unsigned int D = integral_image[start_row + WINDOW_SIZE - 1][start_col + WINDOW_SIZE - 1];
    unsigned int A = integral_image[start_row][start_col];
    unsigned int B = integral_image[start_row][start_col + WINDOW_SIZE - 1];
    unsigned int C = integral_image[start_row + WINDOW_SIZE - 1][start_col];
    unsigned int DD = integral_image_sq[start_row + WINDOW_SIZE - 1][start_col + WINDOW_SIZE -   1];
    unsigned int AA = integral_image_sq[start_row][start_col];
    unsigned int BB = integral_image_sq[start_row][start_col + WINDOW_SIZE - 1];
    unsigned int CC = integral_image_sq[start_row + WINDOW_SIZE - 1][start_col];

    //printf("D^2:%d,C^2:%d,B^2:%d,A^2:%d\n", DD, CC, BB, AA);
    //printf("D:%d,C:%d,B:%d,A:%d\n", D, C, B, A);
    unsigned int mean = D+A-B-C;
    return sqrt((AA + DD - BB - CC) * WINDOW_SIZE * WINDOW_SIZE - mean * mean);
}

/* tested */
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

void merge_bounding_box(unsigned int final_pass,
                        Rect final_pass_rects[]) {
    unsigned int start_x = final_pass_rects[0].x;
    unsigned int start_y = final_pass_rects[0].y;
    unsigned int end_x = start_x + final_pass_rects[0].width;
    unsigned int end_y = start_y + final_pass_rects[0].height;

    for (unsigned int i = 1; i < final_pass; i ++) {
        unsigned int curr_start_x = final_pass_rects[i].x;
        unsigned int curr_start_y = final_pass_rects[i].y;
        unsigned int curr_end_x = curr_start_x + final_pass_rects[i].width;
        unsigned int curr_end_y = curr_start_y + final_pass_rects[i].height;
        start_x = curr_start_x < start_x ? curr_start_x : start_x;
        start_y = curr_start_y < start_y ? curr_start_y : start_y;
        end_x = curr_end_x > end_x ? curr_end_x : end_x;
        end_y = curr_end_y > end_y ? curr_end_y : end_y;
    }

    final_pass_rects[0].x = start_x;
    final_pass_rects[0].y = start_y;
    final_pass_rects[0].width = end_x - start_x;
    final_pass_rects[0].height = end_y - start_y;
}

void draw_rectangle(unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH],
                    Rect *rect) {
    for (unsigned int col = 0; col < rect->width; col ++) {
        image[rect->y][rect->x + col] = 255;
        image[rect->y + rect->height - 1][rect->x + col] = 255;
    }

    for (unsigned int row = 0; row < rect->height; row ++) {
        image[rect->y + row][rect->x] = 255;
        image[rect->y + row][rect->x + rect->width - 1] = 255;
    }
}

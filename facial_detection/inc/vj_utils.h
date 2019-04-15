/** @file inc/vj_utils.h
 *  @brief Viola-Jones util functions to calculate rectangle value and integral image
 */

#ifndef __INC_VJ_UTILS_H_
#define __INC_VJ_UTILS_H_

#include <stdint.h>
#include "vj_types.h"
#include "vj_weights.h"

/* compute integral image of an input image */
void get_integral_image(unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH],
                        unsigned int result[IMAGE_HEIGHT][IMAGE_WIDTH],
                        unsigned int result_sq[IMAGE_HEIGHT][IMAGE_WIDTH],
                        unsigned int height,
                        unsigned int width);
int get_rect_val(unsigned int image[IMAGE_HEIGHT][IMAGE_WIDTH],
                 unsigned int window_row,
                 unsigned int window_col,
                 Rect *r);

unsigned int get_window_std(unsigned int integral_image[IMAGE_HEIGHT][IMAGE_WIDTH],
                            unsigned int integral_image_sq[IMAGE_HEIGHT][IMAGE_WIDTH],
                            unsigned int start_row,
                            unsigned int start_col);
void scale(unsigned char src[IMAGE_HEIGHT][IMAGE_WIDTH],
           unsigned int h1,
           unsigned int w1,
           unsigned char dest[IMAGE_HEIGHT][IMAGE_WIDTH],
           unsigned int h2,
           unsigned int w2);
void draw_rectangle(unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH],
                    unsigned int start_x,
                    unsigned int start_y,
                    unsigned int end_x,
                    unsigned int end_y);

#endif  /* __INC_VJ_UTILS_H_ */

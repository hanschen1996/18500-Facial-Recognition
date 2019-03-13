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
                        unsigned int height,
                        unsigned int width);
float get_rect_val(unsigned int image[IMAGE_HEIGHT][IMAGE_WIDTH],
                   unsigned int window_row,
                   unsigned int window_col,
                   Rect *r);
void scale(unsigned char src[IMAGE_HEIGHT][IMAGE_WIDTH],
           unsigned int h1,
           unsigned int w1,
           unsigned int h2,
           unsigned int w2);

#endif  /* __INC_VJ_UTILS_H_ */

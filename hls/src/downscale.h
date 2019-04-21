/** @file  downscale.h
 *  @brief interface for downscaling an image
 */

#include "vj_types.h"

void downscale(unsigned char src[IMG_HEIGHT][IMG_WIDTH],
               unsigned char dest[IMG_HEIGHT][IMG_WIDTH],
               unsigned int dest_height,
               unsigned int dest_width);


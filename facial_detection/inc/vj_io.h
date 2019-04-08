/** @file inc/vj_io.h
 *  @brief read and save pgm images
 */

#ifndef __INC_VJ_IO_H_
#define __INC_VJ_IO_H_

#include "vj_types.h"

int load_image_file(char *filename,
                    unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH]);
int save_image_file(char *filename,
                    unsigned int height,
                    unsigned int width,
                    unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH]);

#endif  /* __INC_VJ_IO_H_ */


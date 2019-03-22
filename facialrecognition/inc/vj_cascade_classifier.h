/** @file inc/vj_cascade_classifier.h
 *  @brief interface for Viola-Jones cascading classifier
 */

#ifndef __INC_VJ_CASCADE_CLASSIFIER_H_
#define __INC_VJ_CASCADE_CLASSIFIER_H_

#include "vj_types.h"

void detect_face(unsigned char orig_image[IMAGE_HEIGHT][IMAGE_WIDTH]);

#endif  /* __INC_VJ_CASCADE_CLASSIFIER_H_ */

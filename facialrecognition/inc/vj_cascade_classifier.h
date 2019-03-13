/** @file inc/vj_cascade_classifier.h
 *  @brief interface for Viola-Jones cascading classifier
 */

#ifndef __INC_VJ_CASCADE_CLASSIFIER_H_
#define __INC_VJ_CASCADE_CLASSIFIER_H_

#include "vj_types.h"

void cascade_classifier(
    unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH]);

#endif  /* __INC_VJ_CASCADE_CLASSIFIER_H_ */

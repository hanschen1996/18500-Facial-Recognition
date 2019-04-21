/** @file inc/vj_cascade_classifier.h
 *  @brief interface for Viola-Jones cascading classifier
 */

#ifndef __DETECT_FACE_H_
#define __DETECT_FACE_H_

#include "vj_types.h"

char detect_face(
    unsigned char pixel,
    unsigned char result_x1[1],
    unsigned char result_y1[1],
    unsigned char result_x2[1],
    unsigned char result_y2[1]);

#endif  /* __DETECT_FACE_H_ */

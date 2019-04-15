/** @file inc/vj_types.h
 *  @brief Viola-Jones type definitions
 */

#ifndef __INC_VJ_TYPES_H_
#define __INC_VJ_TYPES_H_

#include <stdint.h>

// assume our input image size is the following
#define IMAGE_WIDTH 160
#define IMAGE_HEIGHT 120
#define SCALE_FACTOR 1.2

typedef struct Rectangle {
    // starting column
    unsigned int x;

    // starting row
    unsigned int y;

    // width of the rectangle
    unsigned int width;

    // height of the rectangle
    unsigned int height;

    // weight of the rectangle feature
    int weight;
} Rect;

typedef struct Feature {
    // frontal face weights use at most 3 rectangles
    Rect rect1;
    Rect rect2;
    Rect rect3;

    // based on threshold, choose one of the two trained values
    int below;
    int above;

    // feature threshold
    int threshold;
} Feature;

typedef struct Stage {
    unsigned int feature_count;
    int threshold;
} Stage;

#endif  /* __INC_VJ_TYPES_H_ */

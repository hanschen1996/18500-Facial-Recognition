/** @file  vj_types.h
 *  @brief Viola-Jones type definitions
 */

#ifndef __VJ_TYPES_H_
#define __VJ_TYPES_H_

// assume our input image size is the following
#define IMG_WIDTH 160
#define IMG_HEIGHT 120
#define SCALE_FACTOR 1.2
#define MAX_PASS 50

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

#endif  /* __VJ_TYPES_H_ */

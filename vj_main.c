/** @file main.c
 *  @brief entry point for Viola-Jones cascading classifier
 */

#include "inc/vj_types.h"
#include "inc/vj_utils.h"
#include "inc/vj_cascade_classifier.h"

int main() {
    // read input here
    unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH];
    unsigned int integral_image[IMAGE_HEIGHT][IMAGE_WIDTH];

    get_integral_image(image, integral_image);
    cascade_classifier(integral_image);
    return 0;
}



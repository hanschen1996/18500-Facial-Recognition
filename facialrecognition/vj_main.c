/** @file main.c
 *  @brief entry point for Viola-Jones cascading classifier
 */

#include "inc/vj_types.h"
#include "inc/vj_utils.h"
#include "inc/vj_cascade_classifier.h"
#include "inc/vj_io.h"

int main() {
    // read input here
    unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH];
    load_image_file("images/subject01.gif.pgm", image);
    cascade_classifier(image);
    return 0;
}



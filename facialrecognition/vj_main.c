/** @file main.c
 *  @brief entry point for Viola-Jones cascading classifier
 */

#define BUF_SIZE 1024

#include <stdio.h>
#include "inc/vj_types.h"
#include "inc/vj_utils.h"
#include "inc/vj_cascade_classifier.h"
#include "inc/vj_io.h"

int main(int argc, char **argv) {
    // read input here
    unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH];
    load_image_file(argv[1], image);

    detect_face(image);

    char output_filename[BUF_SIZE];
    sprintf(output_filename, "%s_detect.pgm", argv[1]);
    save_image_file(output_filename, IMAGE_HEIGHT, IMAGE_WIDTH, image);
    return 0;
}



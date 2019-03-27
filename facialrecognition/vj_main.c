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
    if (load_image_file(argv[1], image) < 0) {
        return -1;
    }

    int success;
    detect_face(image, &success);
    if (!success) return 0;

    char output_filename[BUF_SIZE];
    sprintf(output_filename, "%s_detect.pgm", argv[1]);
    save_image_file(output_filename, IMAGE_HEIGHT, IMAGE_WIDTH, image);
    printf("image saved into %s!\n", output_filename);
    return 0;
}



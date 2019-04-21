/** @file main.c
 *  @brief entry point for Viola-Jones cascading classifier
 */

#define BUF_SIZE 50

#include <stdio.h>
#include "vj_types.h"
#include "detect_face.h"

static const char TEST_IMG[] = "subject01.gif.pgm";

int main(int argc, char **argv) {
    char buffer[BUF_SIZE];

    FILE *fp = fopen(TEST_IMG, "rb");
    if (fp == NULL) return -1;

    fgets(buffer, BUF_SIZE, fp);
    if (buffer[0] != 'P' || buffer[1] != '5') return -1;

    unsigned int width = 0;
    unsigned int height = 0;
    while (width == 0 || height == 0) {
        fgets(buffer, BUF_SIZE, fp);
        if (buffer[0] != '#') sscanf(buffer, "%d %d", &width, &height);
    }

    unsigned int max_brightness = 0;
    while (max_brightness == 0) {
        fgets(buffer, BUF_SIZE, fp);
        if (buffer[0] != '#') sscanf(buffer, "%d", &max_brightness);
    }

    unsigned char result_x1, result_y1, result_x2, result_y2;
    unsigned int row, col, i;
    char found = 0;

    for (row = 0; row < IMG_HEIGHT; row ++) {
        for (col = 0; col < IMG_WIDTH; col ++) {
            if (found != 0) return -1;
            found = detect_face((unsigned char)fgetc(fp),
                                &result_x1,
                                &result_y1,
                                &result_x2,
                                &result_y2);
        }
    }

    if (found != 1) return -1;

    fclose(fp);

    // print all faces
    for (i = 0; i < 1; i ++) {
        printf("Face:(%d,%d,%d,%d)\n",
               result_x1,
               result_y1,
               result_x2,
               result_y2);
    }
    return 0;
}



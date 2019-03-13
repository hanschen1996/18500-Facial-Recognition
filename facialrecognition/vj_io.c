/** @file read_pgm.c
 *  @brief read pgm images
 */

#define BUF_SIZE 1024

#include <assert.h>
#include <stdio.h>
#include "inc/vj_io.h"

int load_image_file(char *filename,
                    unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH]) {
    char buffer[BUF_SIZE];
    FILE *fp = fopen(filename, "rb");
    if (fp == NULL) {
        printf("Failed to open file %s\n", filename);
        return -1;
    }

    fgets(buffer, BUF_SIZE, fp);
    if (buffer[0] != 'P' || buffer[1] != '5') {
        printf("Input image is not a valid pgm file\n");
        return -1;
    }

    unsigned int width = 0;
    unsigned int height = 0;
    while (width == 0 || height == 0) {
        fgets(buffer, BUF_SIZE, fp);
        if (buffer[0] != '#') {
            assert(sscanf(buffer, "%d %d", &width, &height) == 2);
        }
    }

    if (width != IMAGE_WIDTH || height != IMAGE_HEIGHT) {
        printf("Input image does not have valid size\n");
        return -1;
    }

    unsigned int max_brightness = 0;
    while (max_brightness == 0) {
        fgets(buffer, BUF_SIZE, fp);
        if (buffer[0] != '#') {
            assert(sscanf(buffer, "%d", &max_brightness) == 1);
        }
    }
    assert(max_brightness == 255);

    for (unsigned int h = 0; h < IMAGE_HEIGHT; h++) {
        for (unsigned int w = 0; w < IMAGE_WIDTH; w++) {
            image[h][w] = (unsigned char)fgetc(fp);
        }
    }

    fclose(fp);
    return 0;
}

int save_image_file(char *filename,
                    unsigned int height,
                    unsigned int width,
                    unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH]) {
    FILE *fp = fopen(filename, "wb");
    if (fp == NULL) return -1;

    fputs("P5\n", fp);
    fprintf(fp, "%d %d\n", width, height);
    fprintf(fp, "%d\n", 255);

    for (unsigned int h = 0; h < height; h++) {
        for (unsigned int w = 0; w < width; w++) {
            fputc(image[h][w], fp);
        }
    }

    fclose(fp);
    return 0;
}



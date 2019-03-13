
#include "inc/vj_io.h"
#include "inc/vj_utils.h"
#include "inc/vj_types.h"

int main() {
    unsigned char image[IMAGE_HEIGHT][IMAGE_WIDTH];
    load_image_file("images/subject01.gif.pgm", image);
    scale(image, IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_HEIGHT / 1.25, IMAGE_WIDTH / 1.25);
    save_image_file("subject01.gif_scale.pgm", IMAGE_HEIGHT / 1.25, IMAGE_WIDTH / 1.25, image);
    return 0;
}


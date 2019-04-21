#define GET_II(IMG, II, H, W, ROW, COL) \
    for (ROW = 0; ROW < H; ROW ++) {\
        unsigned int accum = 0; \
        for (COL = 0; COL < W; COL ++) {\
            accum += IMG[ROW][COL]; \
            if (ROW == 0) {\
                II[ROW][COL] = accum;\
            } else {\
                II[ROW][COL] = accum + II[ROW - 1][COL];\
            }\
        }\
    }

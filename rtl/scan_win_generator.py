"""
a=""
for i in range(0,2913):
    a += "scan_win%d," % i
    if (i % 200 == 0):
        a+="\n"
print(a)
"""

for i in range(0,2913):
    print("  accum_calculator #(.RECT1_X(rectangle1_xs[%d]), .RECT1_Y(rectangle1_ys[%d]), .RECT1_WIDTH(rectangle1_widths[%d]), .RECT1_HEIGHT(rectangle1_heights[%d]), .RECT1_WEIGHT(rectangle1_weights[%d]), .RECT2_X(rectangle2_xs[%d]), .RECT2_Y(rectangle2_ys[%d]), .RECT2_WIDTH(rectangle2_widths[%d]), .RECT2_HEIGHT(rectangle2_heights[%d]), .RECT2_WEIGHT(rectangle2_weights[%d]), .RECT3_X(rectangle3_xs[%d]), .RECT3_Y(rectangle3_ys[%d]), .RECT3_WIDTH(rectangle3_widths[%d]), .RECT3_HEIGHT(rectangle3_heights[%d]), .RECT3_WEIGHT(rectangle3_weights[%d]), .FEAT_THRES(feature_thresholds[%d]), .FEAT_ABOVE(feature_aboves[%d]), .FEAT_BELOW(feature_belows[%d])) ac%d(.scan_win(scan_win%d), .scan_win_std_dev(scan_win_std_dev[%d]), .feature_accum(feature_accums[%d]));" % (i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i))

'''
a=""
for i in range(1,2913):
    a += "scan_win%d <= scan_win%d; " % (i, i-1)
    if (i%200 == 0):
        a+= "\n      "
print(a)
'''
'''
a=""
for i in range(0,2913):
    a += "scan_win%d <= 32'd0; " % (i)
    if (i%200 == 0):
        a+= "\n      "
print(a)
'''
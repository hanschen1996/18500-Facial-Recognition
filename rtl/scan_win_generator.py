"""
a=""
for i in range(0,2913):
    a += "scan_win%d," % i
    if (i % 200 == 0):
        a+="\n"
print(a)
"""
'''
for i in range(0,2913):
    print("accum_calculator ac%d(.scan_win(scan_win%d), .rectangle1_x(rectangle1_xs[%d]), .rectangle1_y(rectangle1_ys[%d]), .rectangle1_width(rectangle1_widths[%d]), .rectangle1_height(rectangle1_heights[%d]), .rectangle1_weight(rectangle1_weights[%d]), .rectangle2_x(rectangle2_xs[%d]), .rectangle2_y(rectangle2_ys[%d]), .rectangle2_width(rectangle2_widths[%d]), .rectangle2_height(rectangle2_heights[%d]), .rectangle2_weight(rectangle2_weights[%d]), .rectangle3_x(rectangle3_xs[%d]), .rectangle3_y(rectangle3_ys[%d]), .rectangle3_width(rectangle3_widths[%d]), .rectangle3_height(rectangle3_heights[%d]), .rectangle3_weight(rectangle3_weights[%d]), .feature_threshold(feature_thresholds[%d]), .feature_above(feature_aboves[%d]), .feature_below(feature_below[%d]), .scan_win_std_dev(scan_win_std_dev[%d]), .feature_accum(feature_accums[%d]));" % (i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i))
'''
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
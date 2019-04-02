
THRESHOLD = 0.4

def nms(boxes):
    boxes.sort(key=lambda x: x[-1], reverse=True)
    keep = [1] * len(boxes)
    area = list(map(lambda (x1,y1,x2,y2,_): (x2-x1)*(y2-y1), boxes))
    result = []

    for i in range(len(boxes)):
        if (not keep[i]): continue

        # current bounding box is a correct one
        result.append(boxes[i])

        # get its coordinates
        (x1,y1,x2,y2,_) = boxes[i]

        # loop through rest of the boxes
        for j in range(i+1, len(boxes)):
            if (not keep[j]): continue

            (x3,y3,x4,y4,_) = boxes[j]
            left_x = max(x1,x3)
            up_y = max(y1,y3)
            right_x = min(x2,x4)
            down_y = min(y2,y4)

            # get overlapping region
            overlap_area = 0
            if (left_x < right_x and up_y < down_y):
                overlap_area = (right_x-left_x)*(down_y-up_y)

            total_area = area[i] + area[j] - overlap_area
            if (float(overlap_area) / total_area > THRESHOLD):
                keep[j] = 0

    return result



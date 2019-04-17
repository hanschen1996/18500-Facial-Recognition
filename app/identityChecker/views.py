from django.shortcuts import render
import subprocess
import os
from django.contrib.auth.models import User
from identityChecker.forms import InputForm
from identityChecker.process_image import add_face, detect_face, CROP_IMG_SIZE, draw_bounding_box, output_image
from ....facial_recognition.recognition_train import train
from ....facial_recognition.recognition_test import recognition, test

(train_face_data, train_face_labels) = get_initial_train_data("../../facial_recognition")
(mean_face, num_eigen, eigen_vals, eigen_vecs, weights) = train(train_face_data)

def inputName(request):
    context = {}

    # Just display the input fields if this is a GET request.
    if request.method == 'GET':
        return render(request, 'identityChecker/name.html', context)
    
    if request.method == "POST":
        request.session['fname'] = request.POST['fname']
        request.session['lname'] = request.POST['lname']
        
    return render(request, 'identityChecker/home.html', context)

def home(request):
    context = {}
    return render(request, 'identityChecker/home.html', context)

def add(request):
    context = {}
#    print(request.session.get('fname'))
    return render(request, 'identityChecker/add.html', context)

def downloadImage(request):
    if request.method == 'POST':
        global train_face_data, train_face_labels
        global mean_face, num_eigen, eigen_vals, eigen_vecs, weights
        (new_face_data, new_face_labels) = add_face(request.session['fname'], request.session['lname'])

        # retrain the model
        train_face_data = np.concat((train_face_data, new_face_data))
        train_face_labels = np.concat((train_face_labels, new_face_labels))
        (mean_face, num_eigen, eigen_vals, eigen_vecs, weights) = train(train_face_data)

        # verify model health
        test(train_face_labels, mean_face, num_eigen, eigen_vals, eigen_vecs, weights)
    return render(request, 'identityChecker/download.html', {})

def checkIdentity(request):
    if request.method == 'POST':
        (orig_img, crop_img, boxes) = detect_face("test_image.png")

        # check if face is found
        if (len(boxes) > 0):
            (x1,y1,x2,y2,_) = boxes[0]
            draw_bounding_box(orig_img, x1, y1, x2, y2)
            output_image(orig_img, "test_image")
            face_label = recognition(np.array(crop_img).reshape(CROP_IMG_SIZE),
                                     train_face_labels,
                                     mean_face,
                                     num_eigen,
                                     eigen_vals,
                                     eigen_vecs,
                                     weights)

            print("person has face label %d"%(face_label))
        else:
            print("person face not found!")
    return render(request, 'identityChecker/checkIdentity.html', {})

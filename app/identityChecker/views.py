from django.shortcuts import render
import subprocess
import os
from django.contrib.auth.models import User
from identityChecker.forms import InputForm
from identityChecker.process_image import add_face, detect_face, CROP_IMG_SIZE, draw_bounding_box, output_image
import sys
import numpy as np
import serial

# add facial recognition library to path
curr_path = os.getcwd()
base_path_index = curr_path.find("app")
if (base_path_index == -1): sys.exit(-1)
sys.path.insert(0, curr_path[:base_path_index] + "facial_recognition")

from recognition_train import train
from recognition_test import recognition
from recognition_main import recognition_init

# initialize recognition system
(train_face_data, train_face_labels, names, mean_face, num_eigen, eigen_vals, eigen_vecs, weights) = recognition_init("../facial_recognition")
print("Recognition system initialized successfully!")

# open FPGA connection port
fpga_port = None
try:
    fpga_port = serial.Serial(port='COM3', baudrate=921600, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE, timeout=1)
    fpga_port.close()
    fpga_port.open()
    print("FPGA connection established successfully!")
except:
    print("FPGA connection failed to establish")


def inputName(request):
    context = {}

    # Just display the input fields if this is a GET request.
    if request.method == 'GET':
        return render(request, 'identityChecker/name.html', context)
        
    return render(request, 'identityChecker/add.html', context)

def home(request):
    context = {}
    return render(request, 'identityChecker/home.html', context)

def add(request):
    context = {}
    
    if request.method == "POST":
        request.session['fname'] = request.POST['fname']
        request.session['lname'] = request.POST['lname']
    return render(request, 'identityChecker/add.html', context)

def downloadImage(request):
    if request.method == 'POST':
        global train_face_data, train_face_labels
        global mean_face, num_eigen, eigen_vals, eigen_vecs, weights

        face_name = "%s_%s"%(request.session['fname'], request.session['lname'])
        (new_face_data, new_face_labels) = add_face(face_name, len(names), fpga_port=fpga_port)

        if (new_face_data is None):
            print("No face found for %s"%(face_name))
        else:
            # retrain the model
            train_face_data = np.concatenate((train_face_data, new_face_data))
            train_face_labels = np.concatenate((train_face_labels, new_face_labels))
            (mean_face, num_eigen, eigen_vals, eigen_vecs, weights) = train(train_face_data)
            names.append(face_name)
            name_file = open("../facial_recognition/labels", mode="a")
            name_file.write(face_name + "\n")
            name_file.close()
            print("Face added successfully for %s"%(face_name))
        
    return render(request, 'identityChecker/download.html', {})

def checkIdentity(request):
    return render(request, 'identityChecker/checkIdentity.html', {})

def displayIdentity(request):
    if request.method == 'POST':
        filename = "image"
        (orig_img, crop_img, boxes) = detect_face(filename + ".png", fpga_port=fpga_port)

        # check if face is found
        if (len(boxes) > 0):
            (x1,y1,x2,y2,_) = boxes[0]

            # save image to display for webapp
            output_image(orig_img, filename)
            face_label = recognition(np.array(crop_img).reshape(CROP_IMG_SIZE),
                                     train_face_labels,
                                     mean_face,
                                     num_eigen,
                                     eigen_vals,
                                     eigen_vecs,
                                     weights)
            name = names[face_label].replace("_", " ")
            print("You must be %s"%(name))
            request.session['identified_user'] = "You must be:" + name 
            request.session['identified'] = "T"
            
        else:
            print("person face not found!")
            request.session['identified_user'] = "Face not detected"
            request.session['identified'] = "F"
    return render(request, 'identityChecker/displayIdentity.html', {})


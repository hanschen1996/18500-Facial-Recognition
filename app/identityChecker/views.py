from django.shortcuts import render
import subprocess
import os
from django.contrib.auth.models import User
from identityChecker.forms import InputForm

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
        subprocess.call(['./script.sh'])
    return render(request, 'identityChecker/download.html', {})

def checkIdentity(request):
    return render(request, 'identityChecker/checkIdentity.html', {})
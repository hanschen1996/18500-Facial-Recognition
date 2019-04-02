from django.shortcuts import render
import subprocess
import os

def home(request):
    return render(request, 'identityChecker/home.html', {})

def add(request):
    return render(request, 'identityChecker/add.html', {})

def downloadImage(request):
    if request.method == 'POST':
        subprocess.call(['./script.sh'])
    return render(request, 'identityChecker/download.html', {})

def checkIdentity(request):
    return render(request, 'identityChecker/checkIdentity.html', {})
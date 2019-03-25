from django.shortcuts import render

def home(request):
    return render(request, 'identityChecker/home.html', {})

def add(request):
    return render(request, 'identityChecker/add.html', {})

def checkIdentity(request):
    return render(request, 'identityChecker/checkIdentity.html', {})
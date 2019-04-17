from django.urls import path
from django.contrib.auth import views as auth_views
from . import views

urlpatterns = [
    path('', views.inputName, name='inputName'), #change this to be default
    path('home', views.home, name='home'),
    path('add', views.add, name='add'),
    path('checkIdentity', views.checkIdentity, name='checkIdentity'),
    path('downloadImage', views.downloadImage, name='downloadImage')
]
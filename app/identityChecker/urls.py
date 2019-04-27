from django.urls import path
from django.contrib.auth import views as auth_views
from . import views

urlpatterns = [
    path('', views.home, name='home'), #change this to be default
    path('inputName', views.inputName, name='inputName'),
    path('add', views.add, name='add'),
    path('checkIdentity', views.checkIdentity, name='checkIdentity'),
    path('downloadImage', views.downloadImage, name='downloadImage'),
    path('displayIdentity', views.displayIdentity, name='displayIdentity')
]
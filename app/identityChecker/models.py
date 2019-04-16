from django.db import models
from django.contrib.auth.models import User

class Profile(models.Model):
    user          = models.ForeignKey(User, related_name='user', on_delete = models.DO_NOTHING, default=None)
    picture_1       = models.FileField(blank=True)
    picture_2       = models.FileField(blank=True)
    picture_3       = models.FileField(blank=True)
    picture_4       = models.FileField(blank=True)
    picture_5       = models.FileField(blank=True)
     
    def __unicode__(self):
        return 'id=' + str(self.id) + ',text="' + self.text + '"'

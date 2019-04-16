from django import forms

from django.contrib.auth.models import User
from identityChecker.models import Profile

class InputForm(forms.Form):
    class Meta:
        model = User
        fields = ('first_name', 'last_name')
        
        
    first_name = forms.CharField(max_length=20)
    last_name  = forms.CharField(max_length=20)

    # Customizes form validation for properties that apply to more
    # than one field.  Overrides the forms.Form.clean function.
    def clean(self):
        # Calls our parent (forms.Form) .clean function, gets a dictionary
        # of cleaned data as a result
        
        cleaned_data = super(InputForm, self).clean()

        # We must return the cleaned data we got from our parent.
        return cleaned_data
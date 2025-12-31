from rest_framework import serializers
from .models import Account, Transaction
from django.contrib.auth.models import User

# creating the serializer for the user 
#Purpose -> converts complex database objects into json 
#validates teh incoming data 

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model=User
        fields=['id','username','email','password']
        

    def create(self,validated_data):
        user=User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
        )
        return user

class AccountSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username')
    class Meta:
        model=Account
        fields=['id','username','balance']

class TransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model= Transaction
        fields=('id','amount','transaction_type','timestamp')

class AmountSerializer(serializers.Serializer):
    amount=serializers.DecimalField(max_digits=12,decimal_places=2)
    
    def validate_amount(self,value):
        if value<=0:
            raise serializers.ValidationError("Amount must be positive")
        return value

class TransferSerializer(serializers.Serializer):
    recipient_username = serializers.CharField()
    amount = serializers.DecimalField(max_digits=12, decimal_places=2)

    def validate_amount(self, value):
        if value <= 0:
            raise serializers.ValidationError("Amount must be positive.")
        return value
    
    def validate_recipient_username(self, value):
        if not User.objects.filter(username=value).exists():
            raise serializers.ValidationError("Recipient user does not exist.")
        return value

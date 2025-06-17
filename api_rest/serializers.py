from rest_framework import serializers
from .models import User, Task
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = [
            'username',
            'nickname',
            'id_user',
            'area',
            'age',
            'is_active',
            'is_staff',
            'is_admin',
            'date_joined',
            'photo',
            'password'
        ]
        read_only_fields = ['is_active', 'is_staff', 'is_admin', 'date_joined']

    def create(self, validated_data):
        password = validated_data.pop('password')
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user  # corrigido aqui

    def update(self, instance, validated_data):
        password = validated_data.pop('password', None)
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        if password:
            instance.set_password(password)
        instance.save()
        return instance


class TaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = Task
        fields = [
            'id',
            'title',
            'description',
            'is_completed',
            'updated_at',
            'created_at',
            'due_date',
            'priority',
        ]
        read_only_fields = ['id', 'updated_at', 'created_at']



class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        data = super().validate(attrs)

        # adiciona dados extras no retorno do token
        data.update({
            "username": self.user.username,
            "nickname": self.user.nickname,
            "id_user": self.user.id_user,
        })
        return data

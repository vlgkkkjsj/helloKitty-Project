from rest_framework import serializers
from .models import User, Task
from django.contrib.auth import authenticate
from django.utils.translation import gettext_lazy as _

# 🔐 Login tradicional (autenticação por sessão)
class LoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField(write_only=True, style={'input_type': 'password'})

    def validate(self, data):
        username = data.get("username")
        password = data.get("password")

        if username and password:
            user = authenticate(username=username.strip(), password=password)
            if user is not None:
                if not user.is_active:
                    raise serializers.ValidationError(_('Conta desativada.'), code='authorization')
                data["user"] = user  # será usada na view para login manual via login(request, user)
            else:
                raise serializers.ValidationError(_('Usuário ou senha inválidos.'), code='authorization')
        else:
            raise serializers.ValidationError(_('Preencha username e password.'), code='authorization')

        return data

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'nickname', 'id_user', 'area', 'age', 'password']
        extra_kwargs = {
            'password': {'write_only': True},
            'username': {'trim_whitespace': True},
            'nickname': {'required': True},
            'id_user': {'required': True},
        }

    def create(self, validated_data):
        password = validated_data.pop('password')
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user

    def update(self, instance, validated_data):
        password = validated_data.pop('password', None)
        for attr, value in validated_data.items():
            if isinstance(value, str):
                value = value.strip()
            setattr(instance, attr, value)
        if password:
            instance.set_password(password)
        instance.save()
        return instance

class TaskSerializer(serializers.ModelSerializer):
    user = serializers.SlugRelatedField(
        slug_field='username',
        queryset=User.objects.all()
    )

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
            'user',
        ]
        read_only_fields = ['id', 'updated_at', 'created_at']

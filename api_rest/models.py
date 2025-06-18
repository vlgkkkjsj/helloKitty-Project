from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin, Permission, Group
from django.core.exceptions import ValidationError
from django.db import models
from django.conf import settings
from django.utils import timezone

class UserManager(BaseUserManager):

    def create_user(self, username, password=None, nickname=None, area=None, age=None, id_user=None, **extra_fields):
        if not username:
            raise ValueError('O nome de usuário deve ser fornecido')
        
        username = self.model.normalize_username(username.strip())
        
        user = self.model(
            username=username,
            nickname=(nickname or '').strip() if nickname else '',
            area=(area or '').strip() if area else '',
            age=age,
            id_user=id_user,
            **extra_fields
        )
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, password=None, nickname=None, **extra_fields):
        if not username:
            raise ValueError('O nome de usuário deve ser fornecido')

        user = self.create_user(
            username=username,
            password=password,
            nickname=nickname,
            **extra_fields
        )
        user.is_staff = True
        user.is_admin = True
        user.is_superuser = True
        user.save(using=self._db)
        return user

    def create_admin(self, username, password=None, nickname=None, id_user=None, **extra_fields):
        if not username:
            raise ValueError('O nome de usuário deve ser fornecido')

        user = self.create_user(
            username=username,
            password=password,
            nickname=nickname,
            id_user=id_user,
            **extra_fields
        )
        user.is_staff = True
        user.is_admin = True
        user.is_superuser = False
        user.save(using=self._db)
        return user


class User(AbstractBaseUser, PermissionsMixin):
    username = models.CharField(max_length=100, unique=True)  # removido primary_key para evitar problemas
    nickname = models.CharField(max_length=100)
    id_user = models.CharField(max_length=18, unique=True)
    area = models.CharField(max_length=100, blank=True)
    age = models.PositiveIntegerField(null=True, blank=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_admin = models.BooleanField(default=False)
    date_joined = models.DateTimeField(default=timezone.now)
    photo = models.ImageField(upload_to='profile_photos/', null=True, blank=True)

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['nickname', 'id_user']  # id_user adicionado para obrigar no createsuperuser

    objects = UserManager()

    def __str__(self):
        return f'{self.nickname} ({self.username})'

    def clean(self):
        super().clean()
        if self.age is not None and (self.age < 0 or self.age > 120):
            raise ValidationError({'age': 'A idade deve estar entre 0 e 120'})
        if self.id_user and len(self.id_user) != 18:
            raise ValidationError({'id_user': 'O ID deve ter 18 caracteres.'})

    def save(self, *args, **kwargs):
        if self.username:
            self.username = self.username.strip()
        if self.nickname:
            self.nickname = self.nickname.strip()
        super().save(*args, **kwargs)


class PriorityChoices(models.TextChoices):
    LOW = 'Low', 'Low'
    MEDIUM = 'Medium', 'Medium'
    HIGH = 'High', 'High'


class Task(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='tasks'
    )
    title = models.CharField(max_length=150)
    description = models.TextField(blank=True, null=True)
    is_completed = models.BooleanField(default=False)
    updated_at = models.DateTimeField(auto_now=True)
    created_at = models.DateTimeField(auto_now_add=True)
    due_date = models.DateField(null=True, blank=True)
    priority = models.CharField(
        max_length=15,
        choices=PriorityChoices.choices,
        default=PriorityChoices.MEDIUM
    )
    
    def __str__(self):
        return f'{self.title} ({self.user.nickname})'

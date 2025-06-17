from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin, Permission, Group
from django.core.exceptions import ValidationError
from django.db import models
from django.conf import settings
from django.utils import timezone
from django.utils.translation import gettext_lazy as _

class UserManager(BaseUserManager):
    
    def create_user(self, nickname, area, age, username, password=None, id_user=None, **extra_fields):
        if not username:
            raise ValueError('O nome de usuário deve ser fornecido')
        user = self.model(
            nickname=nickname.strip(),
            id_user=id_user,
            area=area,
            age=age,
            username=self.model.normalize_username(username.strip()),
            **extra_fields
        )
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, nickname, username, password=None, **extra_fields):
        if not username:
            raise ValueError('O nome de usuário deve ser fornecido')
         
        superuser = self.model(
            nickname=nickname.strip(),
            username=self.model.normalize_username(username.strip()),
            **extra_fields
        )
        superuser.is_staff = True
        superuser.is_admin = True
        superuser.is_superuser = True
        superuser.set_password(password)
        superuser.save(using=self._db)
        return superuser
    
    def create_admin(self, nickname, username, password=None, id_user=None, **extra_fields):
        if not username:
            raise ValueError('O nome de usuário deve ser fornecido')

        admin = self.model(
            nickname=nickname.strip(),
            username=self.model.normalize_username(username.strip()),
            id_user=id_user,
            **extra_fields
        )
        admin.set_password(password)
        admin.is_staff = True
        admin.is_admin = True
        admin.is_superuser = False
        admin.save(using=self._db)
        return admin

class User(AbstractBaseUser, PermissionsMixin):
    username = models.CharField(max_length=100, unique=True, primary_key=True)  # OK, mas considere remover primary_key
    nickname = models.CharField(max_length=100)
    id_user = models.CharField(max_length=18, unique=True)
    area = models.CharField(max_length=100, blank=True)
    age = models.PositiveIntegerField(null=True, blank=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_admin = models.BooleanField(default=False)
    date_joined = models.DateTimeField(default=timezone.now)
    photo = models.ImageField(upload_to='profile_photos/', null=True, blank=True)

    groups = models.ManyToManyField(
        Group,
        related_name='custom_user_set',
        blank=True,
        help_text='Grupos aos quais este usuário pertence.',
        verbose_name='grupos',
    )
    user_permissions = models.ManyToManyField(
        Permission,
        related_name='custom_user_permissions',
        blank=True,
        help_text='Permissões específicas deste usuário.',
        verbose_name='permissões de usuário',
    )

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['nickname']

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
        self.username = self.username.strip()
        self.nickname = self.nickname.strip()
        super().save(*args, **kwargs)


class PriorityChoices(models.TextChoices):
    LOW = 'Low',
    MEDIUM = 'Medium',
    HIGH = 'High', 

class Task(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='tasks'
    )
    title = models.CharField(max_length=150)
    description = models.TextField(blank=True, null=True)
    is_completed = models.BooleanField(default=False)
    updated_at = models.DateTimeField(auto_now=True)  # CORRIGIR para 'updated_at'
    created_at = models.DateTimeField(auto_now_add=True)
    due_date = models.DateField(null=True, blank=True)
    priority = models.CharField(
        max_length=15,
        choices=PriorityChoices.choices,
        default=PriorityChoices.MEDIUM
    )
    
    def __str__(self):
        return f'{self.title} ({self.user.nickname})'

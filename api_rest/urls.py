# api_rest/urls.py
from django.urls import path
from .views import (
    HomeAPIView,
    RegisterAPIView,
    LoginAPIView,
    TaskAPIView,
    
)

urlpatterns = [
    path('', HomeAPIView.as_view(), name='home'),
    path('register/', RegisterAPIView.as_view(), name='register'),
    path('login/', LoginAPIView.as_view(), name='login'),
    path('tasks/', TaskAPIView.as_view(), name='tasks'),
    path('tasks/<int:pk>/', TaskAPIView.as_view(), name='task-detail'),
]

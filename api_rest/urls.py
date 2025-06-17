# api_rest/urls.py
from django.urls import path
from .views import TaskAPIView, HomeAPIView

urlpatterns = [
    path('', TaskAPIView.as_view(), name='task-list-create'),           # /api/
    path('<int:pk>/', TaskAPIView.as_view(), name='task-detail'),       # /api/1/
    path('home/', HomeAPIView.as_view(), name='home'),                   # /api/home/
]

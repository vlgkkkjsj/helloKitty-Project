from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from django.http import JsonResponse
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django.contrib.auth import get_user_model




from .models import Task
from .serializers import TaskSerializer
from django.shortcuts import get_object_or_404
from django.utils.timezone import now

import logging


User = get_user_model()


logger = logging.getLogger(__name__)

# views.py
from rest_framework_simplejwt.views import TokenObtainPairView
from .serializers import CustomTokenObtainPairSerializer

class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer


class TaskAPIView(APIView):
    authentication_classes = []
    permission_classes = []

    def get(self, request, pk=None):
        if pk:
            task = get_object_or_404(Task, pk=pk)
            serializer = TaskSerializer(task)
            return Response(serializer.data)
        else:
            tasks = Task.objects.all()
            serializer = TaskSerializer(tasks, many=True)
            return Response(serializer.data)

  
    def post(self, request):
        username = request.data.get("user")
        if not username:
            return Response({"error": "Campo 'user' é obrigatório."}, status=status.HTTP_400_BAD_REQUEST)
    
        try:
            user = User.objects.get(username=username)
        except User.DoesNotExist:
            return Response({"error": "Usuário não encontrado."}, status=status.HTTP_404_NOT_FOUND)
    
        serializer = TaskSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=user)  # agora tem usuário válido
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


    def put(self, request, pk: int):
        """
        Atualiza uma tarefa existente.
        """
        task = get_object_or_404(Task, pk=pk)
        serializer = TaskSerializer(task, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk: int):
        """
        Deleta uma tarefa.
        """
        task = get_object_or_404(Task, pk=pk)
        task.delete()
        return Response({'detail': 'Tarefa deletada com sucesso'}, status=status.HTTP_204_NO_CONTENT)

    
class HomeAPIView(APIView):
    permission_classes = []

    def get(self, request):
        return Response({"message": f"Bem-vindo, {request.user.username}!"})
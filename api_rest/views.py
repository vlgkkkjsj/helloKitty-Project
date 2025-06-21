from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import get_user_model, authenticate
from django.shortcuts import get_object_or_404
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import SessionAuthentication, BasicAuthentication

from .models import Task
from .serializers import (
    UserSerializer,
    TaskSerializer,
    LoginSerializer,

)


User = get_user_model()

# ====================== REGISTER ======================

class RegisterAPIView(APIView):
    permission_classes = []

    def get(self, request):
        return Response(
            {"message": "API de cadastro. Envie uma requisição POST para criar um usuário."},
            status=status.HTTP_200_OK
        )

    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            return Response({
                "message": "Usuário criado com sucesso",
                "user": UserSerializer(user).data
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# ====================== LOGIN ======================

class LoginAPIView(APIView):
    permission_classes = []

    def post(self, request):
        username = request.data.get("username")
        password = request.data.get("password")

        if not username or not password:
            return Response(
                {"error": "Informe username e password."},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            user = User.objects.get(username=username)
            if user.check_password(password):
                return Response({
                    "message": "Login bem-sucedido",
                    "user": {
                        "id": user.id,
                        "username": user.username,
                        "nickname": user.nickname,
                        "id_user": user.id_user
                    }
                }, status=status.HTTP_200_OK)
            else:
                return Response(
                    {"error": "Senha inválida"},
                    status=status.HTTP_401_UNAUTHORIZED
                )
        except User.DoesNotExist:
            return Response(
                {"error": "Usuário não encontrado"},
                status=status.HTTP_404_NOT_FOUND
            )

# ====================== TASK CRUD ======================
class TaskAPIView(APIView):
    authentication_classes = []
    permission_classes = []

    def get(self, request, pk=None):
        username = request.query_params.get('user')  # Pega o usuário da URL (?user=username)
        if pk:
            task = get_object_or_404(Task, pk=pk)
            serializer = TaskSerializer(task)
            return Response(serializer.data)

        if not username:
            return Response({'error': 'Campo "user" é obrigatório.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(username=username)
        except User.DoesNotExist:
            return Response({'error': 'Usuário não encontrado.'}, status=status.HTTP_404_NOT_FOUND)

        tasks = Task.objects.filter(user=user)  # Filtra as tasks do user
        serializer = TaskSerializer(tasks, many=True)
        return Response(serializer.data)
    

    def post(self, request):
        username = request.data.get('user')
        if not username:
            return Response({'error': 'Campo "user" é obrigatório.'}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            user = User.objects.get(username=username)
        except User.DoesNotExist:
            return Response({'error': 'Usuário não encontrado.'}, status=status.HTTP_404_NOT_FOUND)

        serializer = TaskSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk: int):
        task = get_object_or_404(Task, pk=pk)
        serializer = TaskSerializer(task, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk: int):
        task = get_object_or_404(Task, pk=pk)
        task.delete()
        return Response({'detail': 'Tarefa deletada com sucesso'}, status=status.HTTP_204_NO_CONTENT)

# ====================== HOME ======================

class HomeAPIView(APIView):
    permission_classes = []

    def get(self, request):
        return Response({"message": "API está funcionando corretamente!"})


# ====================== JWT (Opcional) ======================

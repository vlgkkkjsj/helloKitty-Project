from django.urls import path, include
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),       # /token/
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),      # /token/refresh/
    path('api/', include('api_rest.urls')),                                        # /api/...
]

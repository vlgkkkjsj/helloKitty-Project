from django.urls import path, include

urlpatterns = [
      # /token/refresh/
    path('api/', include('api_rest.urls')),                                        # /api/...
]

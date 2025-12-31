from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .views import RegisterView, AccountInitView, DepositView, WithdrawView, TransactionHistoryView, TransferView
urlpatterns = [
    # Auth
    path('auth/register/', RegisterView.as_view(), name='register'),
    path('auth/login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    # Account
    path('account/', AccountInitView.as_view(), name='account_detail'),
    path('account/deposit/', DepositView.as_view(), name='deposit'),
    path('account/withdraw/', WithdrawView.as_view(), name='withdraw'),
    path('account/transfer/', TransferView.as_view(), name='transfer'),
    path('transactions/', TransactionHistoryView.as_view(), name='transactions'),
]
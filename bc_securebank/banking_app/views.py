from rest_framework import generics, status, views
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from django.db import transaction
from .models import Account, Transaction
from .serializers import UserSerializer, AccountSerializer, TransactionSerializer, AmountSerializer, TransferSerializer
from django.contrib.auth.models import User
from decimal import Decimal
# 1. User Registration
class RegisterView(generics.CreateAPIView):
    serializer_class = UserSerializer
    permission_classes = [AllowAny]
# 2. Get Account Balance
class AccountInitView(generics.RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = AccountSerializer
    def get_object(self):
        return self.request.user.account
# 3. Deposit Money (Atomic)
class DepositView(views.APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request):
        serializer = AmountSerializer(data=request.data)
        if serializer.is_valid():
            amount = serializer.validated_data['amount']
            
            with transaction.atomic():
                account = request.user.account
                # Lock the row for update to prevent race conditions
                account = Account.objects.select_for_update().get(id=account.id)
                
                account.balance += amount
                account.save()
                
                Transaction.objects.create(
                    account=account,
                    amount=amount,
                    transaction_type='DEPOSIT'
                )
            
            return Response(
                {"message": "Deposit successful", "new_balance": account.balance},
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
# 4. Withdraw Money (Atomic)
class WithdrawView(views.APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request):
        serializer = AmountSerializer(data=request.data)
        if serializer.is_valid():
            amount = serializer.validated_data['amount']
            
            with transaction.atomic():
                account = request.user.account
                # Lock row
                account = Account.objects.select_for_update().get(id=account.id)
                
                if account.balance < amount:
                    return Response(
                        {"error": "Insufficient funds"}, 
                        status=status.HTTP_400_BAD_REQUEST
                    )
                
                account.balance -= amount
                account.save()
                
                Transaction.objects.create(
                    account=account,
                    amount=amount,
                    transaction_type='WITHDRAW'
                )
            
            return Response(
                {"message": "Withdrawal successful", "new_balance": account.balance},
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
# 5. Transaction History
class TransactionHistoryView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = TransactionSerializer
    def get_queryset(self):
        return Transaction.objects.filter(account=self.request.user.account).order_by('-timestamp')

# 6. Transfer Money (Atomic)
class TransferView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = TransferSerializer(data=request.data)
        if serializer.is_valid():
            amount = serializer.validated_data['amount']
            recipient_username = serializer.validated_data['recipient_username']
            
            with transaction.atomic():
                sender_account = request.user.account
                # Lock sender row
                sender_account = Account.objects.select_for_update().get(id=sender_account.id)
                
                if sender_account.balance < amount:
                    return Response(
                        {"error": "Insufficient funds"}, 
                        status=status.HTTP_400_BAD_REQUEST
                    )
                
                # Get Recipient Account (Locking not strictly necessary if only adding, but good practice)
                recipient_user = User.objects.get(username=recipient_username)
                if recipient_user == request.user:
                     return Response(
                        {"error": "Cannot transfer to yourself"}, 
                        status=status.HTTP_400_BAD_REQUEST
                    )
                
                recipient_account = Account.objects.select_for_update().get(user=recipient_user)

                # Perform Transfer
                sender_account.balance -= amount
                recipient_account.balance += amount
                
                sender_account.save()
                recipient_account.save()
                
                # Log Transactions
                Transaction.objects.create(
                    account=sender_account,
                    amount=amount,
                    transaction_type='TRANSFER' # Outgoing
                )
                Transaction.objects.create(
                    account=recipient_account,
                    amount=amount,
                    transaction_type='DEPOSIT' # Incoming logged as Deposit or could be TRANSFER_IN if we want specific type
                )

            return Response(
                {"message": "Transfer successful", "new_balance": sender_account.balance},
                status=status.HTTP_200_OK
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
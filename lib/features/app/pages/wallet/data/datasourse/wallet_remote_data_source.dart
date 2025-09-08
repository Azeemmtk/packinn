import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../core/error/exceptions.dart';
import '../model/transaction model.dart';
import '../model/payment_model.dart';

abstract class WalletRemoteDataSource {
  Future<double> getWalletBalance(String userId);
  Future<void> addToWallet(String userId, double amount, String description);
  Future<void> deductFromWallet(String userId, double amount, String description, String? paymentId);
  Future<List<TransactionModel>> getTransactions(String userId);
  Future<List<PaymentModel>> getPayments(String userId);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final FirebaseFirestore firestore;

  WalletRemoteDataSourceImpl(this.firestore);

  @override
  Future<double> getWalletBalance(String userId) async {
    try {
      print('Fetching wallet balance for userId: $userId');
      final doc = await firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        await firestore.collection('users').doc(userId).set({'walletBalance': 0.0});
        return 0.0;
      }
      final balance = (doc.data()?['walletBalance'] as num?)?.toDouble() ?? 0.0;
      print('Retrieved balance: $balance INR');
      return balance;
    } catch (e) {
      print('Error fetching wallet balance: $e');
      throw ServerException('Failed to get wallet balance: $e');
    }
  }

  @override
  Future<void> addToWallet(String userId, double amount, String description) async {
    try {
      print('Adding $amount INR to wallet for user: $userId');
      await firestore.runTransaction((transaction) async {
        final userRef = firestore.collection('users').doc(userId);
        final transactionRef = firestore.collection('transactions').doc();

        final userDoc = await transaction.get(userRef);
        final currentBalance = (userDoc.data()?['walletBalance'] as num?)?.toDouble() ?? 0.0;

        transaction.update(userRef, {'walletBalance': currentBalance + amount});
        transaction.set(transactionRef, {
          'id': transactionRef.id,
          'userId': userId,
          'type': 'credit',
          'amount': amount,
          'description': description,
          'timestamp': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      print('Error adding to wallet: $e');
      throw ServerException('Failed to add to wallet: $e');
    }
  }

  @override
  Future<void> deductFromWallet(String userId, double amount, String description, String? paymentId) async {
    try {
      print('Deducting $amount INR from wallet for user: $userId');
      await firestore.runTransaction((transaction) async {
        final userRef = firestore.collection('users').doc(userId);
        final transactionRef = firestore.collection('transactions').doc();

        final userDoc = await transaction.get(userRef);
        final currentBalance = (userDoc.data()?['walletBalance'] as num?)?.toDouble() ?? 0.0;

        if (currentBalance < amount) {
          throw ServerException('Insufficient wallet balance');
        }

        transaction.update(userRef, {'walletBalance': currentBalance - amount});
        final transactionData = {
          'id': transactionRef.id,
          'userId': userId,
          'type': 'debit',
          'amount': amount,
          'description': description,
          'timestamp': FieldValue.serverTimestamp(),
        };
        if (paymentId != null) {
          transactionData['paymentId'] = paymentId;
        }
        transaction.set(transactionRef, transactionData);
      });
    } catch (e) {
      print('Error deducting from wallet: $e');
      throw ServerException('Failed to deduct from wallet: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching transactions: $e');
      throw ServerException('Failed to get transactions: $e');
    }
  }

  @override
  Future<List<PaymentModel>> getPayments(String userId) async {
    try {
      print('Fetching payments for userId: $userId');
      final querySnapshot = await firestore
          .collection('payments') // Adjust if your collection name is different
          .where('userId', isEqualTo: userId)
          .get();
      final payments = querySnapshot.docs
          .map((doc) => PaymentModel.fromJson(doc.data()))
          .toList();
      print('Payments retrieved: $payments');
      return payments;
    } catch (e) {
      print('Error fetching payments: $e');
      throw ServerException('Failed to get payments: $e');
    }
  }
}
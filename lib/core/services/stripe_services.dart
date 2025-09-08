import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:packinn/core/constants/stripe.dart';

class StripeService {
  static final StripeService _instance = StripeService._internal();
  factory StripeService() => _instance;
  StripeService._internal();

  static String stripeSecretKey = stripeSecretK;
  static String stripePublishableKey = stripePublishableK;
  static const double inrToUsdRate = 83.33; // 1 USD = 83.33 INR

  Future<bool> makePayment({required double amount}) async {
    try {
      // Convert INR amount to USD
      final usdAmount = amount / inrToUsdRate;
      final amountInCents = (usdAmount * 100).toInt(); // Convert to cents for Stripe
      print('Processing Stripe payment: $amount INR = $usdAmount USD ($amountInCents cents)');

      // Create payment intent
      final paymentIntent = await _createPaymentIntent(amountInCents);
      print('Payment intent created: ${paymentIntent['id']}');

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'PackInn',
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();
      print('Stripe payment successful');
      return true;
    } catch (e) {
      print('Stripe payment failed: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(int amountInCents) async {
    final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
    final headers = {
      'Authorization': 'Bearer $stripeSecretKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final body = {
      'amount': amountInCents.toString(),
      'currency': 'usd', // Stripe processes in USD
      'payment_method_types[]': 'card',
    };

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode != 200) {
      print('Stripe API error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to create payment intent: ${response.body}');
    }
    return jsonDecode(response.body);
  }
}
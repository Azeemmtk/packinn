import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:packinn/core/constants/stripe.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<bool> makePayment({required double amount}) async {
    try {
      String? result = await _cretePaymentIntent(amount, 'usd');

      if (result == null) return false;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: result,
          merchantDisplayName: 'Azeem Ali'
        ),
      );
      await _processPayment();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _cretePaymentIntent(double amount, String currency) async {
    try {
      final Dio dio = Dio();

      Map<String, dynamic> data = {
        'amount': _calculateAmount(amount),
        'currency': currency,
      };

      var response = await dio.post('https://api.stripe.com/v1/payment_intents',
          data: data,
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'content_type': 'application/x-www-form-urlencoded',
          }));
      if (response.data != null) {
        return response.data['client_secret'];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _processPayment() async{
    try{
      await Stripe.instance.presentPaymentSheet();

    } catch (e){
      print(e);
      rethrow;
    }
  }

  String _calculateAmount(double amount) {

    double usdAmount= amount * 0.012;

    return (usdAmount * 100).toInt().toString();
  }
}

import 'package:flutter_dotenv/flutter_dotenv.dart';

final String stripePublishableK = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
final String stripeSecretK = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
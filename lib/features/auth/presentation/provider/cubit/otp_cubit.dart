// otp_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpCubit extends Cubit<String> {
  OtpCubit() : super("");

  void updateOtp(String otp) {
    print(otp);
    emit(otp);
  }
  void clearOtp() => emit("");
}

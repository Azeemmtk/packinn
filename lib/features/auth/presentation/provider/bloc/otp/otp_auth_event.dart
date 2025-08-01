import 'package:equatable/equatable.dart';

abstract class OtpAuthEvent extends Equatable {
  const OtpAuthEvent();

  @override
  List<Object?> get props => [];
}

class OtpAuthSendOtp extends OtpAuthEvent {
  final String phoneNumber;

  const OtpAuthSendOtp(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class OtpAuthVerifyOtp extends OtpAuthEvent {
  final String verificationId;
  final String otp;

  const OtpAuthVerifyOtp(this.verificationId, this.otp);

  @override
  List<Object> get props => [verificationId, otp];
}

class OtpAuthCheckEmail extends OtpAuthEvent {
  final String email;

  const OtpAuthCheckEmail(this.email);

  @override
  List<Object> get props => [email];
}
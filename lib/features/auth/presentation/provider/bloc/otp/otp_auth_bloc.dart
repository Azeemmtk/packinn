import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../domain/usecase/send-otp.dart';
import '../../../../domain/usecase/verify_otp.dart';
import 'otp_auth_event.dart';
import 'otp_auth_state.dart';

class OtpAuthBloc extends Bloc<OtpAuthEvent, OtpAuthState> {
  final SendOtp sendOtp;
  final VerifyOtp verifyOtp;
  final FirebaseFirestore firestore;

  OtpAuthBloc({
    required this.sendOtp,
    required this.verifyOtp,
    required this.firestore,
  }) : super(const OtpAuthInitial()) {
    on<OtpAuthSendOtp>(_onSendOtp);
    on<OtpAuthVerifyOtp>(_onVerifyOtp);
    on<OtpAuthCheckEmail>(_onCheckEmail);
  }

  Future<void> _onSendOtp(
      OtpAuthSendOtp event, Emitter<OtpAuthState> emit) async {
    emit(const OtpAuthLoading());
    final result = await sendOtp(event.phoneNumber);
    result.fold(
          (failure) => emit(OtpAuthError(message: failure.message)),
          (verificationId) => emit(OtpSent(verificationId)),
    );
  }

  Future<void> _onVerifyOtp(
      OtpAuthVerifyOtp event, Emitter<OtpAuthState> emit) async {
    emit(const OtpAuthLoading());
    final result = await verifyOtp(
        VerifyOtpParams(verificationId: event.verificationId, otp: event.otp));
    result.fold(
          (failure) => emit(OtpAuthError(message: failure.message)),
          (authResult) {
        if (authResult.phoneVerified) {
          emit(OtpAuthAuthenticated(user: authResult));
        } else {
          emit(const OtpAuthError(message: 'Verification failed'));
        }
      },
    );
  }

  Future<void> _onCheckEmail(
      OtpAuthCheckEmail event, Emitter<OtpAuthState> emit) async {
    emit(const OtpAuthLoading());
    try {
      // Check both users and hostel_owners collections
      final userQuery = await firestore
          .collection('users')
          .where('email', isEqualTo: event.email)
          .get();
      final hostelOwnerQuery = await firestore
          .collection('hostel_owners')
          .where('email', isEqualTo: event.email)
          .get();

      final emailExists = userQuery.docs.isNotEmpty || hostelOwnerQuery.docs.isNotEmpty;
      emit(OtpEmailChecked(emailExists: emailExists));
    } catch (e) {
      emit(OtpAuthError(message: 'Failed to check email: $e'));
    }
  }
}
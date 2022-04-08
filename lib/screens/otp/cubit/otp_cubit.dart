import 'package:assignment1/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final String? phone;
  final String? verificationId;
  OtpCubit({@required this.phone, @required this.verificationId})
      : super(OtpState.initial()) {
    emit(state.copyWith(phone: phone, verificationId: verificationId));
  }

  void otpChanged(String? value) {
    emit(state.copyWith(otp: value, status: OtpStatus.initial));
  }

  void submitOtp() async {
    if (!state.isFormValid || state.status == OtpStatus.submitting) return;
    emit(state.copyWith(status: OtpStatus.submitting));
    try {
      auth.PhoneAuthCredential credential = auth.PhoneAuthProvider.credential(
        verificationId: state.verificationId!,
        smsCode: state.otp!,
      );
      await auth.FirebaseAuth.instance.signInWithCredential(credential);
      emit(state.copyWith(status: OtpStatus.success));
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'invalid-phone-number') {
        emit(state.copyWith(
          status: OtpStatus.error,
          failure: const Failure(
            message: 'Invalid Mobile Number',
          ),
        ));
      } else if (e.code == 'invalid-verification-code') {
        emit(state.copyWith(
          status: OtpStatus.error,
          failure: const Failure(
            message: 'The OTP entered is incorrect.',
          ),
        ));
      } else {
        emit(state.copyWith(
          status: OtpStatus.error,
          failure: const Failure(
            message: 'An error occurred. Please try again later.',
          ),
        ));
      }
      print(e.message);
    }
  }
}

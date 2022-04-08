import 'package:assignment1/models/models.dart';
import 'package:assignment1/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository? _authRepository;

  LoginCubit({@required AuthRepository? authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void phoneChanged(String? value) {
    emit(state.copyWith(phone: value, status: LoginStatus.initial));
  }

  void logInWithCredentials() async {
    if (!state.isFormValid || state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      _authRepository?.loginWithPhone(
        phoneNumber: '+91${state.phone}',
        verificationCompleted: (auth.PhoneAuthCredential credential) async* {
          await auth.FirebaseAuth.instance.signInWithCredential(credential);
          //     .then((value) async {
          //   // if (value.user != null) {
          //   //   await _firebaseFirestore
          //   //       .collection(Paths.users)
          //   //       .doc(value.user!.uid)
          //   //       .set(state.user!.toDocument());
          //   // }
          // });
          emit(state.copyWith(status: LoginStatus.success));
        },
        verificationFailed: (auth.FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            emit(
              state.copyWith(
                failure: const Failure(message: 'Invalid Mobile Number'),
                status: LoginStatus.error,
              ),
            );
          }
          if (e.code == 'invalid-verification-code') {
            emit(
              state.copyWith(
                failure: const Failure(
                    message: 'Please check the OTP you have entered.'),
                status: LoginStatus.error,
              ),
            );
          }
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          emit(state.copyWith(
              verificationId: verificationId, status: LoginStatus.codeSent));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          emit(LoginState.initial());
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          failure: const Failure(
            message: 'An error occurred. Please try again later.',
          ),
        ),
      );
    }
  }
}

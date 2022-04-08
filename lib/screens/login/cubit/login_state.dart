part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, codeSent, success, error }

class LoginState extends Equatable {
  final String? phone;
  final String? verificationId;
  final LoginStatus? status;
  final Failure? failure;

  const LoginState({
    @required this.phone,
    @required this.verificationId,
    @required this.status,
    @required this.failure,
  });

  factory LoginState.initial() {
    return const LoginState(
      phone: '',
      verificationId: '',
      status: LoginStatus.initial,
      failure: Failure(),
    );
  }

  bool get isFormValid => phone!.isNotEmpty && phone!.length == 10;

  @override
  List<Object?> get props => [phone, status, failure];

  LoginState copyWith({
    String? phone,
    String? verificationId,
    LoginStatus? status,
    Failure? failure,
  }) {
    return LoginState(
      phone: phone ?? this.phone,
      verificationId: verificationId ?? this.verificationId,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}

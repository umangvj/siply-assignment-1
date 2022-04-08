part of 'otp_cubit.dart';

enum OtpStatus { initial, submitting, success, error }

class OtpState extends Equatable {
  final String? phone;
  final String? verificationId;
  final String? otp;
  final OtpStatus? status;
  final Failure? failure;

  const OtpState({
    @required this.phone,
    @required this.verificationId,
    @required this.otp,
    @required this.status,
    @required this.failure,
  });

  factory OtpState.initial() {
    return const OtpState(
      phone: '',
      verificationId: '',
      otp: '',
      status: OtpStatus.initial,
      failure: Failure(),
    );
  }

  bool get isFormValid => otp!.length == 6 && verificationId!.isNotEmpty;

  @override
  List<Object?> get props => [phone, verificationId, otp, status, failure];

  OtpState copyWith({
    String? phone,
    String? verificationId,
    String? otp,
    OtpStatus? status,
    Failure? failure,
  }) {
    return OtpState(
      phone: phone ?? this.phone,
      verificationId: verificationId ?? this.verificationId,
      otp: otp ?? this.otp,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}

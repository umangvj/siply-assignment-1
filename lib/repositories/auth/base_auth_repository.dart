import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:meta/meta.dart';

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;
  Future<void> loginWithPhone({
    @required String? phoneNumber,
    @required Function(auth.FirebaseAuthException e)? verificationFailed,
    @required Function(String verificationId, int? resendToken)? codeSent,
    @required Function(String verificationId)? codeAutoRetrievalTimeout,
  });
}

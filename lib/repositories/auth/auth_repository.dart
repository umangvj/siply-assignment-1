import 'package:assignment1/repositories/repositories.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:meta/meta.dart';

class AuthRepository extends BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({
    auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

  @override
  Future<void> loginWithPhone({
    @required String? phoneNumber,
    @required
        Function(auth.PhoneAuthCredential credential)? verificationCompleted,
    @required Function(auth.FirebaseAuthException e)? verificationFailed,
    @required Function(String verificationId, int? resendToken)? codeSent,
    @required Function(String verificationId)? codeAutoRetrievalTimeout,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber!,
        verificationCompleted: verificationCompleted!,
        verificationFailed: verificationFailed!,
        codeSent: codeSent!,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout!,
        timeout: const Duration(seconds: 120),
      );
    } catch (e) {
      print('An error occurred.');
    }
  }
}

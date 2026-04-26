import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserModel {
  final String uid;
  final String? contact;
  final String? name;

  UserModel({required this.uid, this.contact, this.name = "Verified User"});
}

final authControllerProvider = StateNotifierProvider<AuthController, UserModel?>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<UserModel?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthController() : super(null) {
    // Listen to Auth State Changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        state = UserModel(uid: user.uid, contact: user.phoneNumber, name: user.displayName);
      } else {
        state = null;
      }
    });
  }

  // Send OTP to Phone
  Future<void> sendOtp({
    required String contact,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: contact,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? "Verification failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify the OTP
  Future<void> verifyOtp({
    required String verificationId,
    required String smsCode,
    required String contact,
    required Function() onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    state = null;
  }
}

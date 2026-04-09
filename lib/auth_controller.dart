import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Temporarily disabled

// Provider for AuthController
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController();
});

class AuthController {
  // final FirebaseAuth _auth; // Temporarily disabled

  AuthController();

  // Send OTP to Phone
  Future<void> sendOtp({
    required String contact,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      // FOR NOW: We will simulate a successful send to avoid crashes without Firebase
      await Future.delayed(const Duration(seconds: 2));
      onCodeSent("phone_verify_session_123"); 
      
      /* Real Firebase Logic:
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
      */
    } catch (e) {
      onError(e.toString());
    }
  }

  // Send OTP to Email
  Future<void> sendEmailOtp({
    required String email,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      // Simulate successful send
      await Future.delayed(const Duration(seconds: 2));
      onCodeSent("email_verify_session_123"); 
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify the OTP
  Future<void> verifyOtp({
    required String verificationId,
    required String smsCode,
    required Function() onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      // FOR NOW: Use dummy code "123456" for both
      if (smsCode == "123456") {
        onSuccess();
      } else {
        onError("Invalid code (Try 123456)");
      }
      
      /* Real Firebase Logic:
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      onSuccess();
      */
    } catch (e) {
      onError(e.toString());
    }
  }
}

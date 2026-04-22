import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for AuthController
final authControllerProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<bool> {
  // state = false means logged out, state = true means logged in
  AuthController() : super(false);

  // Send OTP to Phone
  Future<void> sendOtp({
    required String contact,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      onCodeSent("phone_verify_session_123"); 
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
      if (smsCode == "123456") {
        state = true; // LOGGED IN SUCCESS
        onSuccess();
      } else {
        onError("Invalid code (Try 123456)");
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  void logout() {
    state = false; // LOGGED OUT
  }
}

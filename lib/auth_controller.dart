import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserModel {
  final String uid;
  final String contact;
  final String name;

  UserModel({required this.uid, required this.contact, this.name = "Verified User"});
}

final authControllerProvider = StateNotifierProvider<AuthController, UserModel?>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<UserModel?> {
  AuthController() : super(null);

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
    required String contact, // Added to create the user model
    required Function() onSuccess,
    required Function(String error) onError,
  }) async {
    try {
      if (smsCode == "123456") {
        state = UserModel(uid: "user_abc_123", contact: contact);
        onSuccess();
      } else {
        onError("Invalid code (Try 123456)");
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  void logout() {
    state = null;
  }
}

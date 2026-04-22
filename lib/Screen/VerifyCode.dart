import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth_controller.dart';
import 'ResetPasswordPage.dart';
import 'DashboardPage.dart';

class VerifyCode extends ConsumerStatefulWidget {
  final String verificationId;
  final bool isForgotPassword;

  const VerifyCode({
    super.key,
    required this.verificationId,
    this.isForgotPassword = false,
  });

  @override
  ConsumerState<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends ConsumerState<VerifyCode> {
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.yellow, Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.security, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    "Verification",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter the 6-digit code sent to you",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          TextField(
                            controller: codeController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 8,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "000000",
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (codeController.text.length < 6) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Please enter the 6-digit code")),
                                        );
                                        return;
                                      }
                                      setState(() => isLoading = true);

                                      await ref.read(authControllerProvider.notifier).verifyOtp(
                                        verificationId: widget.verificationId,
                                        smsCode: codeController.text,
                                        onSuccess: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(widget.isForgotPassword 
                                                ? "Identity Verified! Please set a new password." 
                                                : "Verification Successful!"),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          setState(() => isLoading = false);
                                          
                                          if (widget.isForgotPassword) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
                                            );
                                          } else {
                                            // Navigate to Dashboard and clear history
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => const DashboardPage()),
                                              (route) => false,
                                            );
                                          }
                                        },
                                        onError: (error) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(error),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          setState(() => isLoading = false);
                                        },
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      "VERIFY",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      // Handle resend logic
                    },
                    child: const Text(
                      "Didn't receive code? Resend",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

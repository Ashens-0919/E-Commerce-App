import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth_controller.dart';
import 'EnterContactpage.dart';
import 'VerifyCode.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController contactController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    contactController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    // PH format: +639xxxxxxxxx or 09xxxxxxxxx
    return RegExp(r'^(\+63|0)9\d{9}$').hasMatch(phone);
  }

  void _handleLogin() async {
    String contact = contactController.text.trim();
    String password = passwordController.text.trim();

    if (contact.isEmpty || password.isEmpty) {
      _showError("Please fill in all fields");
      return;
    }

    // Combined Validation for Email and Phone
    bool isEmailValid = _isValidEmail(contact);
    bool isPhoneValid = _isValidPhone(contact);

    if (!isEmailValid && !isPhoneValid) {
      _showError("Please enter a valid email or phone number (+63...)");
      return;
    }

    setState(() => isLoading = true);
    
    final auth = ref.read(authControllerProvider.notifier);
    
    // Determine if it's email or phone to call the correct mock method
    if (_isValidEmail(contact)) {
      await auth.sendEmailOtp(
        email: contact,
        onCodeSent: (verId) => _navigateToVerify(verId, contact),
        onError: (err) => _handleAuthError(err),
      );
    } else {
      await auth.sendOtp(
        contact: contact,
        onCodeSent: (verId) => _navigateToVerify(verId, contact),
        onError: (err) => _handleAuthError(err),
      );
    }
  }

  void _navigateToVerify(String verificationId, String contact, {bool isForgot = false}) {
    if (mounted) {
      setState(() => isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyCode(
            verificationId: verificationId,
            contact: contact,
            isForgotPassword: isForgot,
          ),
        ),
      );
    }
  }

  void _handleAuthError(String error) {
    if (mounted) {
      setState(() => isLoading = false);
      _showError(error);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Colors.blueAccent, Colors.yellowAccent, Colors.blueAccent],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              // Adaptive Header Space
              SizedBox(height: size.height * 0.12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Log in",
                        style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text("Welcome Back!",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.05),

              // Form Area - Rounded Container
              Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: size.height * 0.75),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: contactController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: "Email or Phone (+63...)",
                                prefixIcon: Icon(Icons.person_outline, color: Colors.blueAccent),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(15),
                              ),
                            ),
                            const Divider(height: 1),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _handleLogin(),
                              decoration: const InputDecoration(
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock_outline, color: Colors.blueAccent),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () async {
                            String contact = contactController.text.trim();
                            if (contact.isEmpty) {
                              _showError("Enter your Email/Phone to reset password");
                              return;
                            }
                            
                            setState(() => isLoading = true);
                            final auth = ref.read(authControllerProvider.notifier);
                            
                            if (_isValidEmail(contact)) {
                              await auth.sendEmailOtp(
                                email: contact,
                                onCodeSent: (verId) => _navigateToVerify(verId, contact, isForgot: true),
                                onError: (err) => _handleAuthError(err),
                              );
                            } else if (_isValidPhone(contact)) {
                              await auth.sendOtp(
                                contact: contact,
                                onCodeSent: (verId) => _navigateToVerify(verId, contact, isForgot: true),
                                onError: (err) => _handleAuthError(err),
                              );
                            } else {
                              _handleAuthError("Please enter a valid email or phone");
                            }
                          },
                          child: const Text("Forgot Password?",
                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text("Or login with", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton("assets/logo.PNG", Icons.g_mobiledata),
                          const SizedBox(width: 30),
                          _socialButton("assets/facebook.png", Icons.facebook),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const EnterContactPage()));
                            },
                            child: const Text("Sign Up",
                                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String asset, IconData fallback) {
    return Container(
      height: 55, width: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset(asset, errorBuilder: (c, e, s) => Icon(fallback, size: 30, color: Colors.blue)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce_app/Controller/AuthController.dart';
import 'VerifyCode.dart';
import 'LoginPage.dart';

class EnterContactPage extends ConsumerStatefulWidget {
  const EnterContactPage({super.key});

  @override
  ConsumerState<EnterContactPage> createState() => _EnterContactPageState();
}

class _EnterContactPageState extends ConsumerState<EnterContactPage> {
  final TextEditingController contactController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  bool isLoading = false;
  bool isPhoneSelected = true;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    contactController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    // Philippines format: +639xxxxxxxxx or 09xxxxxxxxx
    return RegExp(r'^(\+63|0)9\d{9}$').hasMatch(phone);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500), // Better for tablets
                child: Column(
                  children: [
                    Icon(Icons.person_add_rounded, size: screenHeight * 0.08, color: Colors.white),
                    const SizedBox(height: 15),
                    const Text(
                      "Create Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Sign up to get started!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 30),

                    // Selection Tabs
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          _buildTabButton("Phone", isPhoneSelected, () {
                            setState(() {
                              isPhoneSelected = true;
                              contactController.clear();
                            });
                          }),
                          _buildTabButton("Email", !isPhoneSelected, () {
                            setState(() {
                              isPhoneSelected = false;
                              contactController.clear();
                            });
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    Card(
                      elevation: 12,
                      shadowColor: Colors.black45,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isPhoneSelected ? "Phone Number" : "Email Address",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: contactController,
                              keyboardType: isPhoneSelected ? TextInputType.phone : TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: isPhoneSelected ? "+639123456789" : "name@email.com",
                                prefixIcon: Icon(isPhoneSelected ? Icons.phone_android : Icons.email_outlined),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                              ),
                            ),
                            
                            const SizedBox(height: 15),
                            const Text("Password", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                            const SizedBox(height: 10),
                            TextField(
                              controller: passwordController,
                              obscureText: obscurePassword,
                              decoration: InputDecoration(
                                hintText: "At least 6 characters",
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => obscurePassword = !obscurePassword),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                              ),
                            ),
                            
                            const SizedBox(height: 15),
                            const Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                            const SizedBox(height: 10),
                            TextField(
                              controller: confirmPasswordController,
                              obscureText: obscureConfirmPassword,
                              decoration: InputDecoration(
                                hintText: "Re-enter password",
                                prefixIcon: const Icon(Icons.lock_reset),
                                suffixIcon: IconButton(
                                  icon: Icon(obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                              ),
                            ),

                            const SizedBox(height: 30),
                            
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _handleSignUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text("SIGN UP", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ", style: TextStyle(color: Colors.white)),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                              (route) => false,
                            );
                          },
                          child: const Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blueAccent : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignUp() async {
    String contact = contactController.text.trim();
    String password = passwordController.text.trim();
    String confirm = confirmPasswordController.text.trim();

    if (contact.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showError("Please fill in all fields");
      return;
    }

    if (isPhoneSelected) {
      if (!_isValidPhone(contact)) {
        _showError("Please enter a valid PH phone number (e.g., +639...)");
        return;
      }
    } else {
      if (!_isValidEmail(contact)) {
        _showError("Please enter a valid email (must contain @ and domain)");
        return;
      }
    }
    
    if (password.length < 6) {
      _showError("Password must be at least 6 characters");
      return;
    }

    if (password != confirm) {
      _showError("Passwords do not match");
      return;
    }

    setState(() => isLoading = true);
    
    final auth = ref.read(authControllerProvider.notifier);
    
    if (isPhoneSelected) {
      await auth.sendOtp(
        contact: contact,
        onCodeSent: (verificationId) {
          if (mounted) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCode(
              verificationId: verificationId,
              contact: contact,
            )));
            setState(() => isLoading = false);
          }
        },
        onError: (error) {
          if (mounted) {
            _showError(error);
            setState(() => isLoading = false);
          }
        },
      );
    } else {
      _showError("Email signup is currently disabled. Please use Phone.");
      setState(() => isLoading = false);
    }
  }
}

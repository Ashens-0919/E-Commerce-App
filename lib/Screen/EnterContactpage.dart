import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth_controller.dart';
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
  bool isPhoneSelected = true; // Track which method is selected
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    contactController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_add_rounded, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    "Create Account",
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
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 30),

                  // Selection Buttons
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() {
                              isPhoneSelected = true;
                              contactController.clear();
                              passwordController.clear();
                              confirmPasswordController.clear();
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isPhoneSelected ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "Phone",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isPhoneSelected ? Colors.blueAccent : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() {
                              isPhoneSelected = false;
                              contactController.clear();
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !isPhoneSelected ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: !isPhoneSelected ? Colors.blueAccent : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isPhoneSelected ? "Phone Number" : "Email Address",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: contactController,
                            keyboardType: isPhoneSelected ? TextInputType.phone : TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: isPhoneSelected ? "+1234567890" : "example@mail.com",
                              prefixIcon: Icon(isPhoneSelected ? Icons.phone_android : Icons.email_outlined),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          
                          // Password Fields
                          const SizedBox(height: 20),
                          const Text(
                            "Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                              hintText: "Enter Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => obscurePassword = !obscurePassword),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          const Text(
                            "Confirm Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: obscureConfirmPassword,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              prefixIcon: const Icon(Icons.lock_reset),
                              suffixIcon: IconButton(
                                icon: Icon(obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (contactController.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Please enter contact info")),
                                        );
                                        return;
                                      }
                                      
                                      // Validate passwords
                                      if (passwordController.text.length < 6) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Password must be at least 6 characters")),
                                        );
                                        return;
                                      }

                                      if (passwordController.text != confirmPasswordController.text) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Passwords do not match")),
                                        );
                                        return;
                                      }

                                      setState(() => isLoading = true);
                                      
                                      final auth = ref.read(authControllerProvider);
                                      
                                      if (isPhoneSelected) {
                                        await auth.sendOtp(
                                          contact: contactController.text,
                                          onCodeSent: (verificationId) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => VerifyCode(verificationId: verificationId),
                                              ),
                                            );
                                            setState(() => isLoading = false);
                                          },
                                          onError: (error) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(error)),
                                            );
                                            setState(() => isLoading = false);
                                          },
                                        );
                                      } else {
                                        // Email OTP Logic (Custom implementation)
                                        await auth.sendEmailOtp(
                                          email: contactController.text,
                                          onCodeSent: (verificationId) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => VerifyCode(verificationId: verificationId),
                                              ),
                                            );
                                            setState(() => isLoading = false);
                                          },
                                          onError: (error) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(error)),
                                            );
                                            setState(() => isLoading = false);
                                          },
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      "SIGN UP",
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
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
=======
import 'VerifyCode.dart';

class EnterContactPage extends StatelessWidget {
  const EnterContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.yellow,
              Colors.green,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
            "Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
            const SizedBox(height: 40),

            const Text(
              "Enter your email or phone",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              decoration: InputDecoration(
                hintText: "Email or Phone",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VerifyCode(),
                  ),
                );
              },
              child: const Text("Send Code"),
            ),

          ],
>>>>>>> 61434a2692d502bb423a0275732ad9686c542c8d
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 61434a2692d502bb423a0275732ad9686c542c8d

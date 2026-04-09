import 'package:flutter/material.dart';
import 'EnterContactpage.dart';
import 'VerifyCode.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController contactController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    contactController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (contactController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    // Simulate login delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => isLoading = false);
      // After login, we slide to the verification page for extra security
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VerifyCode(verificationId: "login_session_123"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blueAccent,
              Colors.yellowAccent,
              Colors.blueAccent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),

            /// TITLE
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Log in",
                      style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(height: 10),
                  Text("Welcome Back!",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// WHITE FORM AREA
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 60),

                        /// FORM BOX
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: contactController,
                                decoration: const InputDecoration(
                                  hintText: "Email or Phone Number",
                                  border: InputBorder.none,
                                ),
                              ),
                              const Divider(),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: "Password",
                                  border: InputBorder.none,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        const Text("Forgot Password?",
                            style: TextStyle(color: Colors.grey)),

                        const SizedBox(height: 40),

                        /// LOGIN BUTTON
                        GestureDetector(
                          onTap: isLoading ? null : _handleLogin,
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blueAccent,
                            ),
                            child: Center(
                              child: isLoading 
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// SOCIAL LOGIN TEXT
                        const Text(
                          "Or login with",
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 20),

                        /// GOOGLE + FACEBOOK ICONS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset("assets/logo.PNG ", errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 30)),
                              ),
                            ),
                            const SizedBox(width: 30),
                            Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset("assets/facebook.png", errorBuilder: (context, error, stackTrace) => const Icon(Icons.facebook, size: 30)),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        /// SIGN UP LINK
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EnterContactPage()),
                                );
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

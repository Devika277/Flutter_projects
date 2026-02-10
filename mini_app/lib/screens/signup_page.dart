import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../screens/home.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  final usernameController =TextEditingController();

  String errorMessage = "";

  void signup() async {
    setState(() => errorMessage = "");

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // 🔴 VALIDATION
    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "Email and password required");
      return;
    }

    if (!email.contains("@")) {
      setState(() => errorMessage = "Enter a valid email");
      return;
    }

    if (password.length < 6) {
      setState(() => errorMessage = "Password must be 6 characters");
      return;
    }

    try {
      await authService.signup(email, password);
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      }
    } catch (e) {
      setState(() => errorMessage = e.toString());
    }
  }

  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey.shade100,
    body: SingleChildScrollView(
      child: Column(
        children: [
          // 🔷 HEADER
          Container(
            height: 260,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF008B8B),
                  Color(0xFF20B2AA),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Center(
              child: Text(
                "AJNAM",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

             // 🔷 WELCOME TEXT
        const Column(
          children: [
            Text(
              "Get Started Free",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Free membership Forever",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),


          // 🔷 FORM
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // USERNAME
                TextField(
                  controller: usernameController,
                  decoration: _inputDecoration("Username"),
                ),

                const SizedBox(height: 15),

                // EMAIL
                TextField(
                  controller: emailController,
                  decoration: _inputDecoration("Email"),
                ),

                const SizedBox(height: 15),

                // PASSWORD
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: _inputDecoration("Password"),
                ),

                const SizedBox(height: 10),

                // 🔴 ERROR MESSAGE
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                const SizedBox(height: 25),

                // 🔷 SIGNUP BUTTON
                GestureDetector(
                  onTap: signup,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF008B8B),
                          Color(0xFF20B2AA),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // BACK TO LOGIN
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}

}

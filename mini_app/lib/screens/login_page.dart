import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../screens/home.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  String errorMessage = "";

  void login() async {
    setState(() => errorMessage = "");

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // 🔴 VALIDATION
    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "Email and password required");
      return;
    }

    try {
      await authService.login(email, password);
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  HomePage()),
        );
      }
    } catch (e) {
      setState(() => errorMessage = "invalid username or password");
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
                  Color(0xFF008B8B), // dark cyan
                  Color(0xFF20B2AA), // light cyan
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
              "Welcome Back",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Enter your details here",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

          // 🔷 LOGIN FORM CARD
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // EMAIL
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // PASSWORD
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
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

                // 🔷 LOGIN BUTTON
                GestureDetector(
                  onTap: login,
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
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text("Or sign in with"),

                const SizedBox(height: 15),

                // 🔷 SOCIAL BUTTONS (UI only)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton("Google", Icons.g_mobiledata),
                    const SizedBox(width: 15),
                    _socialButton("Facebook", Icons.facebook),
                  ],
                ),

                const SizedBox(height: 25),

                // SIGNUP NAVIGATION
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignupPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Create new account",
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
Widget _socialButton(String text, IconData icon) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(text),
      ],
    ),
  );
}


}

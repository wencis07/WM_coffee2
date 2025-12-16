import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/components/atoms/app_button.dart';
import 'package:flutter_application_1/components/atoms/app_logo.dart';
import 'package:flutter_application_1/components/atoms/app_text_field.dart';
import 'package:flutter_application_1/components/molecules/password_field.dart';
import 'package:flutter_application_1/pages/homescreen.dart';
import 'create_acc.dart';

/// ===============================
/// LOGIN PAGE
/// ===============================
class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool showPassword = false;
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// -------------------------------
  /// LOGIN FUNCTION
  /// -------------------------------
  Future<void> loginUser() async {
    // Input validation
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      /// Navigate to HomeScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      /// Firebase error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              SizedBox(
                height: 80,
                width: 80,
                child: AppLogo(),
              ),

              const SizedBox(height: 20),

              /// -------------------------------
              /// Page Title
              /// -------------------------------
              const Text(
                'Log In',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 60, 46, 4),
                ),
              ),

              const SizedBox(height: 5),

              /// -------------------------------
              /// Subtitle
              /// -------------------------------
              const Text(
                'Log in to your account',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Color.fromARGB(255, 60, 46, 4),
                ),
              ),

              const SizedBox(height: 35),

              /// -------------------------------
              /// EMAIL FIELD
              /// -------------------------------
              AppTextField(
                label: 'EMAIL',
                controller: emailController,
              ),

              const SizedBox(height: 20),

              /// -------------------------------
              /// PASSWORD FIELD
              /// -------------------------------
              PasswordField(
                label: 'PASSWORD',
                controller: passwordController,
                isVisible: showPassword,
                onToggle: () {
                  setState(() => showPassword = !showPassword);
                },
              ),

              const SizedBox(height: 30),

              /// -------------------------------
              /// LOGIN BUTTON
              /// -------------------------------
              AppButton(
                text: 'Log in',
                onPressed: loginUser,
                isLoading: isLoading,
              ),

              const SizedBox(height: 20),

              /// -------------------------------
              /// REGISTER LINK
              /// -------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAcc(),
                        ),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

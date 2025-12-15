import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/components/atoms/app_button.dart';
import 'package:flutter_application_1/components/atoms/app_text_field.dart';
import 'package:flutter_application_1/components/molecules/password_field.dart';
import 'createacc.dart';
import 'homepage.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool showPassword = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // LOGIN FUNCTION
  Future<void> loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    }
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

              const Text(
                "Log In",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 60, 46, 4),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Log in to your account",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Color.fromARGB(255, 60, 46, 4),
                ),
              ),

              const SizedBox(height: 35),

              // EMAIL FIELD 
              AppTextField(
                label: "EMAIL",
                controller: emailController,
              ),

              const SizedBox(height: 20),

              // PASSWORD FIELD 
              PasswordField(
                label: "PASSWORD",
                controller: passwordController,
                isVisible: showPassword,
                onToggle: () {
                  setState(() => showPassword = !showPassword);
                },
              ),

              const SizedBox(height: 30),

              // LOGIN BUTTON 
              AppButton(
                text: "Log in",
                onPressed: loginUser,
              ),

              const SizedBox(height: 20),

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
                      "Register",
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

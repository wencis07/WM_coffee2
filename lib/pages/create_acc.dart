import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/components/atoms/app_button.dart';
import 'package:flutter_application_1/components/atoms/app_logo.dart';
import 'package:flutter_application_1/components/atoms/app_text_field.dart';
import 'package:flutter_application_1/components/molecules/password_field.dart';
import 'login.dart';

/// ===============================
/// CREATE ACCOUNT PAGE
/// ===============================
class CreateAcc extends StatefulWidget {
  const CreateAcc({super.key});

  @override
  State<CreateAcc> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAcc> {
  /// -------------------------------
  /// Password visibility toggles
  /// -------------------------------
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;

  /// -------------------------------
  /// Text Controllers
  /// -------------------------------
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [

            SizedBox(
                height: 80,
                width: 80,
                child: AppLogo(),
              ),
              
              const SizedBox(height: 20),
              /// -------------------------------
              /// Page Title
              /// -------------------------------
              const Text("Create Account",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),

              const SizedBox(height: 5),

              /// -------------------------------
              /// Subtitle
              /// -------------------------------
              const Text(
                "Create a new account to get started",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Color.fromARGB(255, 60, 46, 4),
                ),
              ),

              const SizedBox(height: 30),

              /// -------------------------------
              /// Username Field
              /// -------------------------------
              AppTextField(
                label: "USERNAME",
                controller: nameController,
              ),

              const SizedBox(height: 20),

              /// -------------------------------
              /// Email Field
              /// -------------------------------
              AppTextField(
                label: "EMAIL",
                controller: emailController,
              ),

              const SizedBox(height: 20),

              /// -------------------------------
              /// Password Field
              /// -------------------------------
              PasswordField(
                label: "PASSWORD",
                controller: passwordController,
                isVisible: showPassword,
                onToggle: () =>
                    setState(() => showPassword = !showPassword),
              ),

              const SizedBox(height: 20),

              /// -------------------------------
              /// Confirm Password Field
              /// -------------------------------
              PasswordField(
                label: "CONFIRM PASSWORD",
                controller: confirmPasswordController,
                isVisible: showConfirmPassword,
                onToggle: () => setState(
                    () => showConfirmPassword = !showConfirmPassword),
              ),

              const SizedBox(height: 30),

              /// -------------------------------
              /// Register Button
              /// -------------------------------
              AppButton(
                text: "Register",
                isLoading: isLoading,
                onPressed: registerUser,
              ),

              const SizedBox(height: 20),

              /// -------------------------------
              /// Login Link
              /// -------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogIn(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// -------------------------------
  /// REGISTER USER FUNCTION
  /// -------------------------------
  Future<void> registerUser() async {
    // Password match validation
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      /// Create user with FirebaseAuth
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      /// Add user info to Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "username": nameController.text.trim(),
        "email": emailController.text.trim(),
        "createdAt": DateTime.now(),
      });

      if (!mounted) return;

      /// Navigate to Login page after registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LogIn()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Registration failed")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
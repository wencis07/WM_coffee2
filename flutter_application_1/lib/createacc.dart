import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

import 'components/atoms/app_button.dart';
import 'components/atoms/app_text_field.dart';
import 'components/molecules/password_field.dart';

class CreateAcc extends StatefulWidget {
  const CreateAcc({super.key});

  @override
  State<CreateAcc> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAcc> {
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;

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
              const Text("Create Account",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

              const SizedBox(height: 30),

              AppTextField(
                label: "FULL NAME",
                controller: nameController,
              ),

              const SizedBox(height: 20),

              AppTextField(
                label: "EMAIL",
                controller: emailController,
              ),

              const SizedBox(height: 20),

              PasswordField(
                label: "PASSWORD",
                controller: passwordController,
                isVisible: showPassword,
                onToggle: () =>
                    setState(() => showPassword = !showPassword),
              ),

              const SizedBox(height: 20),

              PasswordField(
                label: "CONFIRM PASSWORD",
                controller: confirmPasswordController,
                isVisible: showConfirmPassword,
                onToggle: () =>
                    setState(() => showConfirmPassword = !showConfirmPassword),
              ),

              const SizedBox(height: 30),

              AppButton(
                text: "Register",
                isLoading: isLoading,
                onPressed: registerUser,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "createdAt": DateTime.now(),
      });

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => const LogIn()),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/components/atoms/app_button.dart';
import 'package:flutter_application_1/components/atoms/app_text_field.dart';
import 'package:flutter_application_1/components/molecules/password_field.dart';
import 'login.dart';

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
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28, 
                    fontWeight: FontWeight.bold)),

              const SizedBox(height: 5),

              const Text(
                "Create a new account to get started",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Color.fromARGB(255, 60, 46, 4),
                ),
              ),

              const SizedBox(height: 30),

              AppTextField(
                label: "USERNAME",
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

              const SizedBox(height: 20),

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

  

 Future<void> registerUser() async {
  if (passwordController.text != confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Passwords do not match")),
    );
    return;
  }

  setState(() => isLoading = true);

  try {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userCredential.user!.uid)
        .set({
      "username": nameController.text.trim(),
      "email": emailController.text.trim(),
      "createdAt": DateTime.now(),
    });

    if (!mounted) return;
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
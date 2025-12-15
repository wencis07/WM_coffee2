import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/createacc.dart';
import 'package:flutter_application_1/pages/login.dart';

class AuthActions extends StatelessWidget {
  const AuthActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 150,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 60, 46, 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LogIn()),
              );
            },
            child: const Text(
              "Log In",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),

        const SizedBox(height: 15),

        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 60, child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("or"),
            ),
            SizedBox(width: 60, child: Divider()),
          ],
        ),

        const SizedBox(height: 15),

        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateAcc()),
            );
          },
          child: const Text(
            "Register",
            style: TextStyle(
              color: Color.fromARGB(255, 60, 46, 4),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

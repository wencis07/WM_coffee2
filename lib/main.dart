import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'components/atoms/app_logo.dart';
import 'components/atoms/tagline.dart';
import 'components/molecules/auth_actions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}


class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Spacer(),
            AppLogo(),
            SizedBox(height: 40),
            AppTagline(),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 110),
              child: AuthActions(),
            ),
          ],
        ),
      ),
    );
  }
}

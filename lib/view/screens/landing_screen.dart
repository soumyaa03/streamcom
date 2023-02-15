import 'package:flutter/material.dart';
import 'package:streamcom/responsive/responsive.dart';
import 'package:streamcom/view/screens/login_screen.dart';
import 'package:streamcom/view/screens/signup_screen.dart';
import 'package:streamcom/view/widgets/custom_button.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = '/landing';
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to \n Streamcom',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomButton(
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                  text: 'Log in',
                ),
              ),
              CustomButton(
                  onTap: () {
                    Navigator.pushNamed(context, SignupScreen.routeName);
                  },
                  text: 'Sign Up'),
            ],
          ),
        ),
      ),
    );
  }
}

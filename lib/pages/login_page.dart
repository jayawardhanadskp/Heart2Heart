import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:paint/firebase_options.dart';
import 'package:paint/pages/home_page.dart';
import 'package:paint/pages/login_page.dart';
import 'package:paint/providers/auth_provider.dart';
import 'package:paint/providers/drawing_provider.dart';
import 'package:paint/utils/colors.dart';
import 'package:paint/widgets/login_button.dart';
import 'package:provider/provider.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes using Consumer
    return Consumer<GFAuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.user != null) {
          // If the user is logged in, navigate to home page
          Future.delayed(Duration.zero, () async {
            final exists = await authProvider.checkIfUserExists();
            if (!exists) {
              // If the anonymous user is deleted, redirect to login page
              await authProvider.signOut();
              Navigator.pushReplacementNamed(context, '/');
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          });
        }
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.pink, Colors.white, AppColors.blue],
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 60, width: double.infinity),
                  Text('APP NAME'),
                  const SizedBox(height: 550),
                  // Login Button
                  LoginButton(
                    text: 'Login with Google',
                    onPressed: () async {
                      await authProvider.signInWIthGoogle();
                    },
                    icon: 'assets/svg/google.svg',
                  ),
                  const SizedBox(height: 20),
                  // Facebook Login Button (optional)
                  LoginButton(
                    text: 'Login with Facebook',
                    onPressed: () async {
                      await authProvider.signInAnon(context);
                    },
                    icon: 'assets/svg/facebook.svg',
                    isBlack: true,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

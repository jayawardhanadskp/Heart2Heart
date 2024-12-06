import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paint/utils/colors.dart';
import 'package:paint/widgets/login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.pink, Colors.white, AppColors.blue])),
          ),
          Column(
            children: [
              const SizedBox(
                height: 60,
                width: double.infinity,
              ),
              Text('APP NAME'),
              const SizedBox(
                height: 550,
              ),
              LoginButton(text: 'Login with Google', onPressed: () {}, icon: 'assets/svg/google.svg',),
              const SizedBox(height: 20,),
              LoginButton(text: 'Login with Facebook', onPressed: () {}, icon: 'assets/svg/facebook.svg', isBlack: true,)
            ],
          )
        ],
      )
    );
  }
}

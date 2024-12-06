import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paint/utils/app_fonts.dart';
import 'package:paint/utils/colors.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String icon;
  final bool isBlack;
  const LoginButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.isBlack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(80, 60),
            backgroundColor: isBlack ? AppColors.black : AppColors.pink1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              icon,
              height: 30,
              width: 30,
            ),
            Text(
              text,
              style: AppFonts.normal.copyWith(
                  fontSize: 16,
                  color: isBlack ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.w600
                  ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}

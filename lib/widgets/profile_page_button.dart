import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class ProfilePageButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onTap;
  const ProfilePageButton({super.key, required this.buttonText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonText == "Follow" ? blueColor : mobileSearchColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ModalSheetTile extends StatelessWidget {
  final String discription;
  final IconData icon;
  final void Function()? onTap;
  const ModalSheetTile(
      {super.key, required this.discription, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leadingAndTrailingTextStyle: const TextStyle(
        fontSize: 18,
      ),
      leading: Text(discription),
      trailing: Icon(icon),
    );
  }
}

import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final String value;
  final String description;
  final void Function()? onTap;
  const ProfileStats(
      {super.key, required this.description, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            description,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

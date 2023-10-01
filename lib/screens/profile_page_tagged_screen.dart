import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class ProfilePageTaggedScreen extends StatelessWidget {
  const ProfilePageTaggedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: mobileBackgroundColor,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: primaryColor,
                    width: 3,
                  )),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 60,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "No Posts Yet",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

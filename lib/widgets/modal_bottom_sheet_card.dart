import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/widgets/model_sheet_tile.dart';

class ModalCard extends StatelessWidget {
  final String username;
  final String followedPersonUid;
  final String followingPersonUid;
  final List followers;
  final List following;
  const ModalCard(
      {super.key,
      required this.username,
      required this.followedPersonUid,
      required this.followingPersonUid,
      required this.followers,
      required this.following});

  Future<void> removeFollower() async {
    await FirestoreMethods()
        .removeFollower(followedPersonUid, followingPersonUid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        //name
        Text(
          username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(),

        const ModalSheetTile(
            discription: "Add to Close Friends list",
            icon: Icons.stars_rounded),
        const ModalSheetTile(
            discription: "Add to favorites", icon: Icons.star_outline),
        const ModalSheetTile(
            discription: "Mute", icon: Icons.arrow_forward_ios),
        const ModalSheetTile(
            discription: "Restrict", icon: Icons.arrow_forward_ios),
        ModalSheetTile(
            onTap: () {
              Navigator.of(context).pop();
              removeFollower();
            },
            discription: "Unfollow",
            icon: Icons.person_remove),
      ],
    );
  }
}

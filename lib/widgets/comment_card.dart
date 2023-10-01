import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatelessWidget {
  final dynamic snap;
  const CommentCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // profile pic
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(snap['userProfilePhotoUrl']),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: snap['username'],
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                        const TextSpan(text: "   "),
                        TextSpan(
                            text: DateFormat.yMEd()
                                .format(snap['dateOfComment'].toDate()),
                            style: const TextStyle(
                              color: secondaryColor,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    snap['comment'],
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
            ),
            child: Column(
              children: [
                InkWell(
                    onTap: () async {
                      await FirestoreMethods().updateCommentLikes(
                          snap['postId'],
                          snap['commentId'],
                          user.uid,
                          snap['likes']);
                    },
                    child: snap['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.favorite_rounded,
                            color: Colors.red,
                          )
                        : const Icon(Icons.favorite_outline_outlined)),
                const SizedBox(
                  height: 2,
                ),
                snap['likes'].isNotEmpty
                    ? Text(
                        snap['likes'].length.toString(),
                        style: const TextStyle(color: secondaryColor),
                      )
                    : const Text(
                        "",
                        style: TextStyle(color: secondaryColor),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

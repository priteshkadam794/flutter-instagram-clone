import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatefulWidget {
  final dynamic snap;

  const CommentWidget({super.key, required this.snap});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        // profile pic
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(top: 0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                user.photoUrl,
              ),
            ),
          ),
          //comment field
          Expanded(
              child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(4),
              // filled: true,
              border: InputBorder.none,
              hintText: "Add a comment...",
              hintStyle: TextStyle(
                color: Colors.grey.shade800,
              ),
            ),
          )),
          TextButton(
              onPressed: () async {
                await FirestoreMethods().postComment(
                    widget.snap['postId'],
                    user.username,
                    user.photoUrl,
                    _commentController.text,
                    user.uid);
                _commentController.clear();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: const Text(
                "Post",
                style: TextStyle(
                  fontSize: 15,
                ),
              ))
        ],
      ),
    );
  }
}

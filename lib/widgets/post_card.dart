import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_like_button/insta_like_button.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/utils/utils.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final dynamic snap;
  final bool isFeedScreen;

  const PostCard({super.key, required this.snap, this.isFeedScreen = true});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  model.User? user;
  int _commentLen = 0;
  @override
  void initState() {
    super.initState();
    getCommentLen();
  }

  getUser() {
    user = Provider.of<UserProvider>(context).getUser;
    setState(() {});
  }

  void getCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        _commentLen = snap.docs.length;
      });
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    // model.User user = Provider.of<UserProvider>(context).getUser;
    bool getLikeStatus() {
      if (!widget.snap['likes'].contains(user!.uid)) {
        return true;
      }
      return false;
    }

    return user == null
        ? const Center(
            child: CircularProgressIndicator.adaptive(),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // header section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                  .copyWith(right: 0),
              child: Row(
                children: [
                  // profile img - circle avatar
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.snap['photoUrl']),
                  ),
                  //username
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        widget.snap['username'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                  ),
                  //more options
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert_rounded),
                  ),
                ],
              ),
            ),
            // post photo
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
              // child: Image.network(snap['postUrl']),
              child: InstaLikeButton(
                  imageBoxfit: BoxFit.cover,
                  image: NetworkImage(
                    widget.snap['postUrl'],
                  ),
                  onChanged: () async {
                    await FirestoreMethods().updateLikes(
                        user!.uid, widget.snap['postId'], widget.snap['likes']);
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await FirestoreMethods().updateLikes(user!.uid,
                            widget.snap['postId'], widget.snap['likes']);
                      },
                      icon: getLikeStatus() == true
                          ? const Icon(Icons.favorite_outline)
                          : const Icon(
                              Icons.favorite_rounded,
                              color: Colors.red,
                            ),
                    ),
                    IconButton(
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                    snap: widget.snap,
                                  ))),
                      icon: const Icon(Icons.message_outlined),
                    ),
                    IconButton(
                      onPressed: (() {}),
                      icon: const Icon(Icons.send_rounded),
                    )
                  ],
                ),
                IconButton(
                    onPressed: (() {}),
                    icon: const Icon(Icons.bookmark_border_outlined))
              ],
            ),
            //No of likes
            widget.isFeedScreen
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.snap['likes'].length} Likes"),
                      ),
                      // caption
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 8.0),
                            child: Text(widget.snap['username']),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(8.0).copyWith(top: 0),
                              child: Text(
                                widget.snap['caption'],
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),

                      // view all comments

                      // add a comment
                      Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                        child: Text(
                          "View all $_commentLen comments",
                          style: TextStyle(
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      // const CaptionWidget(),
                      // date of upload
                      Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                        child: Text(
                          DateFormat.yMMMd()
                              .format(widget.snap["datePublished"].toDate()),
                          style: TextStyle(
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  )
                : const Padding(
                    padding: EdgeInsets.all(0),
                  ),
          ]);
  }
}

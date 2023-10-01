import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_page_tagged_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/animated_dialogue.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class ProfilePagePostScreen extends StatefulWidget {
  final String uid;
  const ProfilePagePostScreen({super.key, required this.uid});

  @override
  State<ProfilePagePostScreen> createState() => _ProfilePagePostScreenState();
}

class _ProfilePagePostScreenState extends State<ProfilePagePostScreen> {
  OverlayEntry? _popUpDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('posts')
              .where('uid', isEqualTo: widget.uid)
              .get(),
          builder: ((context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return const ProfilePageTaggedScreen();
            }
            return SizedBox(
              child: GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      crossAxisCount: 3),
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                      onLongPress: () {
                        _popUpDialog =
                            _createPopUpDialog(snapshot.data!.docs[index]);
                        Overlay.of(context).insert(_popUpDialog!);
                      },
                      onLongPressEnd: (details) => _popUpDialog?.remove(),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => FeedPage(
                                  isFeedScreen: false,
                                  uid: widget.uid,
                                  index: index,
                                ))));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                snapshot.data!.docs[index]['postUrl']),
                          ),
                        ),
                      ),
                    );
                  })),
            );
          })),
    );
  }

  OverlayEntry _createPopUpDialog(snap) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(snap),
      ),
    );
  }

  Widget _createPopupContent(snap) => Center(
          child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: mobileSearchColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PostCard(
              snap: snap,
              isFeedScreen: false,
            ),
          ],
        ),
      ));
}

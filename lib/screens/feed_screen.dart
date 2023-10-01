import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/post_card.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FeedPage extends StatefulWidget {
  final bool isFeedScreen;
  final String? uid;
  final int index;
  const FeedPage(
      {super.key, this.isFeedScreen = true, this.uid, this.index = 0});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isFeedScreen
          ? AppBar(
              centerTitle: false,
              backgroundColor: mobileBackgroundColor,
              title: SvgPicture.asset(
                "assets/Instagram_logo.svg",
                height: 34,
                color: primaryColor,
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.messenger_outline_rounded))
              ],
            )
          : AppBar(
              title: const Text("Posts"),
              titleTextStyle:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              centerTitle: false,
              backgroundColor: mobileBackgroundColor,
            ),
      body: widget.isFeedScreen
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      return PostCard(
                        snap: snapshot.data!.docs[index],
                      );
                    }));
              },
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('uid', isEqualTo: widget.uid)
                  .snapshots(),
              builder: ((context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return ScrollablePositionedList.builder(
                  initialScrollIndex: widget.index,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    return PostCard(
                      snap: snapshot.data!.docs[index],
                    );
                  }),
                );
              }),
            ),
    );
  }
}

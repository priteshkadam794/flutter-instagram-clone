import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/search_screen_secondary.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/animated_dialogue.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class PrimarySearchScreen extends StatefulWidget {
  const PrimarySearchScreen({super.key});

  @override
  State<PrimarySearchScreen> createState() => _PrimarySearchScreenState();
}

class _PrimarySearchScreenState extends State<PrimarySearchScreen> {
  OverlayEntry? _popUpDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchScreenSecondary())),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 45,
                decoration: BoxDecoration(
                  color: mobileSearchColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(Icons.search),
                    ),
                    Text(
                      "Search",
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  // print(snapshot.data!.docs[0]['postUrl']);
                  return GridView.custom(
                    gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      repeatPattern: QuiltedGridRepeatPattern.inverted,
                      pattern: const [
                        QuiltedGridTile(2, 2),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 2),
                      ],
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                      (context, index) => GestureDetector(
                        onLongPress: () {
                          _popUpDialog =
                              _createPopUpDialog(snapshot.data!.docs[index]);
                          Overlay.of(context).insert(_popUpDialog!);
                        },
                        onLongPressEnd: (details) => _popUpDialog?.remove(),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                snapshot.data!.docs[index]['postUrl']),
                          )),
                        ),
                      ),
                      childCount: snapshot.data!.docs.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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

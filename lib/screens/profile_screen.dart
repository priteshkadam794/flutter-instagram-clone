import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/eidt_profile_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/profile_page_posts_screen.dart';
import 'package:instagram_clone/screens/profile_page_tagged_screen.dart';
import 'package:instagram_clone/screens/profile_stats_page.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/modal_bottom_sheet_card.dart';
import 'package:instagram_clone/widgets/profile_page_button.dart';
import 'package:instagram_clone/widgets/profile_stats.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final bool isUser;
  final String uid;
  const ProfileScreen({super.key, required this.uid, required this.isUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedPage = 0;
  int _noOfPosts = 0;
  final PageController _pageController = PageController();

  Future<void> _getPostCount(uid) async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.isUser ? uid : widget.uid)
          .get();
      setState(() {
        _noOfPosts = snap.docs.length;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  // Future<void> getData() async {
  //   try {
  //     DocumentSnapshot snap = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(widget.uid)
  //         .get();
  //     _snap = snap;
  //     setState(() {});
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //   }
  // }

  Future<void> logOutUser() async {
    String res = await AuthMethods().logOutUser();
    if (res == 'success') {
      if (!context.mounted) return;
      showSnackBar(context, "Successfully logged out.");
    }
  }

  @override
  void initState() {
    super.initState();
    _getPostCount(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    bool getfollowingStatus(List<dynamic> profileFollowersList) {
      if (profileFollowersList.contains(user.uid)) {
        return true;
      }
      return false;
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.isUser ? user.uid : widget.uid)
            .snapshots(),
        builder: ((context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return DefaultTabController(
            length: 2,
            initialIndex: _selectedPage,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                title: widget.isUser
                    ? Row(
                        children: [
                          const Icon(Icons.lock_outline),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            snapshot.data!['username'],
                          ),
                        ],
                      )
                    : Text(
                        snapshot.data!['username'],
                      ),
                centerTitle: false,
                actions: widget.isUser == true
                    ? [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: InkWell(
                              overlayColor: const MaterialStatePropertyAll(
                                  Colors.transparent),
                              splashColor: Colors.transparent,
                              onTap: () => showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      backgroundColor: mobileSearchColor,
                                      shape: ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: const Text("LogOut?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              logOutUser();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen()));
                                            },
                                            child: const Text(
                                              "Yes",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              "No",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                      ],
                                    );
                                  })),
                              child: const Icon(Icons.logout)),
                        ),
                      ]
                    : [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: InkWell(
                              overlayColor: const MaterialStatePropertyAll(
                                  Colors.transparent),
                              splashColor: Colors.transparent,
                              onTap: () {},
                              child: const Icon(Icons.notifications_outlined)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: InkWell(
                              overlayColor: const MaterialStatePropertyAll(
                                  Colors.transparent),
                              splashColor: Colors.transparent,
                              onTap: () {},
                              child: const Icon(Icons.more_vert)),
                        ),
                      ],
              ),
              body: Column(children: [
                // profile pic and followers posts info
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            NetworkImage(snapshot.data!['photoUrl']),
                      ),
                      ProfileStats(
                        description: "Posts",
                        value: _noOfPosts.toString(),
                      ),
                      ProfileStats(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileStatsPage(
                                      initialIndex: 0,
                                      followerCount: snapshot
                                          .data!['followers'].length
                                          .toString(),
                                      followingCount: snapshot
                                          .data!['following'].length
                                          .toString(),
                                      uid: snapshot.data!['uid'],
                                      username: snapshot.data!['username'],
                                    ))),
                        description: "Followers",
                        value: snapshot.data!['followers'].length.toString(),
                      ),
                      ProfileStats(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileStatsPage(
                                      initialIndex: 1,
                                      followerCount: snapshot
                                          .data!['followers'].length
                                          .toString(),
                                      followingCount: snapshot
                                          .data!['following'].length
                                          .toString(),
                                      uid: snapshot.data!['uid'],
                                      username: snapshot.data!['username'],
                                    ))),
                        description: "Following",
                        value: snapshot.data!['following'].length.toString(),
                      ),
                    ],
                  ),
                ),

                // username & bio
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.topLeft,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // username
                      Text(
                        snapshot.data!['username'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        snapshot.data!['bio'],
                        style: const TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      widget.isUser
                          ? Expanded(
                              child: ProfilePageButton(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => EditProfileScreen(
                                              snap: snapshot.data!,
                                            ))),
                                buttonText: "Edit Profile",
                              ),
                            )
                          : Expanded(
                              child: ProfilePageButton(
                                onTap: () async {
                                  if (getfollowingStatus(
                                      snapshot.data!['followers'])) {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: webBackgroundColor,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24),
                                          ),
                                        ),
                                        showDragHandle: true,
                                        context: context,
                                        builder: ((context) {
                                          return ModalCard(
                                            followedPersonUid:
                                                snapshot.data!['uid'],
                                            followingPersonUid: user.uid,
                                            followers:
                                                snapshot.data!['followers'],
                                            following: user.following,
                                            username:
                                                snapshot.data!['username'],
                                          );
                                        }));
                                  } else {
                                    await FirestoreMethods().addFollower(
                                      snapshot.data!['uid'],
                                      user.uid,
                                    );
                                  }
                                },
                                buttonText: getfollowingStatus(
                                        snapshot.data!['followers'])
                                    ? "Following"
                                    : "Follow",
                              ),
                            ),
                      const Expanded(
                        child: ProfilePageButton(
                          buttonText: "Share Profile",
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8)
                              .copyWith(left: 0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: mobileSearchColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.person_add_alt,
                            size: 22,
                          )),
                    ],
                  ),
                ),
                const Divider(),

                const TabBar(tabs: [
                  Tab(
                    icon: Icon(Icons.grid_on),
                  ),
                  Tab(
                    icon: Icon(Icons.assignment_ind_outlined),
                  ),
                ]),

                Expanded(
                  child: TabBarView(children: [
                    ProfilePagePostScreen(
                      uid: widget.isUser ? user.uid : widget.uid,
                    ),
                    const ProfilePageTaggedScreen(),
                  ]),
                ),

                // BottomNavigationBar(
                //     backgroundColor: mobileBackgroundColor,
                //     selectedFontSize: 0,
                //     unselectedFontSize: 0,
                //     iconSize: 30,
                //     elevation: 0,
                //     enableFeedback: false,
                //     currentIndex: _selectedPage,
                //     onTap: (value) {
                //       _selectedPage = value;
                //       _pageController.jumpToPage(value);
                //       setState(() {});
                //     },
                //     selectedItemColor: primaryColor,
                //     items: const [
                //       BottomNavigationBarItem(
                //         label: "",
                //         icon: Icon(Icons.grid_on),
                //       ),
                //       BottomNavigationBarItem(
                //         label: "",
                //         icon: Icon(Icons.assignment_ind_outlined),
                //       ),
                //     ]),

                // Expanded(
                //     child: Scrollbar(
                //   thickness: 2,
                //   scrollbarOrientation: ScrollbarOrientation.top,
                //   child: PageView(
                //     controller: _pageController,
                //     children: [
                //       ProfilePagePostScreen(
                //         uid: widget.uid,
                //       ),
                //       const ProfilePageTaggedScreen(),
                //     ],
                //     onPageChanged: (value) {
                //       setState(() {
                //         _selectedPage = value;
                //       });
                //     },
                //   ),
                // )),
              ]),
            ),
          );
        }));
  }
}

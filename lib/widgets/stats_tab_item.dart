import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

class TabStatsItem extends StatelessWidget {
  final String discription;
  final String uid;
  final bool isUser;
  const TabStatsItem(
      {super.key,
      required this.discription,
      required this.uid,
      this.isUser = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            discription,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        discription == "All followers"
            ? Expanded(
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .where('following', arrayContains: uid)
                        .get(),
                    builder: ((context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: FirebaseAuth.instance.currentUser!.uid == uid
                              ? const Text("You got no followers")
                              : const Text("No followers"),
                        );
                      }

                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0)
                                      .copyWith(top: 4),
                              child: ListTile(
                                splashColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: ((context) => ProfileScreen(
                                          isUser: FirebaseAuth.instance
                                                      .currentUser!.uid ==
                                                  (snapshot.data!.docs[index]
                                                      ['uid'] as String)
                                              ? true
                                              : false,
                                          uid: snapshot.data!.docs[index]
                                              ['uid'],
                                        )),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    snapshot.data!.docs[index]['photoUrl'],
                                  ),
                                ),
                                title: Text(
                                  snapshot.data!.docs[index]['username'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                                subtitle: Text(
                                    "${snapshot.data!.docs[index]['followers'].length.toString()} followers"),
                              ),
                            );
                          }));
                    })),
              )
            : Expanded(
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .where('followers', arrayContains: uid)
                        .get(),
                    builder: ((context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: FirebaseAuth.instance.currentUser!.uid == uid
                              ? const Text("You don't follow anyone")
                              : const Text("No following"),
                        );
                      }

                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0)
                                      .copyWith(top: 4),
                              child: ListTile(
                                splashColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: ((context) => ProfileScreen(
                                          isUser: FirebaseAuth.instance
                                                      .currentUser!.uid ==
                                                  (snapshot.data!.docs[index]
                                                      ['uid'] as String)
                                              ? true
                                              : false,
                                          uid: snapshot.data!.docs[index]
                                              ['uid'],
                                        )),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    snapshot.data!.docs[index]['photoUrl'],
                                  ),
                                ),
                                title: Text(
                                  snapshot.data!.docs[index]['username'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                                subtitle: Text(
                                    "${snapshot.data!.docs[index]['followers'].length.toString()} followers"),
                              ),
                            );
                          }));
                    })),
              )
      ],
    );
  }
}

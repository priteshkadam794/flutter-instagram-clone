import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

class SearchScreenSecondary extends StatefulWidget {
  const SearchScreenSecondary({super.key});

  @override
  State<SearchScreenSecondary> createState() => _SearchScreenSecondaryState();
}

class _SearchScreenSecondaryState extends State<SearchScreenSecondary> {
  final TextEditingController _searchController = TextEditingController();
  bool _showUsers = false;
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    const border = OutlineInputBorder(
        borderRadius: BorderRadius.all(
      Radius.circular(16),
    ));
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.bottom,
                    cursorColor: secondaryColor,
                    decoration: const InputDecoration(
                      fillColor: mobileSearchColor,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: secondaryColor,
                      ),
                      hintText: "Search people..",
                      border: border,
                      focusedBorder: border,
                      enabledBorder: border,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _showUsers = false;
                        } else {
                          _showUsers = true;
                        }
                      });
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        if (_searchController.text.isEmpty) {
                          _showUsers = false;
                        } else {
                          _showUsers = true;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          _showUsers
              ? Expanded(
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .where('username',
                            isGreaterThanOrEqualTo: _searchController.text)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No users found..'),
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
                                          isUser: user.uid ==
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
                                  radius: 24,
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
                    },
                  ),
                )
              : const Text(""),
        ],
      )),
    );
  }
}

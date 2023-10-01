import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen_primary.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedPage(),
  const PrimarySearchScreen(),
  const AddPostScreen(),
  const Center(
    child: Text("like"),
  ),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
    isUser: true,
  )
];

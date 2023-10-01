import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/stats_tab_item.dart';

class ProfileStatsPage extends StatelessWidget {
  final int initialIndex;
  final String followerCount;
  final String followingCount;
  final String uid;
  final String username;
  const ProfileStatsPage(
      {super.key,
      required this.initialIndex,
      required this.followerCount,
      required this.followingCount,
      required this.uid,
      required this.username});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            centerTitle: false,
            title: Text(username),
          ),
          body: Column(mainAxisSize: MainAxisSize.min, children: [
            TabBar(tabs: [
              Tab(
                text: "$followerCount Followers",
              ),
              Tab(
                text: "$followingCount Following",
              ),
            ]),
            Expanded(
              child: TabBarView(children: [
                TabStatsItem(
                  isUser: true,
                  discription: "All followers",
                  uid: uid,
                ),
                TabStatsItem(
                  isUser: true,
                  discription: "All following",
                  uid: uid,
                ),
              ]),
            )
          ])),
    );
  }
}

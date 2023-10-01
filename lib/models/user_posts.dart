import 'package:cloud_firestore/cloud_firestore.dart';

class UserPost {
  final String caption;
  final String postUrl;
  final String photoUrl;
  final String username;
  final String uid;
  final DateTime datePublished;
  final String postId;
  final List likes;

  const UserPost(
      {required this.caption,
      required this.postUrl,
      required this.photoUrl,
      required this.username,
      required this.uid,
      required this.datePublished,
      required this.postId,
      required this.likes});

  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'postUrl': postUrl,
      'photoUrl': photoUrl,
      'username': username,
      'uid': uid,
      'datePublished': datePublished,
      'postId': postId,
      'likes': likes,
    };
  }

  static postFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserPost(
      caption: snapshot['caption'],
      postUrl: snapshot['postUrl'],
      photoUrl: snapshot['photoUrl'],
      username: snapshot['username'],
      uid: snapshot['uid'],
      datePublished: snapshot['datePublished'],
      postId: snapshot['postId'],
      likes: snapshot['likes'],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/user_posts.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  // upload post
  Future<String> uploadPost(
    String caption,
    String photoUrl,
    String username,
    String uid,
    Uint8List file,
  ) async {
    String res = "some error occured";
    try {
      final String postId = const Uuid().v1();
      String postUrl =
          await StorageMethods().uploadProfilePhoto('posts', file, true);
      UserPost post = UserPost(
          caption: caption,
          postUrl: postUrl,
          photoUrl: photoUrl,
          username: username,
          uid: uid,
          datePublished: DateTime.now(),
          postId: postId,
          likes: []);

      _fireStore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> updateLikes(String uid, String postId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> postComment(
    String postId,
    String username,
    String profilePhotoUrl,
    String commentText,
    String uid,
  ) async {
    try {
      String commentId = const Uuid().v1();
      if (commentText.isNotEmpty) {
        await _fireStore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'comment': commentText,
          'username': username,
          'userProfilePhotoUrl': profilePhotoUrl,
          'uid': uid,
          'postId': postId,
          'commentId': commentId,
          'dateOfComment': DateTime.now(),
          'likes': [],
        });
      } else {
        if (kDebugMode) {
          print('comment is empty');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> updateCommentLikes(
    String postId,
    String commentId,
    String uid,
    List likes,
  ) async {
    try {
      if (likes.contains(uid)) {
        await _fireStore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _fireStore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<String> addFollower(
      String followedPersonUid, String followingPersonUid) async {
    String res = "some error occured";
    try {
      await _fireStore.collection('users').doc(followedPersonUid).update({
        'followers': FieldValue.arrayUnion([followingPersonUid]),
      });
      await _fireStore.collection('users').doc(followingPersonUid).update({
        'following': FieldValue.arrayUnion([followedPersonUid]),
      });
      res = "success";
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      res = e.toString();
    }
    return res;
  }

  Future<String> removeFollower(
      String followedPersonUid, String followingPersonUid) async {
    String res = "some error occured";
    try {
      await _fireStore.collection('users').doc(followedPersonUid).update({
        'followers': FieldValue.arrayRemove([followingPersonUid]),
      });
      await _fireStore.collection('users').doc(followingPersonUid).update({
        'following': FieldValue.arrayRemove([followedPersonUid]),
      });
      res = "success";
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      res = e.toString();
    }
    return res;
  }

  Future<String> updateProfile(
    String uid,
    Uint8List? file,
    String username,
    String bio,
  ) async {
    String res = "some error occured";
    try {
      if (file != null) {
        bool isdeleted = await StorageMethods().deleteExistingProfilePhoto();
        if (isdeleted) {
          String photoUrl = await StorageMethods()
              .uploadProfilePhoto("profilePics", file, false);
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'photoUrl': photoUrl,
          });
        }
      }
      if (username.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'username': username,
        });
      }
      if (bio.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'bio': bio,
        });
      }

      res = "success";
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      res = e.toString();
    }
    return res;
  }
}

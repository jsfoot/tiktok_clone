import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createProfile(UserProfileModel profile) async {
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  Future<void> uploadAvatar(File file, String fileName) async {
    final fileRef = _storage.ref().child("avatar/$fileName");
    await fileRef.putFile(file);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  Future<void> addFollowingList(String myUid, String targetUid) async {
    await _db.collection("users").doc(myUid).update({
      "followers": FieldValue.arrayUnion([targetUid]),
      "numOfFollowers": FieldValue.increment(1),
    });

    await _db.collection("users").doc(targetUid).update({
      "followings": FieldValue.arrayUnion([myUid]),
      "numOfFollowings": FieldValue.increment(1),
    });
  }

  Future<void> unfollow(String myUid, String targetUid) async {
    await _db.collection("users").doc(myUid).update({
      "followers": FieldValue.arrayRemove([targetUid]),
      "numOfFollowers": FieldValue.increment(-1),
    });

    await _db.collection("users").doc(targetUid).update({
      "followings": FieldValue.arrayRemove([myUid]),
      "numOfFollowings": FieldValue.increment(-1),
    });
  }

  Future<bool> getIsLiked(String uid, String videoId) async {
    final likes = await _db.collection("users").doc(uid).collection("likes").doc(videoId).get();
    return likes.exists;
  }

  Future<List<Map<String, dynamic>>> getAllUserList() async {
    List<Map<String, dynamic>> userList = [];
    final usersQuery = _db.collection("users").get();

    await usersQuery.then((users) {
      for (var user in users.docs) {
        userList.add(user.data());
      }
      return userList;
    });
    return userList;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserVideosList(String userId) async {
    final query = _db.collection("users").doc(userId).collection("videos");
    return query.get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserLikeList(String userId) async {
    final query = _db.collection("users").doc(userId).collection("likes");
    return query.get();
  }
}

final userRepo = Provider((ref) => UserRepository());

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef =
        _storage.ref().child("/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}");
    return fileRef.putFile(video);
  }

  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({int? lastItemCreatedAt}) {
    final query = _db.collection("videos").orderBy("createdAt", descending: true).limit(2);

    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getVideosList() async {
    final query = _db.collection("videos").orderBy("createdAt", descending: true);
    return query.get();
  }

  Future<Map<String, dynamic>> getVideoInfo(String videoId) async {
    final query = await _db.collection("videos").doc(videoId).get();
    final videoInfo = query.data()!;
    return videoInfo;
  }

  Future<void> likeVideo(String videoId, String userId, VideoModel videoData) async {
    final videoQuery = _db.collection("videos").doc(videoId);

    final likeQuery = _db.collection("likes").doc("${videoId}000$userId");
    final like = await likeQuery.get();

    if (!like.exists) {
      await likeQuery.set({
        "createdAt": DateTime.now().microsecondsSinceEpoch,
        "uid": userId,
        "videoId": videoId,
        "thumbnailUrl": videoData.thumbnailUrl,
      });
      await videoQuery.update({"likes": FieldValue.increment(1)});
    } else {
      await videoQuery.update({"likes": FieldValue.increment(-1)});

      likeQuery.delete();
    }

    final userLikeQuery = _db.collection("users").doc(userId).collection("likes").doc(videoId);
    final userLike = await userLikeQuery.get();

    if (!userLike.exists) {
      await userLikeQuery.set({
        "createdAt": DateTime.now().microsecondsSinceEpoch,
        "videoId": videoId,
        "thumbnailUrl": videoData.thumbnailUrl,
      });
    } else {
      userLikeQuery.delete();
    }
  }
}

final videosRepo = Provider((ref) => VideosRepository());

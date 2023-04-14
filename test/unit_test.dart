import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

void main() {
  group("VideoModel Test", () {
    test("Test VideoModel Construntor", () {
      final video = VideoModel(
        title: "title",
        description: "description",
        fileUrl: "fileUrl",
        thumbnailUrl: "thumbnailUrl",
        creatorUid: "creatorUid",
        creator: "creator",
        videoId: "videoId",
        likes: 1,
        comments: 1,
        createdAt: 1,
      );
      expect(video.videoId, "videoId");
    });

    test("Test VideoModel .fromJson Constructor", () {
      final video = VideoModel.fromJson(json: {
        "title": "title",
        "description": "description",
        "fileUrl": "fileUrl",
        "thumbnailUrl": "thumbnailUrl",
        "creatorUid": "creatorUid",
        "creator": "creator",
        "videoId": "videoId",
        "likes": 1,
        "comments": 1,
        "createdAt": 1,
      }, videoId: "videoId");
      expect(video.title, "title");
      expect(video.comments, greaterThan(0));
      expect(video.comments, isInstanceOf<int>());
    });

    test("Test: VideoModel .toJson method", () {
      final video = VideoModel(
        title: "title",
        description: "description",
        fileUrl: "fileUrl",
        thumbnailUrl: "thumbnailUrl",
        creatorUid: "creatorUid",
        creator: "creator",
        videoId: "videoId",
        likes: 1,
        comments: 1,
        createdAt: 1,
      );
      final json = video.toJson();

      expect(json["videoId"], "videoId");
      expect(json['likes'], isInstanceOf<int>());
    });
  });
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class VideoCommentModel {
  final String userName;
  final String userId;
  final String content;
  final String videoId;
  final int createdAt;
  final int likes;

  VideoCommentModel({
    required this.userName,
    required this.userId,
    required this.content,
    required this.videoId,
    required this.createdAt,
    required this.likes,
  });

  VideoCommentModel.fromJson({
    required Map<String, dynamic> json,
    required String videoId,
  })  : userName = json['userName'],
        userId = json['userId'],
        content = json['content'],
        videoId = json['videoId'],
        createdAt = json['createdAt'],
        likes = json['likes'];

  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "userId": userId,
      "content": content,
      "videoId": videoId,
      "createdAt": createdAt,
      "likes": likes,
    };
  }

  VideoCommentModel copyWith({
    String? userName,
    String? userId,
    String? content,
    String? videoId,
    int? createdAt,
    int? likes,
  }) {
    return VideoCommentModel(
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      videoId: videoId ?? this.videoId,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
    );
  }
}

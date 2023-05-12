// ignore_for_file: public_member_api_docs, sort_constructors_first
class VideoCommentModel {
  final String commentId;
  final String userName;
  final String userId;
  final String content;
  final String videoId;
  final int createdAt;
  final int likes;
  final List<dynamic> likedUsers;

  VideoCommentModel({
    required this.commentId,
    required this.userName,
    required this.userId,
    required this.content,
    required this.videoId,
    required this.createdAt,
    required this.likes,
    required this.likedUsers,
  });

  VideoCommentModel.fromJson({
    required Map<String, dynamic> json,
    required String videoId,
  })  : commentId = json['commentId'],
        userName = json['userName'],
        userId = json['userId'],
        content = json['content'],
        videoId = json['videoId'],
        createdAt = json['createdAt'],
        likes = json['likes'],
        likedUsers = json['likedUsers'];

  Map<String, dynamic> toJson() {
    return {
      "commentId": commentId,
      "userName": userName,
      "userId": userId,
      "content": content,
      "videoId": videoId,
      "createdAt": createdAt,
      "likes": likes,
      "likedUsers": likedUsers,
    };
  }

  VideoCommentModel copyWith({
    String? commentId,
    String? userName,
    String? userId,
    String? content,
    String? videoId,
    int? createdAt,
    int? likes,
    List<dynamic>? likedUsers,
  }) {
    return VideoCommentModel(
      commentId: commentId ?? this.commentId,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      videoId: videoId ?? this.videoId,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      likedUsers: likedUsers ?? this.likedUsers,
    );
  }
}

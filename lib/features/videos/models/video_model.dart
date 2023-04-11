// ignore_for_file: public_member_api_docs, sort_constructors_first
class VideoModel {
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final String creatorUid;
  final String creator;
  final String videoId;
  final int likes;
  final int comments;
  final int createdAt;

  VideoModel({
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.creatorUid,
    required this.creator,
    required this.videoId,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  VideoModel.fromJson({
    required Map<String, dynamic> json,
    required String videoId,
  })  : title = json["title"],
        description = json["description"],
        fileUrl = json["fileUrl"],
        thumbnailUrl = json["thumbnailUrl"],
        creatorUid = json["creatorUid"],
        creator = json["creator"],
        videoId = json["videoId"],
        likes = json["likes"],
        comments = json["comments"],
        createdAt = json["createdAt"];

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "fileUrl": fileUrl,
      "thumbnailUrl": thumbnailUrl,
      "creatorUid": creatorUid,
      "creator": creator,
      "videoId": videoId,
      "likes": likes,
      "comments": comments,
      "createdAt": createdAt,
    };
  }

  VideoModel copyWith({
    String? title,
    String? description,
    String? fileUrl,
    String? thumbnailUrl,
    String? creatorUid,
    String? creator,
    String? videoId,
    int? likes,
    int? comments,
    int? createdAt,
  }) {
    return VideoModel(
      title: title ?? this.title,
      description: description ?? this.description,
      fileUrl: fileUrl ?? this.fileUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      creatorUid: creatorUid ?? this.creatorUid,
      creator: creator ?? this.creator,
      videoId: videoId ?? this.videoId,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

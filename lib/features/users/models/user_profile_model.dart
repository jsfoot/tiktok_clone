// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final String birthday;
  final bool hasAvatar;
  final List<dynamic> followings;
  final List<dynamic> followers;
  final int numOfFollowers;
  final int numOfFollowings;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.birthday,
    required this.hasAvatar,
    required this.followings,
    required this.followers,
    required this.numOfFollowers,
    required this.numOfFollowings,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        bio = "",
        link = "",
        birthday = "",
        hasAvatar = false,
        followings = [],
        followers = [],
        numOfFollowers = 0,
        numOfFollowings = 0;

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        bio = json["bio"],
        link = json["link"],
        birthday = json["birthday"],
        hasAvatar = json["hasAvatar"],
        followings = json['followings'],
        followers = json['followers'],
        numOfFollowers = json['numOfFollowers'],
        numOfFollowings = json['numOfFollowings'];

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
      "birthday": birthday,
      "hasAvatar": hasAvatar,
      "followings": followings,
      "followers": followers,
      "numOfFollowers": numOfFollowers,
      "numOfFollowings": numOfFollowings,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? bio,
    String? link,
    String? birthday,
    bool? hasAvatar,
    List<dynamic>? followings,
    List<dynamic>? followers,
    int? numOfFollowers,
    int? numOfFollowings,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      birthday: birthday ?? this.birthday,
      hasAvatar: hasAvatar ?? this.hasAvatar,
      followings: followings ?? this.followings,
      followers: followers ?? this.followers,
      numOfFollowers: numOfFollowers ?? this.numOfFollowers,
      numOfFollowings: numOfFollowings ?? this.numOfFollowings,
    );
  }
}

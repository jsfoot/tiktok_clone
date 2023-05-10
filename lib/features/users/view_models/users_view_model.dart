import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final profile = await _usersRepository.getUserProfile(_authenticationRepository.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }

    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential credential, form) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }

    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      hasAvatar: false,
      email: credential.user!.email ?? "anon@anon.com",
      bio: "undifined",
      link: "undifined",
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? form["name"] ?? "Anon",
      birthday: form["birthday"] ?? "undefined",
      followings: [],
      followers: [],
      numOfFollowers: 0,
      numOfFollowings: 0,
    );
    await _usersRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }

  Future<void> onProfileUpdate(String bio, String link) async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(bio: bio, link: link));
    await _usersRepository.updateUser(state.value!.uid, {"bio": bio, "link": link});
  }

  Future<List<Map<String, dynamic>>> getUserVideosList(String userId) async {
    final videoList = await _usersRepository.getUserVideosList(userId);
    final videos = videoList.docs.map(
      (doc) => doc.data(),
    );
    return videos.toList();
  }

  Future<List<Map<String, dynamic>>> getUserLikeList(String userId) async {
    final likeList = await _usersRepository.getUserLikeList(userId);
    final likes = likeList.docs.map(
      (doc) => doc.data(),
    );
    return likes.toList();
  }

  Future<Map<String, dynamic>?> getOtherUserProfile(String userId) async {
    final profile = await _usersRepository.getUserProfile(userId);
    return profile;
  }

  Future<void> addFollowing(String targetUid) async {
    final myUid = _authenticationRepository.user!.uid;
    if (myUid != targetUid) {
      await _usersRepository.addFollowingList(targetUid, myUid);
    }
  }

  Future<void> unfollow(String targetUid) async {
    final myUid = _authenticationRepository.user!.uid;
    if (myUid != targetUid) {
      await _usersRepository.unfollow(targetUid, myUid);
    }
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);

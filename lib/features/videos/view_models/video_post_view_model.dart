import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<void, String> {
  late final VideosRepository _videoRepository;
  late final UserRepository _userRepository;
  late final String _videoId;

  @override
  FutureOr<void> build(String videoId) async {
    _videoId = videoId;
    _videoRepository = ref.read(videosRepo);
    _userRepository = ref.read(userRepo);
  }

  Future<void> likeVideo(VideoModel videoData) async {
    final user = ref.read(authRepo).user;
    await _videoRepository.likeVideo(_videoId, user!.uid, videoData);
  }

  Future<bool> isLiked() async {
    final user = ref.read(authRepo).user;
    final isLike = await _userRepository.getIsLiked(user!.uid, _videoId);
    return isLike;
  }

  Future<Map<String, dynamic>> getVideoInfo() async {
    return await _videoRepository.getVideoInfo(_videoId);
  }
}

final videoPostProvider = AsyncNotifierProvider.family<VideoPostViewModel, void, String>(
  () => VideoPostViewModel(),
);

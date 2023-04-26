import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';
import 'package:tiktok_clone/features/videos/models/video_comment_model.dart';
import 'package:tiktok_clone/features/videos/repos/video_comment_repo.dart';

class VideoCommentViewModel extends AsyncNotifier<void> {
  late final VideoCommentRepository _videoCommentRepository;
  late final UserRepository _userRepository;

  @override
  FutureOr<void> build() {
    _videoCommentRepository = ref.read(videoCommentRepo);
    _userRepository = ref.read(userRepo);
  }

  Future<void> createVideoComment({required String videoId, required String comment}) async {
    final user = ref.read(authRepo).user!;
    final profile = await _userRepository.findProfile(user.uid);
    await _videoCommentRepository.createVideoComment(
      VideoCommentModel(
        userName: profile!['name'],
        userId: user.uid,
        content: comment,
        videoId: videoId,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        likes: 0,
      ),
      videoId,
    );
  }

  Future<List<Map<String, dynamic>>> getVideoComment(String videoId) async {
    List<Map<String, dynamic>> result = [];
    final query = await ref.read(videoCommentRepo).getVideoComment(videoId);
    for (var element in query) {
      result.add(element.data());
    }
    return result;
  }
}

final videoCommentProvider = AsyncNotifierProvider<VideoCommentViewModel, void>(
  () => VideoCommentViewModel(),
);

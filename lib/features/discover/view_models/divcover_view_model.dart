import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class DiscoverViewModel extends AsyncNotifier<void> {
  late final VideosRepository _videosRepository;

  @override
  FutureOr build() {
    _videosRepository = ref.read(videosRepo);
  }

  Future<List<VideoModel>> getVideosList() async {
    final videoModelList = await _videosRepository.getVideosList();
    final videos = videoModelList.docs.map(
      (doc) => VideoModel.fromJson(
        json: doc.data(),
        videoId: doc.id,
      ),
    );
    return videos.toList();
  }
}

final discoverProvider = AsyncNotifierProvider<DiscoverViewModel, void>(
  () => DiscoverViewModel(),
);

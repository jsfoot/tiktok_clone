import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/view_models/upload_video_view_model.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  final XFile video;
  final bool isPicked;

  const VideoPreviewScreen({
    Key? key,
    required this.video,
    required this.isPicked,
  }) : super(key: key);

  @override
  VideoPreviewScreenState createState() => VideoPreviewScreenState();
}

class VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  late final VideoPlayerController _videoPlayerController;

  bool _savedVideo = false;

  Future<void> _initVideo() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();

    setState(() {});
  }

  Future<void> _saveToGallery() async {
    if (_savedVideo) return;
    _savedVideo = true;

    await GallerySaver.saveVideo(widget.video.path, albumName: "TikTok Clone!");

    setState(() {});
  }

  void _onUploadPressed() async {
    ref.read(uploadVideoProvider.notifier).uploadVideo(
          File(widget.video.path),
          context,
        );
  }

  @override
  void initState() {
    _initVideo();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          if (!widget.isPicked)
            IconButton(
              onPressed: _saveToGallery,
              icon: FaIcon(_savedVideo ? FontAwesomeIcons.check : FontAwesomeIcons.download),
            ),
          IconButton(
            onPressed: ref.watch(uploadVideoProvider).isLoading ? () {} : _onUploadPressed,
            icon: ref.watch(uploadVideoProvider).isLoading
                ? const CircularProgressIndicator()
                : const FaIcon(FontAwesomeIcons.cloudArrowUp),
          ),
        ],
        title: const Text("Preview video"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: _videoPlayerController.value.isInitialized
                  ? VideoPlayer(_videoPlayerController)
                  : const Text("Not initialized video player")),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 3,
            right: MediaQuery.of(context).size.width / 3,
            child: Container(
              color: Colors.white,
              width: Sizes.size20,
              child: const Text(
                "sdfsdasdfasdasdasdfasdf",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

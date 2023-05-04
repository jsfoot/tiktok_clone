import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tiktok_clone/features/videos/view_models/upload_video_view_model.dart';
import 'package:tiktok_clone/utils.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/gaps.dart';
import '../../authentication/views/widgets/form_button.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onUpdateTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
      }
    }
    _onUploadPressed();
  }

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
          video: File(widget.video.path),
          context: context,
          title: formData['title']!,
          description: formData['description']!,
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
            onPressed: ref.watch(uploadVideoProvider).isLoading ? () {} : _onUpdateTap,
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
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDarkMode(context) ? Colors.black54 : Colors.white54,
              ),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Title",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Input video title',
                        ),
                        onSaved: (newValue) {
                          if (newValue != null) {
                            formData['title'] = newValue;
                          } else {
                            formData['title'] = "title";
                          }
                        },
                      ),
                      Gaps.v20,
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Description",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Input video description',
                        ),
                        onSaved: (newValue) {
                          if (newValue != null) {
                            formData['description'] = newValue;
                          } else {
                            formData['description'] = "description";
                          }
                        },
                      ),
                      Gaps.v12,
                      GestureDetector(
                        onTap: ref.watch(uploadVideoProvider).isLoading ? () {} : _onUpdateTap,
                        child: FormButton(
                          formText: ref.watch(uploadVideoProvider).isLoading
                              ? "Now uploading.."
                              : "Upload",
                          disabled: ref.watch(uploadVideoProvider).isLoading,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

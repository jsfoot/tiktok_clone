import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../generated/l10n.dart';

class VideoPost extends ConsumerStatefulWidget {
  final Function onVideoFinished;
  final int index;

  const VideoPost({
    Key? key,
    required this.onVideoFinished,
    required this.index,
  }) : super(key: key);

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost> with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;

  final Duration _animationDuration = const Duration(milliseconds: 200);

  late final AnimationController _animationController;

  late bool _isPaused;
  late bool _isMuted;

  int _maxLines = 1;
  bool _isSeeMoreClicked = false;
  String _seeMoreText = "See more";

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );

    if (ref.read(playbackConfigProvider).autoPlay) {
      _isPaused = false;
    } else {
      _isPaused = true;
    }

    _onPlaybackConfigChanged();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPlaybackConfigChanged() {
    if (!mounted) return;
    final muted = ref.read(playbackConfigProvider).muted;
    // ref.read(playbackConfigProvider.notifier).setMuted(!muted);
    if (muted) {
      _videoPlayerController.setVolume(0);
      _isMuted = true;
    } else {
      _videoPlayerController.setVolume(1);
      _isMuted = false;
    }
  }

  void _onVideoChanged() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration == _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.asset("assets/videos/test_video_2.mp4");
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);

    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
    }
    _videoPlayerController.addListener(_onVideoChanged);
    setState(() {});
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 && !_isPaused && !_videoPlayerController.value.isPlaying) {
      if (ref.read(playbackConfigProvider).autoPlay) {
        _videoPlayerController.play();
      }
    }
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
      setState(() {
        _isPaused = true;
      });
    } else {
      _videoPlayerController.play();
      _animationController.forward();
      setState(() {
        _isPaused = false;
      });
    }
  }

  void _onSeeMoreTap() {
    if (_isSeeMoreClicked == false) {
      _seeMoreText = "See more";
      _maxLines = 1;
    } else {
      _seeMoreText = "See less";
      _maxLines = 3;
    }
    setState(() {
      _isSeeMoreClicked = !_isSeeMoreClicked;
    });
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Center(
        heightFactor: 1.0,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.lg,
          ),
          child: const VideoComments(),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
    _onTogglePause();
  }

  void _onMuteTap() {
    if (_isMuted) {
      _videoPlayerController.setVolume(1);
    } else {
      _videoPlayerController.setVolume(0);
    }
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: Sizes.size20,
            top: Sizes.size32,
            child: IconButton(
              onPressed: _onMuteTap,
              icon: FaIcon(
                _isMuted ? FontAwesomeIcons.volumeXmark : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "@진수",
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v10,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 230,
                      child: Text(
                        "This is a train in Trinidad, Cuba!! This is a train in Trinidad, Cuba!! This is a train in Trinidad, Cuba!! This is a train in Trinidad, Cuba!!",
                        style: const TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: _maxLines,
                      ),
                    ),
                    GestureDetector(
                      onTap: _onSeeMoreTap,
                      child: Text(
                        _seeMoreText,
                        style: const TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                Gaps.v6,
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage("https://avatars.githubusercontent.com/u/76519264?v=4"),
                  child: Text("진수"),
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: S.of(context).likeCount(3215456854),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: S.of(context).commentCount(5132),
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: "Share",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
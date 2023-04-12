// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/view_models/video_post_view_model.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';

class VideoPost extends ConsumerStatefulWidget {
  final Function onVideoFinished;
  final int index;
  final VideoModel videoData;

  const VideoPost({
    Key? key,
    required this.onVideoFinished,
    required this.index,
    required this.videoData,
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
  bool _isLiked = false;
  Map<String, dynamic> _videoInfo = {};
  late int _likeCounts = 0;

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

    _isLike();

    _getVideoInfo();
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

    _isLike();

    _getVideoInfo();

    setState(() {});
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

  void _onLikeTap() {
    ref.read(videoPostProvider(widget.videoData.videoId).notifier).likeVideo(widget.videoData);

    if (_isLiked) {
      _likeCounts -= 1;
    } else {
      _likeCounts += 1;
    }
    _isLiked = !_isLiked;

    setState(() {});
  }

  Future<void> _isLike() async {
    final isLiked = await ref.read(videoPostProvider(widget.videoData.videoId).notifier).isLiked();
    _isLiked = isLiked;
  }

  Future<void> _getVideoInfo() async {
    final videoInfo =
        await ref.read(videoPostProvider(widget.videoData.videoId).notifier).getVideoInfo();
    _videoInfo = videoInfo;
    _likeCounts = _videoInfo["likes"];
  }

  @override
  Widget build(BuildContext context) {
    final hasAvatar = ref.read(usersProvider).value!.hasAvatar;
    final likesCounts = _likeCounts;
    final commentsCounts = _videoInfo["comments"].toString();

    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Image.network(
                    widget.videoData.thumbnailUrl,
                    fit: BoxFit.cover,
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
                Text(
                  "@${widget.videoData.creator}",
                  style: const TextStyle(
                    fontSize: Sizes.size20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v10,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      child: Text(
                        widget.videoData.description,
                        style: const TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: _maxLines,
                      ),
                    ),
                    Gaps.h10,
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
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: hasAvatar
                      ? NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-76fcb.appspot.com/o/avatar%2F${widget.videoData.creatorUid}?alt=media&")
                      : null,
                  child: Text(widget.videoData.creator),
                ),
                Gaps.v24,
                ScaleTap(
                  onPressed: _onLikeTap,
                  onLongPress: _onLikeTap,
                  duration: const Duration(milliseconds: 300),
                  scaleCurve: Curves.fastOutSlowIn,
                  scaleMinValue: 1.7,
                  child: VideoButton(
                    color: _isLiked ? Theme.of(context).primaryColor : Colors.white,
                    icon: FontAwesomeIcons.solidHeart,
                    text: likesCounts.toString(),
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: VideoButton(
                    color: Colors.white,
                    icon: FontAwesomeIcons.solidComment,
                    text: commentsCounts,
                    // text: S.of(context).commentCount(widget.videoData.comments),
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () {},
                  child: const VideoButton(
                    color: Colors.white,
                    icon: FontAwesomeIcons.share,
                    text: "Share",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

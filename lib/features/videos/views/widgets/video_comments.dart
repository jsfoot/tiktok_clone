// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/videos/view_models/video_comment_view_model.dart';
import 'package:tiktok_clone/utils.dart';

import '../../../../generated/l10n.dart';

class VideoComments extends ConsumerStatefulWidget {
  final String videoId;

  const VideoComments({
    Key? key,
    required this.videoId,
  }) : super(key: key);

  @override
  ConsumerState<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends ConsumerState<VideoComments> {
  bool _isWriting = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  void _onClosedPressed() {
    Navigator.of(context).pop();
  }

  void _onstopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = isDarkMode(context);
    final userName = ref.read(usersProvider).value?.name as String;
    Future<List<Map<String, dynamic>>> comments =
        ref.read(videoCommentProvider.notifier).getVideoComment(widget.videoId);

    return FutureBuilder(
      future: comments,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: size.height * 0.8,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.size14),
            ),
            child: Scaffold(
              backgroundColor: isDark ? null : Colors.grey.shade50,
              appBar: AppBar(
                backgroundColor: isDark ? null : Colors.grey.shade50,
                title:
                    Text(S.of(context).commentTitle(snapshot.data!.length, snapshot.data!.length)),
                centerTitle: true,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: _onClosedPressed,
                    icon: const FaIcon(
                      FontAwesomeIcons.xmark,
                    ),
                  ),
                ],
              ),
              body: GestureDetector(
                onTap: () async {
                  _onstopWriting();
                },
                child: Stack(
                  children: [
                    Scrollbar(
                      controller: _scrollController,
                      child: ListView.separated(
                        controller: _scrollController,
                        separatorBuilder: (context, index) => Gaps.v20,
                        padding: const EdgeInsets.only(
                          top: Sizes.size10,
                          bottom: Sizes.size80,
                          left: Sizes.size16,
                          right: Sizes.size16,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: isDark ? Colors.grey.shade500 : null,
                              foregroundImage: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-76fcb.appspot.com/o/avatar%2F${snapshot.data![index]['userId']}?alt=media&",
                              ),
                              child: Text(
                                snapshot.data![index]['userName'],
                              ),
                            ),
                            Gaps.h10,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![index]['userName'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Sizes.size14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  Gaps.v3,
                                  Text(
                                    snapshot.data![index]['content'],
                                  ),
                                ],
                              ),
                            ),
                            Gaps.h10,
                            Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.heart,
                                  size: Sizes.size20,
                                  color: Colors.grey.shade500,
                                ),
                                Gaps.v2,
                                Text(
                                  snapshot.data![index]['likes'].toString(),
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      width: size.width < Breakpoints.lg ? size.width : Breakpoints.lg,
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size16,
                            vertical: Sizes.size10,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.grey.shade500,
                                foregroundColor: Colors.white,
                                child: Text(
                                  userName,
                                ),
                              ),
                              Gaps.h10,
                              Expanded(
                                child: SizedBox(
                                  height: Sizes.size44,
                                  child: TextField(
                                    controller: _textEditingController,
                                    onTap: _onStartWriting,
                                    expands: true,
                                    maxLines: null,
                                    minLines: null,
                                    textInputAction: TextInputAction.newline,
                                    cursorColor: Theme.of(context).primaryColor,
                                    decoration: InputDecoration(
                                      hintText: "Write a comment...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          Sizes.size12,
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor:
                                          isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: Sizes.size12,
                                      ),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                          right: Sizes.size14,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.at,
                                              color: isDark
                                                  ? Colors.grey.shade500
                                                  : Colors.grey.shade900,
                                            ),
                                            Gaps.h14,
                                            FaIcon(
                                              FontAwesomeIcons.gift,
                                              color: isDark
                                                  ? Colors.grey.shade500
                                                  : Colors.grey.shade900,
                                            ),
                                            Gaps.h14,
                                            FaIcon(
                                              FontAwesomeIcons.faceSmile,
                                              color: isDark
                                                  ? Colors.grey.shade500
                                                  : Colors.grey.shade900,
                                            ),
                                            if (_isWriting) Gaps.h14,
                                            if (_isWriting)
                                              GestureDetector(
                                                onTap: () {
                                                  ref
                                                      .read(videoCommentProvider.notifier)
                                                      .createVideoComment(
                                                        videoId: widget.videoId,
                                                        comment: _textEditingController.text,
                                                      );
                                                  _textEditingController.clear();
                                                  _onstopWriting();
                                                },
                                                child: FaIcon(
                                                  FontAwesomeIcons.circleArrowUp,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

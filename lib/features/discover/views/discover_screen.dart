import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/discover/view_models/divcover_view_model.dart';
import 'package:tiktok_clone/utils.dart';

import '../../inbox/view_models/chat_room_view_model.dart';
import '../../users/view_models/users_view_model.dart';
import '../../users/views/user_profile_screen.dart';
import '../../videos/models/video_model.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  List<dynamic> followingList = [];

  Future<void> _onAvatarTap(String userId) async {
    await showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (context) => Center(
        heightFactor: 1.0,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.lg,
          ),
          child: UserProfileScreen(userId: userId, tab: "otherUser"),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _onFollowPressed(String targetUserId) async {
    await ref.read(usersProvider.notifier).addFollowing(targetUserId);
    setState(() {});
  }

  void _onUnfollowPressed(String targetUserId) async {
    await ref.read(usersProvider.notifier).unfollow(targetUserId);
  }

  void _onSearchChanged(String value) {
    print("Input text : $value");
  }

  void _onSearchSubmitted(String value) {
    print("Submitted : $value");
  }

  void _onTitleTap(String creatorUid) async {
    await showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (context) => Center(
        heightFactor: 1.0,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.lg,
          ),
          child: UserProfileScreen(userId: creatorUid, tab: "otherUser"),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _makeTile(int index, snapshot) {
    bool isFollow = followingList.contains(snapshot.data![index]['uid']);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Sizes.size12,
      ),
      onTap: () => {
        _onTitleTap(snapshot.data![index]['uid']),
      },
      horizontalTitleGap: Sizes.size10,
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-76fcb.appspot.com/o/avatar%2F${snapshot.data![index]['uid']}?alt=media&",
        ),
        child: Text(
          snapshot.data![index]['name'],
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            snapshot.data![index]['name'],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size20,
            ),
          ),
          Gaps.h16,
          Text(
            snapshot.data![index]['bio'],
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: Sizes.size14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      trailing: ScaleTap(
        onPressed: () {
          if (!isFollow) {
            _onFollowPressed(snapshot.data![index]['uid']);
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Unfollow ${snapshot.data![index]['name']}"),
                content: const Text("Are you sure?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      _onUnfollowPressed(snapshot.data![index]['uid']);

                      Navigator.of(context).pop();
                    },
                    child: const Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("No"),
                  ),
                ],
              ),
            );
          }
        },
        onLongPress: () {},
        duration: const Duration(milliseconds: 300),
        scaleMinValue: 1.2,
        opacityMinValue: 0.7,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: Sizes.size11,
            horizontal: isFollow ? Sizes.size14 + Sizes.size1 : Sizes.size24,
          ),
          decoration: BoxDecoration(
            color: isFollow ? Colors.grey.shade400 : Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                Sizes.size3,
              ),
            ),
          ),
          child: Text(
            isFollow ? "Followed" : "Follow",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Future<List<VideoModel>> videoList = ref.read(discoverProvider.notifier).getVideosList();
    Future<List<Map<String, dynamic>>> userList =
        ref.read(chatRoomProvider.notifier).getAllUserList();

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          // title: CupertinoSearchTextField(
          //   controller: _textEditingController,
          //   onChanged: _onSearchChanged,
          //   onSubmitted: _onSearchSubmitted,
          // ),
          title: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.sm,
            ),
            child: SizedBox(
              height: 36,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size2,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const FaIcon(FontAwesomeIcons.angleLeft),
                    ),
                    Gaps.h20,
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          _onSearchChanged(_textEditingController.text);
                        },
                        onSubmitted: (value) {
                          _onSearchSubmitted(_textEditingController.text);
                        },
                        maxLines: 1,
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Sizes.size4),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          contentPadding: const EdgeInsets.only(),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                              right: Sizes.size10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Gaps.h12,
                                GestureDetector(
                                  onTap: () {
                                    _onSearchSubmitted(_textEditingController.text);
                                  },
                                  child: const FaIcon(
                                    FontAwesomeIcons.magnifyingGlass,
                                    size: Sizes.size16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                              right: Sizes.size10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Gaps.h20,
                                GestureDetector(
                                  onTap: () => _textEditingController.clear(),
                                  child: const FaIcon(
                                    FontAwesomeIcons.solidCircleXmark,
                                    size: Sizes.size18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gaps.h16,
                    const FaIcon(
                      FontAwesomeIcons.sliders,
                      size: Sizes.size16 + Sizes.size2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottom: TabBar(
            onTap: (value) => FocusScope.of(context).unfocus(),
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
            splashFactory: NoSplash.splashFactory,
            isScrollable: true,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
            tabs: [
              for (var tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            topTap(videoList, width),
            userTap(userList),
            topTap(videoList, width),
            for (var tab in tabs.skip(3))
              Center(
                child: Text(
                  tab,
                  style: const TextStyle(
                    fontSize: Sizes.size28,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<Map<String, dynamic>>> userTap(Future<List<Map<String, dynamic>>> userList) {
    return FutureBuilder(
      future: userList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final myUid = ref.read(authRepo).user!.uid;
          int idx = snapshot.data!.indexWhere((element) => element['uid'] == myUid);
          if (idx != -1) {
            followingList = snapshot.data![idx]['followings'];
          }
          snapshot.data!.removeWhere((element) => element['uid'] == myUid);

          return Center(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                thickness: 0.5,
                indent: Sizes.size12,
                endIndent: Sizes.size12,
                height: 0.5,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size8,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Sizes.size12,
                      ),
                      child: _makeTile(index, snapshot),
                    ),
                  ],
                );
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  FutureBuilder<List<VideoModel>> topTap(Future<List<VideoModel>> videoList, double width) {
    return FutureBuilder(
      future: videoList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: snapshot.data!.length,
            padding: const EdgeInsets.all(Sizes.size6),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width > Breakpoints.lg ? 5 : 2,
              crossAxisSpacing: Sizes.size10,
              mainAxisSpacing: Sizes.size10,
              childAspectRatio: 9 / 21,
            ),
            itemBuilder: (context, index) => LayoutBuilder(
              builder: (context, constraints) => Column(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Sizes.size4,
                      ),
                    ),
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: "assets/images/placeholder.jpg",
                        image: snapshot.data![index].thumbnailUrl,
                        // "https://steamuserimages-a.akamaihd.net/ugc/1644340994747007967/853B20CD7694F5CF40E83AAC670572A3FE1E3D35/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
                      ),
                    ),
                  ),
                  Gaps.v10,
                  Text(
                    snapshot.data![index].title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: Sizes.size18,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  Gaps.v5,
                  DefaultTextStyle(
                    style: TextStyle(
                      color: isDarkMode(context) ? Colors.grey.shade300 : Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => _onAvatarTap(snapshot.data![index].creatorUid),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-76fcb.appspot.com/o/avatar%2F${snapshot.data![index].creatorUid}?alt=media&"
                                // "https://avatars.githubusercontent.com/u/76519264?v=4",
                                ),
                          ),
                        ),
                        Gaps.h6,
                        Expanded(
                          child: Text(
                            snapshot.data![index].creator,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Gaps.h4,
                        FaIcon(
                          FontAwesomeIcons.heart,
                          size: Sizes.size16,
                          color: Colors.grey.shade600,
                        ),
                        Gaps.h2,
                        Text(
                          snapshot.data![index].likes.toString(),
                        ),
                      ],
                    ),
                  )
                ],
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

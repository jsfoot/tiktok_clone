import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/discover/view_models/divcover_view_model.dart';
import 'package:tiktok_clone/utils.dart';

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

  void _onSearchChanged(String value) {
    print("Input text : $value");
  }

  void _onSearchSubmitted(String value) {
    print("Submitted : $value");
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onClearTap() {
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Future<List<VideoModel>> videoList = ref.read(discoverProvider.notifier).getVideosList();

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
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
                                  onTap: () {},
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
                                  onTap: _onClearTap,
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
        body: FutureBuilder(
          future: videoList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TabBarView(
                children: [
                  GridView.builder(
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
                              color:
                                  isDarkMode(context) ? Colors.grey.shade300 : Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-76fcb.appspot.com/o/avatar%2F${snapshot.data![index].creatorUid}?alt=media&"
                                      // "https://avatars.githubusercontent.com/u/76519264?v=4",
                                      ),
                                ),
                                Gaps.h4,
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
                  ),
                  for (var tab in tabs.skip(1))
                    Center(
                      child: Text(
                        tab,
                        style: const TextStyle(
                          fontSize: Sizes.size28,
                        ),
                      ),
                    ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

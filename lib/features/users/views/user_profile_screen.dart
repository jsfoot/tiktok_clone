// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/users/views/update_profile_screen.dart';
import 'package:tiktok_clone/features/users/views/widgets/avatar.dart';
import 'package:tiktok_clone/features/users/views/widgets/persistent_icon_bar.dart';
import 'package:tiktok_clone/features/users/views/widgets/persistent_tab_bar.dart';

import '../../../constants/gaps.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  // final String username;
  final String tab;

  const UserProfileScreen({
    Key? key,
    // required this.username,
    required this.tab,
  }) : super(key: key);

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _onPersonPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const UpdateProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bio = ref.read(usersProvider).value!.bio;
    final link = ref.read(usersProvider).value!.link;

    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            body: SafeArea(
              child: DefaultTabController(
                initialIndex: widget.tab == "likes" ? 1 : 0,
                length: 2,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: Breakpoints.xxl,
                    ),
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            title: Text(data.name),
                            centerTitle: true,
                            actions: [
                              IconButton(
                                onPressed: _onPersonPressed,
                                icon: const Icon(
                                  Icons.person_2_outlined,
                                  size: Sizes.size20,
                                ),
                              ),
                              IconButton(
                                onPressed: _onGearPressed,
                                icon: const FaIcon(
                                  FontAwesomeIcons.gear,
                                  size: Sizes.size20,
                                ),
                              ),
                            ],
                          ),
                          if (width < Breakpoints.md)
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Gaps.v20,
                                  Avatar(
                                    name: data.name,
                                    hasAvatar: data.hasAvatar,
                                    uid: data.uid,
                                  ),
                                  Gaps.v20,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "@${data.name}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: Sizes.size18,
                                        ),
                                      ),
                                      Gaps.h5,
                                      FaIcon(
                                        FontAwesomeIcons.solidCircleCheck,
                                        size: Sizes.size16,
                                        color: Colors.blue.shade500,
                                      ),
                                    ],
                                  ),
                                  Gaps.v24,
                                  SizedBox(
                                    height: Sizes.size52,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "97",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Sizes.size18,
                                              ),
                                            ),
                                            Gaps.v2,
                                            Text(
                                              "Following",
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        VerticalDivider(
                                          width: Sizes.size32,
                                          thickness: Sizes.size1,
                                          color: Colors.grey.shade300,
                                          indent: Sizes.size12,
                                          endIndent: Sizes.size16,
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              "10M",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Sizes.size18,
                                              ),
                                            ),
                                            Gaps.v2,
                                            Text(
                                              "Followers",
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        VerticalDivider(
                                          width: Sizes.size32,
                                          thickness: Sizes.size1,
                                          color: Colors.grey.shade300,
                                          indent: Sizes.size12,
                                          endIndent: Sizes.size16,
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              "194.3M",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: Sizes.size18,
                                              ),
                                            ),
                                            Gaps.v2,
                                            Text(
                                              "Likes",
                                              style: TextStyle(
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Gaps.v4,
                                  FractionallySizedBox(
                                    widthFactor: 0.65,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: Sizes.size11,
                                            horizontal: Sizes.size52,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                Sizes.size3,
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            "Follow",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Gaps.h4,
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: Sizes.size10,
                                            horizontal: Sizes.size12,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                Sizes.size3,
                                              ),
                                            ),
                                          ),
                                          child: const FaIcon(
                                            FontAwesomeIcons.youtube,
                                            size: Sizes.size20,
                                          ),
                                        ),
                                        Gaps.h4,
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: Sizes.size12,
                                            horizontal: Sizes.size18,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                Sizes.size3,
                                              ),
                                            ),
                                          ),
                                          child: const FaIcon(
                                            FontAwesomeIcons.caretDown,
                                            size: Sizes.size16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Gaps.v10,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Sizes.size32,
                                    ),
                                    child: Text(
                                      bio,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Gaps.v14,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.link,
                                        size: Sizes.size12,
                                      ),
                                      Gaps.h4,
                                      Text(
                                        link,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Gaps.v5,
                                    ],
                                  ),
                                  Gaps.v20,
                                ],
                              ),
                            ),
                          if (width > Breakpoints.md)
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Avatar(
                                            name: data.name,
                                            hasAvatar: data.hasAvatar,
                                            uid: data.uid,
                                          ),
                                          Gaps.v8,
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "@${data.name}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: Sizes.size18,
                                                ),
                                              ),
                                              Gaps.h5,
                                              FaIcon(
                                                FontAwesomeIcons.solidCircleCheck,
                                                size: Sizes.size16,
                                                color: Colors.blue.shade500,
                                              ),
                                            ],
                                          ),
                                          Gaps.v8,
                                        ],
                                      ),
                                      Gaps.h36,
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: Sizes.size52,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          "97",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: Sizes.size18,
                                                          ),
                                                        ),
                                                        Gaps.v2,
                                                        Text(
                                                          "Following",
                                                          style: TextStyle(
                                                            color: Colors.grey.shade500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    VerticalDivider(
                                                      width: Sizes.size32,
                                                      thickness: Sizes.size1,
                                                      color: Colors.grey.shade300,
                                                      indent: Sizes.size12,
                                                      endIndent: Sizes.size16,
                                                    ),
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          "10M",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: Sizes.size18,
                                                          ),
                                                        ),
                                                        Gaps.v2,
                                                        Text(
                                                          "Followers",
                                                          style: TextStyle(
                                                            color: Colors.grey.shade500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    VerticalDivider(
                                                      width: Sizes.size32,
                                                      thickness: Sizes.size1,
                                                      color: Colors.grey.shade300,
                                                      indent: Sizes.size12,
                                                      endIndent: Sizes.size16,
                                                    ),
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          "194.3M",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: Sizes.size18,
                                                          ),
                                                        ),
                                                        Gaps.v2,
                                                        Text(
                                                          "Likes",
                                                          style: TextStyle(
                                                            color: Colors.grey.shade500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Gaps.v8,
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: Sizes.size11,
                                                  horizontal: Sizes.size52,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColor,
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(
                                                      Sizes.size3,
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Follow",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Gaps.h4,
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: Sizes.size10,
                                                  horizontal: Sizes.size12,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey.shade300),
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(
                                                      Sizes.size3,
                                                    ),
                                                  ),
                                                ),
                                                child: const FaIcon(
                                                  FontAwesomeIcons.youtube,
                                                  size: Sizes.size20,
                                                ),
                                              ),
                                              Gaps.h4,
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: Sizes.size12,
                                                  horizontal: Sizes.size18,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey.shade300),
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(
                                                      Sizes.size3,
                                                    ),
                                                  ),
                                                ),
                                                child: const FaIcon(
                                                  FontAwesomeIcons.caretDown,
                                                  size: Sizes.size16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Gaps.v8,
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Sizes.size32,
                                    ),
                                    child: Text(
                                      "All highlights and where to watch live matches on blar blar blar~~ it is a very very long text",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Gaps.v8,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.link,
                                        size: Sizes.size12,
                                      ),
                                      Gaps.h4,
                                      Text(
                                        link,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Gaps.v5,
                                    ],
                                  ),
                                  Gaps.v8,
                                ],
                              ),
                            ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: PersistentTabBar(),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: PersistentIconBar(),
                          ),
                        ];
                      },
                      body: TabBarView(
                        children: [
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: 20,
                            padding: EdgeInsets.zero,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: width > Breakpoints.lg ? 5 : 3,
                              crossAxisSpacing: Sizes.size2,
                              mainAxisSpacing: Sizes.size2,
                              childAspectRatio: 9 / 14,
                            ),
                            itemBuilder: (context, index) => Stack(
                              children: [
                                Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 9 / 14,
                                      child: FadeInImage.assetNetwork(
                                        fit: BoxFit.cover,
                                        placeholder: "assets/images/placeholder.jpg",
                                        image:
                                            "https://steamuserimages-a.akamaihd.net/ugc/1644340994747007967/853B20CD7694F5CF40E83AAC670572A3FE1E3D35/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 4,
                                  left: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Sizes.size2,
                                      vertical: Sizes.size1,
                                    ),
                                    color: Theme.of(context).primaryColor,
                                    child: const Text(
                                      "Pinned",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Sizes.size12,
                                      ),
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  right: 4,
                                  top: 4,
                                  child: Icon(
                                    Icons.photo_rounded,
                                    color: Colors.white,
                                    size: Sizes.size20,
                                  ),
                                ),
                                Positioned(
                                  bottom: 4,
                                  left: 4,
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.play_arrow_outlined,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "3.1M",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Center(
                            child: Text("Page two"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
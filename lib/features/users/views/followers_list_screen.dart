// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/users/views/user_profile_screen.dart';

import '../../../constants/breakpoints.dart';
import '../../../constants/sizes.dart';
import '../../authentication/repos/authentication_repo.dart';

class FollowersListScreen extends ConsumerStatefulWidget {
  static const String routeName = "followersList";
  static const String routeURL = "/followersList";

  const FollowersListScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FollowersListScreenState();
}

class _FollowersListScreenState extends ConsumerState<FollowersListScreen> {
  Future<void> _onTileTap(String userId) async {
    await showModalBottomSheet(
      isScrollControlled: true,
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

  Widget _makeTile(int index, snapshot) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: Sizes.size10,
        horizontal: Sizes.size12,
      ),
      onTap: () {
        _onTileTap(snapshot!.data['uid']);
      },
      horizontalTitleGap: Sizes.size8,
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-76fcb.appspot.com/o/avatar%2F${snapshot.data!['uid']}?alt=media&",
        ),
        child: Text(
          snapshot!.data['name'],
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            snapshot!.data['name'],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size18,
            ),
          ),
          Gaps.h16,
          Text(
            snapshot!.data['bio'],
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: Sizes.size14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> getOtherUserProfile(String userId) async {
    final userProfile = await ref.read(usersProvider.notifier).getUserProfile(userId);
    return userProfile;
  }

  @override
  Widget build(BuildContext context) {
    final myUid = ref.read(authRepo).user!.uid;
    Future<Map<String, dynamic>?> myProfile =
        ref.read(usersProvider.notifier).getUserProfile(myUid);

    return FutureBuilder(
      future: myProfile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "followers",
              ),
              centerTitle: true,
              elevation: 1,
            ),
            body: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: Breakpoints.lg,
                ),
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 0.5,
                    indent: Sizes.size12,
                    endIndent: Sizes.size12,
                    height: 0.5,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size10,
                  ),
                  itemCount: snapshot.data!['followers'].length,
                  itemBuilder: (context, index) {
                    Future<Map<String, dynamic>?> userProfile =
                        getOtherUserProfile(snapshot.data!['followers'][index]);

                    return FutureBuilder(
                      future: userProfile,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              _makeTile(index, snapshot),
                            ],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  },
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

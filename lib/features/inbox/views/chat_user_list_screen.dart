import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';

import '../../../constants/breakpoints.dart';
import '../../../constants/sizes.dart';
import '../view_models/chat_room_view_model.dart';
import 'chat_detail_screen.dart';

class ChatUserListScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatUserList";
  static const String routeURL = "/chatUserList";

  const ChatUserListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatUserListScreenState();
}

class _ChatUserListScreenState extends ConsumerState<ChatUserListScreen> {
  Widget _makeTile(int index, snapshot) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: Sizes.size10,
        horizontal: Sizes.size12,
      ),
      onTap: () => _onTileTap(index, snapshot),
      horizontalTitleGap: Sizes.size8,
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-76fcb.appspot.com/o/avatar%2F${snapshot.data![index]['uid']}?alt=media&",
        ),
        child: Text(
          snapshot.data![index]['name'],
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            snapshot.data![index]['name'],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size18,
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
    );
  }

  void _onTileTap(int index, snapshot) async {
    final chatRoomId =
        await ref.read(chatRoomProvider.notifier).getChatRoomId(snapshot.data![index]['uid']);
    final myUid = ref.read(authRepo).user!.uid;
    if (snapshot.data![index]['uid'] == myUid) return;
    if (chatRoomId != null) {
      context.pushNamed(
        ChatDetailScreen.routeName,
        extra: {
          'chatRoomId': chatRoomId,
          'yourUid': snapshot.data![index]['uid'],
        },
      );
    } else {
      await ref.read(chatRoomProvider.notifier).createChatRoom(snapshot.data![index]);
      final chatRoomId =
          await ref.read(chatRoomProvider.notifier).getChatRoomId(snapshot.data![index]['uid']);
      context.pushNamed(
        ChatDetailScreen.routeName,
        extra: {
          'chatRoomId': chatRoomId,
          'yourUid': snapshot.data![index]['uid'],
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> userList = ref.read(chatRoomProvider.notifier).getUserList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choose friend",
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_add),
          ),
        ],
        centerTitle: true,
        elevation: 1,
      ),
      body: FutureBuilder(
        future: userList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
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
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        _makeTile(index, snapshot),
                      ],
                    );
                  },
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

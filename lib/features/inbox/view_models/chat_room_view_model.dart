import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/repos/chat_room_repo.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';

import '../models/chat_room_model.dart';

class ChatRoomViewModel extends AsyncNotifier<void> {
  late final ChatRoomRepo _chatRoomRepo;
  late final UserRepository _userRepository;

  @override
  FutureOr<void> build() {
    _chatRoomRepo = ref.read(chatRoomRepo);
    _userRepository = ref.read(userRepo);
  }

  Future<void> createChatRoom(Map<String, dynamic> yourUserProfile) async {
    final myUid = ref.read(authRepo).user!.uid;
    final myUserProfile = await _userRepository.findProfile(myUid);

    await _chatRoomRepo.createChatRoom(
        chatRoomModel: ChatRoomModel(
          personA: myUid,
          personB: yourUserProfile['uid'],
          chatRoomId: "${myUid}000${yourUserProfile['uid']}",
          createdAt: DateTime.now(),
          nameOfPersonA: myUserProfile!['name'],
          nameOfPersonB: yourUserProfile['name'],
          lastMessage: "",
        ),
        myUid: myUid,
        yourUid: yourUserProfile['uid']);
  }

  Future<List<Map<String, dynamic>>> getUserList() async {
    final userList = await _userRepository.getUserList();

    return userList;
  }

  Future<List<Map<String, dynamic>>> getChatRoomList(String userId) async {
    return await _chatRoomRepo.getChatRoomList(userId);
  }

  Future<String?> getChatRoomId(String userId) async {
    final myUid = ref.read(authRepo).user!.uid;
    if (userId != myUid) {
      final list = await getChatRoomList(userId);
      if (list.isEmpty) {
        return null;
      } else {
        return list.first['chatRoomId'];
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getChatRoomInfo(String chatRoomId) async {
    return await _chatRoomRepo.getChatRoomInfo(chatRoomId);
  }
}

final chatRoomProvider = AsyncNotifierProvider<ChatRoomViewModel, void>(
  () => ChatRoomViewModel(),
);
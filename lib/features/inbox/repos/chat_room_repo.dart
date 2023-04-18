import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';

class ChatRoomRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createChatRoom(
      {required ChatRoomModel chatRoomModel,
      required String myUid,
      required String yourUid}) async {
    await _db.collection("chat_rooms").doc("${myUid}000$yourUid").set(chatRoomModel.toJson());

    await _db
        .collection("users")
        .doc(myUid)
        .collection("chat_rooms")
        .doc("${myUid}000$yourUid")
        .set(chatRoomModel.toJson());
    await _db
        .collection("users")
        .doc(yourUid)
        .collection("chat_rooms")
        .doc("${myUid}000$yourUid")
        .set(chatRoomModel.toJson());
  }

  Future<List<Map<String, dynamic>>> getChatRoomList(String userId) async {
    List<Map<String, dynamic>> roomIdList = [];
    final queryPersonA =
        await _db.collection("chat_rooms").where("personA", isEqualTo: userId).get();
    for (var chatRoomModel in queryPersonA.docs) {
      roomIdList.add(chatRoomModel.data());
    }

    final queryPersonB =
        await _db.collection("chat_rooms").where("personB", isEqualTo: userId).get();
    for (var chatRoomModel in queryPersonB.docs) {
      roomIdList.add(chatRoomModel.data());
    }

    return roomIdList;
  }

  Future<Map<String, dynamic>?> getChatRoomInfo(String chatRoomId) async {
    final query = await _db.collection("chat_rooms").doc(chatRoomId).get();
    return query.data();
  }
}

final chatRoomRepo = Provider(
  (ref) => ChatRoomRepo(),
);

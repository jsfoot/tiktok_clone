import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final List<int> _items = [];
  final Duration _duration = const Duration(milliseconds: 500);
  final List<String> _ives = [
    "오빠 뭐해? 나 심심해 같이 놀아줘!",
    "오빠 어디야? 나 오빠 보고싶어...",
    "오빠! 오늘은 나랑 같이 놀아줘!",
    "사랑해♥♡",
  ];

  void _addItem() {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(
        _items.length,
        duration: _duration,
      );
      _items.add(_items.length);
    }
  }

  void _deleteItem(int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
          index,
          (context, animation) => SizeTransition(
                sizeFactor: animation,
                child: Container(
                  color: Colors.red,
                  child: _makeTile(index),
                ),
              ),
          duration: _duration);
      _items.removeAt(index);
    }
  }

  void _onChatTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatDetailScreen(),
      ),
    );
  }

  Widget _makeTile(int index) {
    return ListTile(
      onTap: _onChatTap,
      onLongPress: () => _deleteItem(index),
      leading: const CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
            "https://i.namu.wiki/i/_S33x7gfqLzEoK-LtYuAX2HTclRLuR4_M5Ajt87WPT6f2JwN1OSrTgBJUb5frxPQn5_5uyF9Gccyyiw9kLOkI_nvZJKptDMoaLfAvuHCAfkr2xgdGtEpz7jkfagqwB8pw86169Ghyg2cnUqH9YH-Rw.webp"),
        child: Text("원영"),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "원영 ($index)",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "2:16 PM",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
      subtitle: Text(_ives[index % 4]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Direct messages",
        ),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),
        ],
        centerTitle: true,
        elevation: 1,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.lg,
          ),
          child: AnimatedList(
            key: _key,
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size10,
            ),
            itemBuilder: (context, index, animation) {
              return FadeTransition(
                key: Key('$index'),
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  child: _makeTile(index),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

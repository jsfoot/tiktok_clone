import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({Key? key}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: const CircleAvatar(
              radius: Sizes.size24,
              foregroundImage: NetworkImage(
                  "https://i.namu.wiki/i/_S33x7gfqLzEoK-LtYuAX2HTclRLuR4_M5Ajt87WPT6f2JwN1OSrTgBJUb5frxPQn5_5uyF9Gccyyiw9kLOkI_nvZJKptDMoaLfAvuHCAfkr2xgdGtEpz7jkfagqwB8pw86169Ghyg2cnUqH9YH-Rw.webp"),
              child: Text("원영")),
          title: const Text(
            "원영",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text("Active now"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              FaIcon(
                FontAwesomeIcons.flag,
                size: Sizes.size20,
                color: Colors.black,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size20,
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size20,
              horizontal: Sizes.size14,
            ),
            itemBuilder: (context, index) {
              final isMine = index % 2 == 1;
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(Sizes.size14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(Sizes.size20),
                        topRight: const Radius.circular(Sizes.size20),
                        bottomLeft: Radius.circular(isMine ? Sizes.size20 : Sizes.size5),
                        bottomRight: Radius.circular(isMine ? Sizes.size5 : Sizes.size20),
                      ),
                      color: isMine ? Colors.blue : Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      isMine ? "응!" : "오빠!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size16,
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => Gaps.v10,
            itemCount: 10,
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: BottomAppBar(
              color: Colors.grey.shade50,
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(),
                  ),
                  Gaps.h20,
                  Container(
                    child: const FaIcon(
                      FontAwesomeIcons.paperPlane,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

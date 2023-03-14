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
  bool _isWriting = false;

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  void _onStopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            children: [
              const CircleAvatar(
                radius: Sizes.size24,
                foregroundImage: NetworkImage(
                    "https://i.namu.wiki/i/_S33x7gfqLzEoK-LtYuAX2HTclRLuR4_M5Ajt87WPT6f2JwN1OSrTgBJUb5frxPQn5_5uyF9Gccyyiw9kLOkI_nvZJKptDMoaLfAvuHCAfkr2xgdGtEpz7jkfagqwB8pw86169Ghyg2cnUqH9YH-Rw.webp"),
                child: Text("원영"),
              ),
              Positioned(
                top: Sizes.size32,
                left: Sizes.size32,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size2,
                    vertical: Sizes.size2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100),
                    ),
                    color: Colors.grey.shade50,
                  ),
                  child: const Icon(
                    Icons.circle,
                    color: Colors.green,
                    size: Sizes.size14,
                  ),
                ),
              ),
            ],
          ),
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
      body: GestureDetector(
        onTap: _onStopWriting,
        child: Stack(
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
                elevation: 0,
                color: Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size10,
                    horizontal: Sizes.size10,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isWriting)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Sizes.size32),
                                color: Colors.grey.shade200,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: Sizes.size2),
                              width: Sizes.size80,
                              height: Sizes.size28,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("\u{2764}"),
                                  Text("\u{2764}"),
                                  Text("\u{2764}"),
                                ],
                              ),
                            ),
                            Gaps.h7,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Sizes.size28),
                                color: Colors.grey.shade200,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: Sizes.size2),
                              width: Sizes.size80,
                              height: Sizes.size28,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("\u{1F602}"),
                                  Text("\u{1F602}"),
                                  Text("\u{1F602}"),
                                ],
                              ),
                            ),
                            Gaps.h7,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Sizes.size28),
                                color: Colors.grey.shade200,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: Sizes.size2),
                              width: Sizes.size80,
                              height: Sizes.size28,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("\u{1F44D}"),
                                  Text("\u{1F44D}"),
                                  Text("\u{1F44D}"),
                                ],
                              ),
                            ),
                            Gaps.h7,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Sizes.size28),
                                color: Colors.grey.shade200,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: Sizes.size2),
                              width: Sizes.size72 + Sizes.size36,
                              height: Sizes.size28,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  FaIcon(
                                    FontAwesomeIcons.circlePlay,
                                    size: Sizes.size16,
                                  ),
                                  Gaps.h4,
                                  Text("Share post"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      Gaps.v10,
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: Sizes.size40,
                              child: TextField(
                                onTap: _onStartWriting,
                                maxLines: 5,
                                minLines: 1,
                                textInputAction: TextInputAction.newline,
                                cursorColor: Theme.of(context).primaryColor,
                                decoration: InputDecoration(
                                  hintText: "Send a Message...",
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(Sizes.size20),
                                      topRight: Radius.circular(Sizes.size20),
                                      bottomLeft: Radius.circular(Sizes.size20),
                                      bottomRight: Radius.zero,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: Sizes.size10,
                                  ),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.faceLaugh,
                                        color: Colors.black,
                                      ),
                                      Gaps.h10,
                                      if (_isWriting)
                                        GestureDetector(
                                          onTap: _onStopWriting,
                                          child: FaIcon(
                                            FontAwesomeIcons.circleArrowUp,
                                            color: Theme.of(context).primaryColor,
                                            size: Sizes.size20,
                                          ),
                                        ),
                                      Gaps.h10,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Gaps.h8,
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey.shade300,
                            child: const Padding(
                              padding: EdgeInsets.only(
                                right: Sizes.size3,
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.solidPaperPlane,
                                color: Colors.white,
                                size: Sizes.size20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

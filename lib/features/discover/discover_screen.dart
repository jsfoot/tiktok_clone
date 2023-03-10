import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
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
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: SizedBox(
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
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.size4),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
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
                                  color: Colors.black,
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
                                child: FaIcon(
                                  FontAwesomeIcons.solidCircleXmark,
                                  color: Colors.grey.shade600,
                                  size: Sizes.size16 + Sizes.size2,
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
          bottom: TabBar(
            onTap: (value) => FocusScope.of(context).unfocus(),
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
            splashFactory: NoSplash.splashFactory,
            isScrollable: true,
            unselectedLabelColor: Colors.grey.shade500,
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            tabs: [
              for (var tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: 20,
              padding: const EdgeInsets.all(Sizes.size6),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: Sizes.size10,
                mainAxisSpacing: Sizes.size10,
                childAspectRatio: 9 / 21,
              ),
              itemBuilder: (context, index) => Column(
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
                        image:
                            "https://steamuserimages-a.akamaihd.net/ugc/1644340994747007967/853B20CD7694F5CF40E83AAC670572A3FE1E3D35/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
                      ),
                    ),
                  ),
                  Gaps.v10,
                  const Text(
                    "This is a very long caption for my tiktok that i upload just now currently. ",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Sizes.size16 + Sizes.size2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.v5,
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                              "https://steamuserimages-a.akamaihd.net/ugc/1644340994747007967/853B20CD7694F5CF40E83AAC670572A3FE1E3D35/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false"),
                        ),
                        Gaps.h4,
                        const Expanded(
                          child: Text(
                            "very_very_strawberry_long_id_jin",
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
                        const Text("2.5M"),
                      ],
                    ),
                  )
                ],
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
        ),
      ),
    );
  }
}

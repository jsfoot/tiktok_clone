import 'package:flutter/material.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';

class PersistentIconBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Gaps.v10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(Sizes.size4),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.size6,
                  horizontal: Sizes.size8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.video_collection_outlined),
                    Gaps.h4,
                    Text(
                      "Share post",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Gaps.h4,
                    Text("\u{1F9D0}"),
                  ],
                ),
              ),
              Gaps.h10,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(Sizes.size4),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.size6,
                  horizontal: Sizes.size8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.video_collection_outlined),
                    Gaps.h4,
                    Text(
                      "World Cup Highlights",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Gaps.h4,
                    Text("\u{1F3C6}"),
                  ],
                ),
              ),
              Gaps.h10,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(Sizes.size4),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.size6,
                  horizontal: Sizes.size8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.video_collection_outlined),
                    Gaps.h4,
                    Text(
                      "Unseen videos",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Gaps.h4,
                    Text("\u{1F195}"),
                  ],
                ),
              ),
            ],
          ),
          Gaps.v10,
        ],
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

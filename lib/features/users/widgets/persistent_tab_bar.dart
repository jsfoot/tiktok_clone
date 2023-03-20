import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';

import '../../../constants/sizes.dart';

class PersistentTabBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.md,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.symmetric(
              horizontal: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
          ),
          child: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            labelPadding: EdgeInsets.symmetric(
              vertical: Sizes.size10,
            ),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.size20,
                ),
                child: Icon(Icons.grid_4x4_rounded),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.size20,
                ),
                child: FaIcon(FontAwesomeIcons.heart),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

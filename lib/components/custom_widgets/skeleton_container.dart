import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const SkeletonContainer._({
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    Key? key,
  }) : super(key: key);

  const SkeletonContainer.square({
    required double width,
    required double height,
  }) : this._(width: width, height: height);

  const SkeletonContainer.rounded({
    required double width,
    required double height,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) : this._(width: width, height: height, borderRadius: borderRadius);

  const SkeletonContainer.circular({
    required double width,
    required double height,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(80)),
  }) : this._(width: width, height: height, borderRadius: borderRadius);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return SkeletonAnimation(
      gradientColor: themeData.colorScheme.onBackground.withOpacity(0.03),
      shimmerColor: themeData.cardColor.withOpacity(0.03),
      // curve: Curves.decelerate,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: themeData.backgroundColor,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

Widget listViewWithLeadingPictureWithExpandedSkeleton(BuildContext context) {
  return Container(
    child: Expanded(
      child: listViewWithLeadingPictureWithoutExpandedSkeleton(context),
    ),
  );
}

Widget listViewWithoutLeadingPictureWithExpandedSkeleton(BuildContext context) {
  return Container(
    child: Expanded(
        child: listViewWithoutLeadingPictureWithoutExpandedSkeleton(context)),
  );
}

Widget listViewWithLeadingPictureWithoutExpandedSkeleton(BuildContext context) {
  MySize().init(context);

  return ListView.builder(
    itemBuilder: (context, index) {
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: MySize.size4,
          horizontal: MySize.size10,
        ),
        child: Card(
          child: ListTile(
            leading: SkeletonContainer.square(
              height: MySize.size100,
              width: MySize.size100,
            ),
            title: SkeletonContainer.rounded(
              height: MySize.size20,
              width: MySize.size1 * 300,
            ),
            subtitle: Container(
              padding: EdgeInsets.only(top: MySize.size6),
              child: SkeletonContainer.rounded(
                height: MySize.size16,
                width: MySize.size1 * 200,
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget listViewWithoutLeadingPictureWithoutExpandedSkeleton(
    BuildContext context) {
  MySize().init(context);

  return ListView.builder(
    itemBuilder: (context, index) {
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: MySize.size4,
          horizontal: MySize.size10,
        ),
        child: Card(
          child: ListTile(
            title: SkeletonContainer.rounded(
              height: MySize.size20,
              width: MySize.size1 * 400,
            ),
            subtitle: Container(
              padding: EdgeInsets.only(top: MySize.size6),
              child: SkeletonContainer.rounded(
                height: MySize.size16,
                width: MySize.size1 * 300,
              ),
            ),
          ),
        ),
      );
    },
  );
}

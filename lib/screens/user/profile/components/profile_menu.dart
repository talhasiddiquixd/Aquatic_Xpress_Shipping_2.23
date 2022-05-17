import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    @required this.text,
    @required this.icon,
    this.press,
  }) : super(key: key);

  final String? text;
  final Widget? icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    MySize().init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MySize.size12,
        vertical: MySize.size4,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onTap: press,
        tileColor: themeData.cardColor,
        title: Text(
          text!,
          style: AppTheme.getTextStyle(
            themeData.textTheme.subtitle1,
            fontWeight: 500,
          ),
        ),
        leading: icon,
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: themeData.colorScheme.onBackground,
        ),
      ),
    );

    // Padding(
    //   padding: EdgeInsets.symmetric(
    //     horizontal: MySize.size12,
    //     vertical: MySize.size4,
    //   ),
    //   child: InkWell(
    //     child: Container(
    //         child: Row(
    //       children: [
    //         icon!,
    //         SizedBox(width: MySize.size20),
    //         Expanded(child: Text(text!)),
    //         Icon(Icons.arrow_forward_ios),
    //       ],
    //     )

    //         // FlatButton(
    //         //   padding: EdgeInsets.all(MySize.size16),
    //         //   shape: RoundedRectangleBorder(
    //         //       borderRadius: BorderRadius.circular(MySize.size16)),
    //         //   color: Color(0xFFF5F6F9),
    //         //   onPressed: press,
    //         //   child: Row(
    //         //     children: [
    //         //       SvgPicture.asset(
    //         //         icon!,
    //         //         color: kPrimaryColor,
    //         //         width: MySize.size22,
    //         //       ),
    //         //       SizedBox(width: MySize.size20),
    //         //       Expanded(child: Text(text!)),
    //         //       Icon(Icons.arrow_forward_ios),
    //         //     ],
    //         //   ),
    //         // ),

    //         ),
    //   ),
    // );
  }
}

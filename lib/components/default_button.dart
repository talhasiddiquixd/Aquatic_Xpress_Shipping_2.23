import 'package:flutter/material.dart';
import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  final text;
  final press;

  const DefaultButton({Key? key, this.text, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      width: MySize.safeWidth,
      height: MySize.size50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(MySize.size8)),
        boxShadow: [
          BoxShadow(
            color: themeData.colorScheme.primary.withAlpha(28),
            blurRadius: MySize.size4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          text!,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: themeData.colorScheme.onPrimary,
          ),
        ),
      ),
    );

    // return SizedBox(
    //   width: double.infinity,
    //   height: getProportionateScreenHeight(56),
    //   child: FlatButton(
    //     shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(MySize.size20)),
    //     color: kPrimaryColor,
    //     onPressed: () {},
    //     child: Text(
    //       text!,
    //       style: TextStyle(
    //         fontSize: getProportionateScreenWidth(18),
    //         color: Colors.white,
    //       ),
    //     ),
    //   ),
    // );
  }
}

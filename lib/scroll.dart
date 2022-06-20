import 'package:flutter/material.dart';

class Scroll extends StatefulWidget {
  Scroll({Key? key}) : super(key: key);

  @override
  _ScrollState createState() => _ScrollState();
}

class _ScrollState extends State<Scroll> {
  ScrollController controller= ScrollController();
 List<Color> colors = [
   Colors.blueGrey,
   Colors.green,
   Colors.deepOrange,
   Colors.purple
 ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        ListView.custom(
          controller: controller,
                    childrenDelegate: SliverChildBuilderDelegate((buildContext, index) {
            return Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              color: colors[index],
            );
          },
          childCount: 4,
        ),
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        scrollDirection: Axis.vertical,
      )

      ],),

    );
  }
}
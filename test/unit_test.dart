import 'package:aquatic_xpress_shipping/screens/user/home/components/body.dart';
import 'package:test/test.dart';

void main() {
  group('Testing App Provider', () {
    Body dashboard = Body();

    test('A new item should be added', () async {
      var res = dashboard.createState().avgCostHardCode();
      var result = await dashboard.createState().avgCost();
      print(result.toString());
      // print(res);
      // expect(res['todayCount'], 0);
      expect(res['yearCount'], 42);
      expect(res['yearAverage'], 48.27);
      expect(result, 7);
    });
  });
}

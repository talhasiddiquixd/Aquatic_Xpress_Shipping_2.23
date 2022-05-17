import 'dart:convert';

import 'package:aquatic_xpress_shipping/screens/user/home/components/news_Api.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  test('returns an Album if the http call completes successfully', () async {
    // final client = MockClient();
    final newApi = NewsApi();
    newApi.client = MockClient((request) async {
      final mapJson = {
        "todayCount": 0,
        "weekCount": 7,
        "monthCount": 0,
        "yearCount": 99,
        "todaySum": 0,
        "weekSum": 499.95,
        "monthSum": 0,
        "yearSum": 4900.300000000003,
        "todayAverage": 0,
        "weekAverage": 71.42,
        "monthAverage": 0,
        "yearAverage": 49.5
      };
      print(mapJson);
      return Response(json.encode(mapJson), 200);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("token",
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjMyZTJmYTZmLTdlNTEtNGQ4ZC1iNTQ3LTA3YzE5ZGRmYWZiOCIsInJvbGUiOiJVc2VyIiwibmJmIjoxNjM1NzUwMTI3LCJleHAiOjE2MzYzNTQ5MjcsImlhdCI6MTYzNTc1MDEyN30.MvLCoKoS_opJ4TQbzYPQTSjan4rh4WVUdb1Ia2IBtSY");

    final item = await newApi.fetchAlbum();
    expect(item, {
      "todayCount": 0,
      "weekCount": 7,
      "monthCount": 0,
      "yearCount": 99,
      "todaySum": 0,
      "weekSum": 499.95,
      "monthSum": 0,
      "yearSum": 4900.300000000003,
      "todayAverage": 0,
      "weekAverage": 71.42,
      "monthAverage": 0,
      "yearAverage": 49.5
    });
  });
}
   

//     // Use Mockito to return a successful response when it calls the
//     // provided http.Client.
//     when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
//         .thenAnswer((_) async =>
//             http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

//     expect(await newApi, int i.fetchAlbum(), isA<Album>());
//   });

//   // try {
//   //   test("test passed", () async {
//   //     final newApi = NewsApi();
//   //     newApi.client = MockClient((request) async {
//   //       return Response(
//   //           json.encode({"userId": 1, "id": 2, "title": "mock"}), 200);
//   //     });

//   //     expect(await newApi.fetchAlbum(),
//   //         isA<NewsApi.Album>);
//   //   });
//   // } catch (error) {
//   //   print(error);
//   // }
// }

// // @GenerateMocks([http.Client])
// // void main() {
// //   group('fetchAlbum', () {
//   //   test('returns an Album if the http call completes successfully', () async {
//   //     // final client = MockClient();
//   //     // final client = Client();
//   //     final newApi = NewsApi();
//   //     final client = Mock();

//   //     // Use Mockito to return a successful response when it calls the
//   //     // provided http.Client.
//   //     when(http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
//   //         .thenAnswer((_) async =>
//   //             http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

//   //     expect(await newApi.fetchAlbum(client),
//   //         isA<Album>);
//   //   });
//   // });
// //   test('throws an exception if the http call completes with an error', () {
// //     // final client = Client();
// //     final newsApi = NewsApi();
// //     final client = Mock();

// //     // Use Mockito to return an unsuccessful response when it calls the
// //     // provided http.Client.
// //     when(http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
// //         .thenAnswer((_) async => http.Response('Not Found', 404));

// //     expect(newsApi.fetchAlbum(client), throwsException);
// //   });
// // }

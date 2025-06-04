// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:dio/dio.dart';

// Future<void> checkForUpdate() async {
//   PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   String currentVersion = packageInfo.version;

//   Response response = await Dio()
//       .get('https://www.mediafire.com/file/0i6zpea5yjep1bz/update.json/file');
//   String latestVersion = response.data['latest_version'];

//   if (latestVersion != currentVersion) {
//     // Show update prompt
//   }
// }

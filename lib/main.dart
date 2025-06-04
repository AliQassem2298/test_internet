// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/network_service.dart';
import 'package:flutter_application_1/screens/update_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// <script src="https://gist.github.com/AliQassem2298/5df393b869256148d81f82add12fe19d.js"></script>
// https://gist.github.com/AliQassem2298/5df393b869256148d81f82add12fe19d
/*

والآن كيف سوف اقوم ب تجريب ما سبق انه سوف يتحقق من النسخة داخل ملف الجيسون 
هل سوف اقوم برفع ملف جيسون جديد وتطبيق جديد ؟
ام انه كيف سوف اقوم بذلك بالزبط ؟




 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

// https://www.mediafire.com/file/d62fe5r3zvi91n9/Number1.apk/file

// https://www.mediafire.com/file/0i6zpea5yjep1bz/update.json/file

class MyApp extends StatelessWidget {
  const MyApp({super.key});

/*
0.0.0
https://www.mediafire.com/file/xxzlnvvunbfn6dj/update0.0.0.json/file
https://www.mediafire.com/file/lyrz5br1adkbj5j/update.json/file

 */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // if you out Column for examole in the Home Page
      // and the text shows too up (in the icon and battery.)
      // wrap it with safe area.
      // if you don't understand , look at the assets
      // for the flutter_screenutil package
      // h for the height , r for the radios (circle...) , sp for the font size , w for the width
      // if you have padding for (all) use the r because it is like radius
      home: const MyHomePage(title: 'I hate flutter.'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? savedData;
  String? sharedData;

  // 1. استبدلنا هذا:
  // final NetworkStatus _networkStatus = NetworkStatus.online;
  // ConnectivityResult? _connectionType;
  // بأشياء نملؤها ديناميكيًّا:
  NetworkStatus _networkStatus = NetworkStatus.offline;
  ConnectivityResult _connectionType = ConnectivityResult.none;

  // 2. أنشأنا مثيل من خدمة NetworkService
  late final NetworkService _networkService;

  String? apkUrl;
// asd
  Future<void> _checkForUpdate() async {
    try {
      final resp = await Dio().get(
          'https://raw.githubusercontent.com/AliQassem2298/test_internet/refs/heads/master/docs/update.json');
      final body =
          resp.data is String ? resp.data as String : jsonEncode(resp.data);
      final json = jsonDecode(body) as Map<String, dynamic>;
      setState(() {
        apkUrl = json['apk_url'] as String;
      });
    } catch (e) {
      debugPrint('Update check failed: $e');
    }
  }

  @override
  void initState() {
    super.initState();

// 3. تهيئة خدمة المراقبة
    _networkService = NetworkService();

    // 4. تسمع للتغيّرات:
    _networkService.networkStatusController.stream.listen((status) async {
      // عند كل تغيير في الحالة:
      final connType = await _networkService.getConnectionType();
      setState(() {
        _networkStatus = status;
        _connectionType = connType;
      });
    });

    // 5. أيضاً يمكنك تنفيذ التحقق مجدّدًا عند البداية:
    _checkForUpdate();

    // ملاحظة: لا حاجة لـ Timer هنا لأن الخدمة نفسها ترسل أي تحديث جديد.
  }

  Future<void> userSecure() async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    await storage.write(key: "name", value: "Ali Is your uncle");
    final data = await storage.read(key: "name");
    setState(() {
      savedData = data;
    });
  }

  Future<void> userShared() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("SharedName", "SharedName1234");
    final data = prefs.getString("SharedName");
    setState(() {
      sharedData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 6. بناء عرض الحالة بناءً على القيمة المُحدَّثة:
    Color statusColor =
        _networkStatus == NetworkStatus.online ? Colors.green : Colors.red;

    String connectionTypeText = _connectionType == ConnectivityResult.mobile
        ? "Mobile Data"
        : _connectionType == ConnectivityResult.wifi
            ? "Wi-Fi"
            : "No Connection";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _networkStatus == NetworkStatus.online
                    ? 'Connected ($connectionTypeText)'
                    : 'No Internet!',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(_counter.toString()),
            TextButton(
              onPressed: () async => await userShared(),
              child: const Text("Activate Shared"),
            ),
            TextButton(
              onPressed: () async => await userSecure(),
              child: const Text("Activate Secure"),
            ),
            Text('Flutter Secure: $savedData'),
            Text('Shared Prefs: $sharedData'),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UpdateScreen(),
                  ),
                );
              },
              child: const Text("التحقق من وجود تحديث"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _counter++),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class DownloadService {
//   static final DownloadService _instance = DownloadService._internal();
//   factory DownloadService() => _instance;
//   DownloadService._internal();

//   final Dio _dio = Dio();
//   CancelToken? _cancelToken;
//   bool isPaused = false;
//   String? _currentUrl;
//   String? _savePath;

//   Future<void> downloadApk(String url,
//       {required void Function(int, int) onProgress}) async {
//     final dir = await getExternalStorageDirectory();
//     _savePath = '${dir!.path}/update.apk';
//     _cancelToken = CancelToken();
//     _currentUrl = url;

//     try {
//       await _dio.download(
//         url,
//         _savePath!,
//         cancelToken: _cancelToken,
//         onReceiveProgress: onProgress,
//       );
//     } catch (e) {
//       if (e is DioException && CancelToken.isCancel(e)) {
//         debugPrint("Download paused or cancelled");
//       } else {
//         rethrow;
//       }
//     }
//   }

//   void pause() {
//     _cancelToken?.cancel();
//     isPaused = true;
//   }

//   Future<void> resume(void Function(int, int) onProgress) async {
//     if (_currentUrl == null || _savePath == null) return;
//     isPaused = false;

//     final file = File(_savePath!);
//     final fileLength = await file.length();

//     _cancelToken = CancelToken();

//     await _dio.download(
//       _currentUrl!,
//       _savePath!,
//       onReceiveProgress: onProgress,
//       cancelToken: _cancelToken,
//       options: Options(
//         headers: {"range": "bytes=$fileLength-"},
//       ),
//     );
//   }

//   void cancel() {
//     _cancelToken?.cancel("Cancelled");
//     isPaused = false;
//   }
// }

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  final Dio _dio = Dio();
  CancelToken? _cancelToken;
  bool isPaused = false;
  String? _currentUrl;
  String? _savePath;

  Future<void> downloadApk(String url,
      {required void Function(int, int) onProgress}) async {
    final dir = await getExternalStorageDirectory();
    _savePath = '${dir!.path}/update.apk';
    _cancelToken = CancelToken();
    _currentUrl = url;

    try {
      await _dio.download(
        url,
        _savePath!,
        cancelToken: _cancelToken,
        onReceiveProgress: onProgress,
      );
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        debugPrint("Download paused or cancelled");
      } else {
        rethrow;
      }
    }
  }

  void pause() {
    _cancelToken?.cancel();
    isPaused = true;
  }

  Future<void> resume(void Function(int, int) onProgress) async {
    if (_currentUrl == null || _savePath == null) return;
    isPaused = false;

    final file = File(_savePath!);
    final fileLength = await file.length();

    _cancelToken = CancelToken();

    await _dio.download(
      _currentUrl!,
      _savePath!,
      onReceiveProgress: onProgress,
      cancelToken: _cancelToken,
      options: Options(
        headers: {"range": "bytes=$fileLength-"},
      ),
    );
  }

  void cancel() {
    _cancelToken?.cancel("Cancelled");
    isPaused = false;
  }
}

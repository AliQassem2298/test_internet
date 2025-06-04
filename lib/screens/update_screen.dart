import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../services/download_service.dart';
import 'dart:convert';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({
    super.key,
  });
  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final DownloadService _downloader = DownloadService();
  bool _checking = true, _available = false, _downloading = false;
  String _apkUrl = '', _latest = '';
  double? _progress;

  @override
  void initState() {
    super.initState();
    _checkUpdate();
  }

  Future<void> _checkUpdate() async {
    try {
      final resp = await Dio().get(
          'https://raw.githubusercontent.com/AliQassem2298/test_internet/refs/heads/master/docs/update.json');

      // إذا أرجعنا String، حوله إلى Map عبر jsonDecode:
      final Map<String, dynamic> jsonData =
          resp.data is String ? jsonDecode(resp.data) : resp.data;

      debugPrint('Update Screen JSON: $jsonData');

      _latest = jsonData['latest_version'] as String? ?? '';
      _apkUrl = jsonData['apk_url'] as String? ?? '';

      final info = await PackageInfo.fromPlatform();
      debugPrint('Current version: ${info.version}');
      debugPrint('Latest version on server: $_latest');

      if (_latest != info.version) {
        _available = true;
      }
    } catch (e) {
      debugPrint('Error in UpdateScreen._checkUpdate: $e');
    } finally {
      setState(() => _checking = false);
    }
  }

  Future<void> _startDownload() async {
    setState(() {
      _downloading = true;
      _progress = null; // ← اقمِد null كبداية
    });

    await _downloader.downloadApk(
      _apkUrl,
      onProgress: (received, total) {
        setState(() {
          if (total > 0) {
            _progress = received / total;
          } else {
            _progress = null;
          }
        });
      },
    );

    // بعد انتهاء التنزيل، فتح ملف الـ APK للتثبيت
    final dir = await getExternalStorageDirectory();
    final path = '${dir!.path}/update.apk';
    await OpenFilex.open(path);
  }

  @override
  Widget build(BuildContext c) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_available) {
      return Scaffold(
          appBar: AppBar(title: const Text('لا تحديث')),
          body: const Center(child: Text('أحدث إصدار')));
    }
    return Scaffold(
      appBar: AppBar(title: Text('تحديث $_latest')),
      body: Center(
        child: _downloading
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _progress != null
                      ? LinearProgressIndicator(value: _progress)
                      : const CircularProgressIndicator(),
                  if (_progress != null) ...[
                    const SizedBox(height: 8),
                    Text('${(_progress! * 100).toStringAsFixed(0)} %'),
                  ],
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _downloader.pause,
                    child: const Text('إيقاف'),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: _startDownload,
                child: const Text('تحميل وتثبيت'),
              ),
      ),
    );
  }
}

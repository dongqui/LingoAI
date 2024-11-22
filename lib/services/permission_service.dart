import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<bool> checkAndRequestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final androidInfo = await _deviceInfo.androidInfo;
    // Android 13 이상
    if (androidInfo.version.sdkInt >= 33) {
      final photos = await Permission.photos.request();
      return photos.isGranted;
    }
    // Android 13 미만
    else {
      final storage = await Permission.storage.request();
      return storage.isGranted;
    }
  }
}

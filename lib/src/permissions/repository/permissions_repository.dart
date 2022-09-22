import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

enum MicPermissionStatus { none, granted, denied, permanentDenied }

// ignore: one_member_abstracts
abstract class IPermissionsRepository {
  Future<MicPermissionStatus> requestMicPermissions();
}

@LazySingleton(as: IPermissionsRepository)
class PermissionsRepository implements IPermissionsRepository {
  @override
  Future<MicPermissionStatus> requestMicPermissions() async {
    final permissions = await Permission.microphone.status;

    if (permissions == PermissionStatus.denied) {
      final newPermission = await Permission.microphone.request();

      log(newPermission.toString(), name: 'permission');

      if (newPermission.isGranted || newPermission.isLimited) {
        return MicPermissionStatus.granted;
      } else if (newPermission.isDenied) {
        return MicPermissionStatus.denied;
      } else if (newPermission.isPermanentlyDenied) {
        return MicPermissionStatus.permanentDenied;
      }
    }
    return MicPermissionStatus.granted;
  }
}

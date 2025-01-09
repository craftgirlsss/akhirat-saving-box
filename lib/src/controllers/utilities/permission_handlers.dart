import 'package:permission_handler/permission_handler.dart';

/*
 Ternyata benar setelah patah hati terhebat,
 bakal datang seseorang yang cinta banget sama kamu,
 tapi kamunya trust issue
*/

Future permissionsHandler() async {  
  final permissionStatusStorage = await Permission.storage.status;
  if (permissionStatusStorage.isDenied) {
      await Permission.storage.request();
  } else if (permissionStatusStorage.isPermanentlyDenied) {
      await openAppSettings();
  } else {
    print(permissionStatusStorage);
  }

  final permissionLocation = await Permission.location.status;
  if (permissionLocation.isDenied) {
      await Permission.location.request();
  } else if (permissionLocation.isPermanentlyDenied) {
      await openAppSettings();
  } else {
    print(permissionLocation);
  }
  
  final permissionStatusCamera = await Permission.camera.status;
  if (permissionStatusCamera.isDenied) {
      await Permission.camera.request();
  } else if (permissionStatusCamera.isPermanentlyDenied) {
      await openAppSettings();
  } else {
    print(permissionStatusCamera);
  }

  final permissionNotification = await Permission.notification.status;
  if (permissionNotification.isDenied) {
      await Permission.notification.request();
  } else if (permissionNotification.isPermanentlyDenied) {
      await openAppSettings();
  } else {
    print(permissionNotification);
  }
}
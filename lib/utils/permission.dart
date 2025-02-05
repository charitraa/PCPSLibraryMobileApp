// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../data/app_exception.dart';
//
// class PermissionUtils {
//   static Future<LocationPermission> requestLocationPermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied. Please enable them in settings.');
//     }
//     return permission;
//   }
//
//   static Future<bool> requestStoragePermission() async {
//     PermissionStatus status = await Permission.storage.status;
//     if (!status.isGranted) {
//       status = await Permission.storage.request();
//     }
//     if (status.isDenied || status.isPermanentlyDenied) {
//       throw StorageException('Storage permission is denied or permanently denied. Please enable it in settings.');
//     }
//     return status.isGranted;
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  var wasSelfieAsFirst = false.obs;
  var isLoading = false.obs;
  var myLocation = "".obs;
  var myLocationV2 = "".obs;
  var myProvinsi = "".obs;
  var donaturLocation = "".obs;
  var myLatitude = RxDouble(0);
  var myLongitude = RxDouble(0);
  var distanceBetweenMeAndOffice = 0.obs;
  RxDouble latMe = 0.0.obs; // untuk mendapatkan lokasi tim distribusi untuk pengisian data alamat donatur yang belum ada
  RxDouble longMe = 0.0.obs; // untuk mendapatkan lokasi tim distribusi untuk pengisian data alamat donatur yang belum ada
  RxString addressMe = "".obs; // untuk mendapatkan lokasi tim distribusi untuk pengisian data alamat donatur yang belum ada
  var currentOfficeLatitude = RxDouble(-7.4396182);
  var currentOfficeLongitude = RxDouble(112.7184);
  Position? positioned;
  final Set<Marker> marked = {};

  @override
  onInit(){
    super.onInit();
    isLoading(true);
    getCurrentLocation().then((result){
      isLoading(false);
    });
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromLangitudeAndLongitude(Position param) async {
    try {
      List<Placemark> placemarkList = await placemarkFromCoordinates(
        param.latitude,
        param.longitude,
      );
      if(placemarkList.isNotEmpty){
        Placemark place = placemarkList[0];
        myLocationV2.value = "${place.subLocality}, ${place.locality}";
        myProvinsi.value =  place.administrativeArea ?? 'Jawa Timur';
        return myLocation.value = "${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      }
      return myLocation.value = "failed_get_location".tr;
    } catch (e) {
      if(kDebugMode) print(e.toString());
      return myLocation.value = "failed_get_location".tr;
    }
  }

  Future<String> getAddressFromLangitudeAndLongitudeForDonatur({double? latitude, double? longitude}) async {
    try {
      List<Placemark> placemarkList = await placemarkFromCoordinates(
        latitude ?? 0,
        longitude ?? 0,
      );
      if(placemarkList.isNotEmpty){
        Placemark place = placemarkList[0];
        return donaturLocation.value = "${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      }
      return donaturLocation.value = "failed_get_location".tr;
    } catch (e) {
      if(kDebugMode) print(e.toString());
      return donaturLocation.value = "failed_get_location".tr;
    }
  }

  Future<String> getAddressFromCoordinates({double? latitude, double? longitude}) async {
    try {
      List<Placemark> placemarkList = await placemarkFromCoordinates(
        latitude ?? 0,
        longitude ?? 0,
      );
      if(placemarkList.isNotEmpty){
        Placemark place = placemarkList[0];
        return "${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      }
      return "Gagal mendapatkan lokasi";
    } catch (e) {
      if(kDebugMode) print(e.toString());
      return "$e";
    }
  }

  Future<void> getCurrentLocation() async {
    isLoading(true);
    Position position = await determinePosition();
    String address = await getAddressFromLangitudeAndLongitude(position);
    positioned = position;
    myLatitude.value = position.latitude;
    myLongitude.value = position.longitude;
    myLocation.value = address;
    isLoading(false);
  }

  Future<void> getLatLongMe() async {
    isLoading(true);
    Position position = await determinePosition();
    String address = await getAddressFromLangitudeAndLongitude(position);
    latMe(position.latitude);
    longMe(position.longitude);
    addressMe(address);
    isLoading(false);
  }
}
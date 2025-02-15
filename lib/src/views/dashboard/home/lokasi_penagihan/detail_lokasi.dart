import 'dart:convert';
import 'dart:io';
import 'package:asb_app/src/components/alert/alert_success.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/controllers/utilities/cupertino_dialogs.dart';
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:asb_app/src/controllers/wilayah/wilayah_controller.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/perhitungan_perolehan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class DetailLokasi extends StatefulWidget {
  final String? name;
  final String? code;
  final String? kodeASB;
  final String? jadwaID;
  final String? subtitle;
  final String? status;
  final double? latitude;
  final double? longitude;
  const DetailLokasi({super.key, this.name, this.subtitle, this.latitude, this.longitude, this.code, this.jadwaID, this.status, this.kodeASB});

  @override
  State<DetailLokasi> createState() => _DetailLokasiState();
}

class _DetailLokasiState extends State<DetailLokasi> with TickerProviderStateMixin {
  RxInt indexSelected = RxInt(-1); // number from Index of array Rute
  RxString indexRuteID = RxString(""); // Rute ID
  RxString indexRuteName = RxString(""); // Rute Name
  LocationController locationController = Get.find();
  TrackingController trackingController = Get.find();
  WilayahController wilayahController = Get.find();
  late final _animatedMapController = AnimatedMapController(vsync: this);
  AuthController authController = Get.find();
  MapController mapController = MapController();
  TextEditingController catatanKhusus = TextEditingController();
  RxList<String> imageProofList = <String>[].obs;
  List<LatLng> routePoints = [];
  double? v1;
  double? v2;
  double? v3;
  double? v4;
  RxBool showTrackRoutes = false.obs;
  var result = "".obs;
  RxString setNameLocationFromLatLong = "".obs;

  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  TextEditingController keteranganEdit = TextEditingController();

  Future getDestinationLocation() async {
    locationController.isLoading(true);
    v3 = widget.latitude; //Target lokasi latitude
    v4 = widget.longitude; //Target lokasi longitude

    v1 = locationController.myLatitude.value;
    v2 = locationController.myLongitude.value;

    var url = Uri.parse('http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
    var response = await http.get(url);
    if(kDebugMode) {
      // print(response.body);
      result.value = response.body;
    }
    setState(() {
      routePoints = [];
      var route = jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
      for(int i=0; i< route.length; i++){
        var replaced = route[i].toString();
        replaced = replaced.replaceAll("[","");
        replaced = replaced.replaceAll("]","");
        var lat1 = replaced.split(',');
        var long1 = replaced.split(",");
        routePoints.add(LatLng( double.parse(lat1[1]), double.parse(long1[0])));
      }
      // if(kDebugMode) print(routePoints);
    });
    locationController.isLoading(false);
  }
  
  RxString status = "".obs;

  String setStatus(){
    status.value = widget.status ?? '0';
    return status.value;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      setStatus();
      locationController.getAddressFromLangitudeAndLongitudeForDonatur(latitude: widget.latitude, longitude: widget.longitude);
    });
  }

  @override
  void dispose() {
    catatanKhusus.dispose();
    latitude.dispose();
    longitude.dispose();
    keteranganEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: widget.status == "5" ? Colors.yellow.shade200 : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Iconsax.arrow_left_2_bold, size: 30,)
        ),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: (){
              _showAlertDialogEditLatLongKosong(context, isEdit: false, name: widget.name);
            },
            child: const Icon(CupertinoIcons.plus, color: GlobalVariable.secondaryColor)
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: (){
              showAlertDialog(context, title: "Informasi", content: """
1. Tombol Batal Ambil terdapat 3 menu, diantaranya Setengah Perjalanan, Tercapai, dan Tidak Tercapai.
2. Konfirmasi Pengambilan yaitu jika anda sudah sampai pada tempat donatur dan mengambil, anda harus mengonfirmasi pengambilan dengan menekan tombol "Konfirmasi Pengambilan"
""", onOK: (){Navigator.pop(context);});
            },
            child: const Icon(CupertinoIcons.info, color: GlobalVariable.secondaryColor), 
          )
        ],
        backgroundColor: widget.status == "5" ? Colors.yellow.shade200 : Colors.white,
        title: Column(
          children: [
            Text(widget.name ?? "Tidak ada Nama", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(widget.kodeASB ?? "Tidak ada Kode", style: const TextStyle(fontSize: 13, color: Colors.black45)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.transparent,
              width: size.width,
              height: size.height / 1.6,
              child: AnimatedOpacity(
                opacity: 1, 
                duration: const Duration(milliseconds: 500),
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _animatedMapController.mapController,
                      options: MapOptions(
                        initialCenter: LatLng(widget.latitude ?? locationController.myLatitude.value, widget.longitude ?? locationController.myLongitude.value), //?? LatLng(widget.latitude, widget.longitude),
                        initialZoom: 12
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                          maxNativeZoom: 19,
                          retinaMode: true,
                        ),
                        Obx(() => showTrackRoutes.value ? PolylineLayer(
                            polylines: [
                              Polyline(
                                points: routePoints, color: Colors.blue, strokeWidth: 4, borderColor: Colors.blue.shade800, borderStrokeWidth: 3)
                            ],
                          ) : const SizedBox(),
                        ),
                        Obx(() => locationController.isLoading.value 
                          ? Container() 
                          : trackingController.isLoading.value ? Container() :
                          MarkerLayer(
                            markers: [
                              Marker(
                                rotate: true,
                                point: LatLng(widget.latitude ?? 0, widget.longitude ?? 0),
                                child: const Icon(Icons.place_rounded, color: Colors.red)
                              ),
                              Marker(
                                rotate: true,
                                point: LatLng(locationController.myLatitude.value, locationController.myLongitude.value),
                                child: Image.asset('assets/images/me.png')
                              ),
                            ]
                          ),
                        )
                      ]
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Obx(() => locationController.isLoading.value 
                      ? const SizedBox() 
                      : Column(
                        children: [
                          IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: GlobalVariable.secondaryColor
                            ),
                            color: Colors.white,
                            onPressed: trackingController.isLoading.value ? null : () async {
                              if(showTrackRoutes.value == false){
                                await getDestinationLocation();
                              }
                              showTrackRoutes.value = !showTrackRoutes.value;
                            },
                            icon: const Icon(Icons.alt_route_sharp), 
                          ),
                          Obx(() => Text(showTrackRoutes.value ? "Hide Route" : "Show Route", style: const TextStyle(color: Colors.white, fontSize: 12, shadows: [Shadow(
                              color: Colors.black,
                              blurRadius: 3,
                              offset: Offset(1, 1),
                            ),])),
                          )
                        ],
                      ),
                      )
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Column(
                        children: [
                          IconButton.filled(
                            enableFeedback: true,
                            tooltip: 'Recenter',
                            style: IconButton.styleFrom(
                              fixedSize: const Size(52, 52),
                              elevation: 10,
                              backgroundColor: GlobalVariable.secondaryColor
                            ),
                            color: Colors.white,
                            onPressed: () async {
                              await locationController.getCurrentLocation();
                              _animatedMapController.animatedZoomOut(cancelPreviousAnimations: true, curve: Curves.easeInOut, duration: const Duration(seconds: 1));
                            },
                            icon: const Icon(Icons.gps_fixed), 
                          ),
                          const Text("Recenter", style: TextStyle(color: Colors.white, shadows: [Shadow(
                            color: Colors.black,
                            blurRadius: 3,
                            offset: Offset(1, 1),
                          ),]))
                        ],
                      )
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      left: 0,
                      child: Obx(() => locationController.isLoading.value ? Container(
                          width: size.width,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/search.gif', width: 100)
                            ],
                          ),
                        ) : const SizedBox(),
                      )
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.place, color: GlobalVariable.secondaryColor),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero, 
                onPressed: (){
                  _showAlertDialogEditLatLongKosong(context, lokasiID: wilayahController.lokasiDonaturModels.value?.data[0].id, name: widget.name, isEdit: true);
                },
                child: const Text("Edit", style: TextStyle(color: GlobalVariable.secondaryColor, fontWeight: FontWeight.bold)), 
              ),
              title: Text("Lokasi Donatur", style: GoogleFonts.poppins(color: Colors.black54, fontWeight: FontWeight.bold)),
              subtitle: Obx(() => Text(locationController.donaturLocation.value, style: const TextStyle(fontSize: 12, color: Colors.black54))),
            ),
            ListTile(
              leading: const Icon(Icons.my_location_rounded, color: GlobalVariable.secondaryColor),
              title: Text("Lokasi Saya", style: GoogleFonts.poppins(color: Colors.black54, fontWeight: FontWeight.bold)),
              subtitle: Obx(() => Text(locationController.myLocation.value, style: const TextStyle(fontSize: 12, color: Colors.black54))),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Obx(() {
          if(status.value == "1" || status.value == "5"){
            return Row(
              children: [
                Expanded(
                  child: Obx(() => OutlinedButton(
                      onPressed: trackingController.isLoading.value ? null : (){
                        customCupertinoDialogActionSheet(context,
                          child: CupertinoActionSheet(
                            title: const Text('Batalkan Pengambilan'),
                            message: const Text('Pilih jenis batal'),
                            cancelButton: CupertinoActionSheetAction(
                              isDefaultAction: true,
                              isDestructiveAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Batal'),
                            ),
                            actions: <CupertinoActionSheetAction>[
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showAlertDialogBatalkan(context, jadwalID: widget.jadwaID, name: widget.name, status: "7");
                                },
                                child: const Text('Setengah Perjalanan'),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showAlertDialogBatalkan(context, jadwalID: widget.jadwaID, name: widget.name, status: "8");
                                },
                                child: const Text('Tercapai'),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showAlertDialogBatalkan(context, jadwalID: widget.jadwaID, name: widget.name, status: "6");
                                },
                                child: const Text('Tidak Tercapai'),
                              )
                            ],
                          )
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          width: 1.5,
                          color: GlobalVariable.secondaryColor
                        )
                      ),
                      child: const Text("Batal Ambil", style: TextStyle(color: GlobalVariable.secondaryColor))
                    ),
                  )
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){
                      showAlertDialog(
                        context, 
                        content: "Apakah anda yakin ingin mengkonfirmasi pengambilan rute?", 
                        title: "Konfirmasi Selesai", 
                        onOK: (){
                          Navigator.pop(context);
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.8,
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Obx(() => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                        height: size.height /1.2,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.black45),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: imageProofList.isEmpty ? Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              const Icon(Icons.add_a_photo_rounded, size: 50, color: Colors.black45),
                                              const SizedBox(height: 5),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: GlobalVariable.secondaryColor, elevation: 0),
                                                child: Text('Tambahkan Bukti', style: GoogleFonts.poppins(color: Colors.white)),
                                                onPressed: () {
                                                  pickImageFromCamera();
                                                },
                                              ),
                                              const SizedBox(height: 10),
                                              Text("Tambahkan foto sebagai bukti bahwa anda telah selesai melakukan pengambilan donasi", style: GoogleFonts.poppins(color: Colors.black54), textAlign: TextAlign.center)
                                            ],
                                          ),
                                        ) : SizedBox(
                                          width: size.width,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Text("Tambah Bukti Pengambilan", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
                                                  const SizedBox(height: 20),
                                                  SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Obx(() => Row(
                                                        children: List.generate(
                                                          imageProofList.length + 1, 
                                                          (i) {
                                                            if(i != imageProofList.length){
                                                              return Container(
                                                                width: 100,
                                                                height: 100,
                                                                clipBehavior: Clip.hardEdge,
                                                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.transparent,
                                                                  border: Border.all(color: Colors.black45),
                                                                  borderRadius: BorderRadius.circular(5),
                                                                ),
                                                                child: Image.file(File(imageProofList[i]), fit: BoxFit.cover,),
                                                              );
                                                            }
                                                            return CupertinoButton(
                                                              padding: EdgeInsets.zero,
                                                              onPressed: (){
                                                                pickImageFromCamera();
                                                              },
                                                              child: Container(
                                                                width: 100,
                                                                height: 100,
                                                                padding: const EdgeInsets.all(15),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.transparent,
                                                                  border: Border.all(color: Colors.black26),
                                                                  borderRadius: BorderRadius.circular(5)
                                                                ),
                                                                child: const Icon(Icons.add_a_photo, color: Colors.black45),
                                                              ),
                                                            );
                                                          }
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text("Tambah Catatan Khusus (Opsional)", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
                                                  const SizedBox(height: 5),
                                                  TextField(
                                                    maxLines: 5,
                                                    minLines: 5,
                                                    controller: catatanKhusus,
                                                    decoration: InputDecoration(
                                                      hintText: "Masukkan catatan khusus..",
                                                      border: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.black38),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.black38),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.red),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.black38),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Obx(() => CupertinoButton(
                                                color: GlobalVariable.secondaryColor, 
                                                onPressed: trackingController.isLoading.value ? null : () async {
                                                  await locationController.getCurrentLocation().then((result) {
                                                    trackingController.selesaiAmbil(
                                                      jadwalID: widget.jadwaID,
                                                      catatanKhusus: catatanKhusus.text,
                                                      photos: imageProofList,
                                                      lat: locationController.myLatitude.value,
                                                      long: locationController.myLongitude.value,
                                                    ).then((result) {
                                                      if(result){
                                                        imageProofList.value = [];
                                                        catatanKhusus.clear();
                                                        status('3');
                                                        alertSuccess(context, title: "Berhasil", content: "Berhasil uplaod foto bukti pengambilan kotak", onOK: (){
                                                          Navigator.of(context)..pop()..pop();
                                                        });
                                                      }else{
                                                        Get.snackbar("Gagal", trackingController.responseMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
                                                      }
                                                    });
                                                  });
                                                },
                                                child: Obx(() => trackingController.isLoading.value || locationController.isLoading.value ? const CupertinoActivityIndicator() : const Text("Submit")), 
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      elevation: 0
                    ),
                    child: const Text("Konfirmasi Pengambilan", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)
                  ),
                ),
              ],
            );
          }else if(status.value == "3"){
            return ElevatedButton(
              onPressed: (){
                Get.to(() => PerhitunganPerolehan(jadwaID: widget.jadwaID, ruteName: widget.name));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                elevation: 0
              ),
              child: const Text("Hitung Perolehan", style: TextStyle(color: Colors.white))
            );
          }
          return const SizedBox();
          }
        )
      ),
      
    );
  }

  // Edit Lat Long yang kosong
  void _showAlertDialogEditLatLongKosong(BuildContext context, {String? name = "Donatur", String? lokasiID, bool? isEdit}) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Input Lokasi Donatur'),
        content: Column(
          children: [
            Text('${isEdit == true ? "Edit" : "Tambah"} lokasi donatur, mohon untuk isi point Latitude dan Longitude donatur $name'),
            const SizedBox(height: 5),
            CupertinoTextField(
              placeholder: "Latitude",
              placeholderStyle: const TextStyle(fontSize: 12, color: Colors.black26),
              controller: latitude,
            ),
            const SizedBox(height: 5),
            CupertinoTextField(
              placeholder: "Longitude",
              placeholderStyle: const TextStyle(fontSize: 12, color: Colors.black26),
              controller: longitude,
            ),
            const SizedBox(height: 5),
            CupertinoTextField(
              placeholder: "Keterangan",
              placeholderStyle: const TextStyle(fontSize: 12, color: Colors.black26),
              controller: keteranganEdit,
            ),
            const SizedBox(height: 5),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Row(
                children: [
                  Icon(CupertinoIcons.location, size: 20),
                  SizedBox(width: 5),
                  Expanded(child: Text("Dapatkan dari lokasi saya saat ini?", textAlign: TextAlign.start, style: TextStyle(fontSize: 12)))
                ],
              ), 
              onPressed: (){
                locationController.getLatLongMe().then((result){
                  latitude.text = locationController.latMe.value.toString();
                  longitude.text = locationController.longMe.value.toString();
                });
              }
            )
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              latitude.clear();
              longitude.clear();
              keteranganEdit.clear();
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              if(isEdit == true){
                wilayahController.editLokasiDonaturByIdLokasi(
                  keterangan: keteranganEdit.text,
                  lat: latitude.text,
                  long: longitude.text,
                  lokasiID: lokasiID
                ).then((result) {
                  Navigator.pop(context);
                  if(result){
                    latitude.clear();
                    longitude.clear();
                    keteranganEdit.clear();
                    Get.snackbar("Berhasil", wilayahController.responseString.value, backgroundColor: Colors.green, colorText: Colors.white);
                  }else{
                    latitude.clear();
                    longitude.clear();
                    keteranganEdit.clear();
                    Navigator.pop(context);
                    Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: Colors.red, colorText: Colors.white);
                  }
                });
              }else{
                wilayahController.tambahLokasiDonaturByIdLokasi(
                  keterangan: keteranganEdit.text,
                  lat: latitude.text,
                  long: longitude.text,
                  donaturKode: widget.kodeASB
                ).then((result) {
                  Navigator.pop(context);
                  if(result){
                    latitude.clear();
                    longitude.clear();
                    keteranganEdit.clear();
                    Get.snackbar("Berhasil", wilayahController.responseString.value, backgroundColor: Colors.green, colorText: Colors.white);
                  }else{
                    latitude.clear();
                    longitude.clear();
                    keteranganEdit.clear();
                    Navigator.pop(context);
                    Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: Colors.red, colorText: Colors.white);
                  }
                });
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }


  // Batalkan Pengambilan
  void _showAlertDialogBatalkan(BuildContext context, {String? name = "Donatur", String? jadwalID, String? status}) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Cancel Program'),
        content: Column(
          children: [
            Text('Batalkan pengambilan kaleng pada donatur $name'),
            const SizedBox(height: 5),
            CupertinoTextField(
              placeholder: "Keterangan",
              placeholderStyle: const TextStyle(fontSize: 12, color: Colors.black26),
              controller: keteranganEdit,
            ),
            const SizedBox(height: 5),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              locationController.getLatLongMe().then((result){
                wilayahController.cancelLokasiDonaturByIdLokasi(
                  jadwalID: jadwalID,
                  keterangan: keteranganEdit.text,
                  lat: locationController.latMe.value.toString(),
                  long: locationController.longMe.value.toString(),
                  status: status
                ).then((value) {
                  if(value){
                    Get.snackbar("Berhasil", wilayahController.responseString.value, backgroundColor: Colors.green, colorText: Colors.white);
                  }else{
                    Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                  }
                });
              });
              keteranganEdit.clear();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext contex, {String? title, String? content, Function()? onOK}) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? 'Akhiri'),
        content: Text(content ?? 'Apakah anda sudah mendatangi tempat dan menandai telah dihadiri?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tidak'),
          ),
          CupertinoDialogAction(
            textStyle: const TextStyle(color: Colors.green),
            isDefaultAction: true,
            onPressed: onOK,
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }

  CupertinoButton tileImageLocation({String? urlImage, Function()? onPressed}){
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        margin: const EdgeInsets.only(left: 7),
        color: Colors.transparent,
        width: 100,
        height: 100,
        child: urlImage != null ? Image.network(urlImage, fit: BoxFit.cover) : Image.asset('assets/images/background.png', fit: BoxFit.cover),
      ), 
    );
  }

  File? imageCamera;
  String? imagePath;
  pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicked = await picker.pickImage(source: ImageSource.camera, imageQuality: 30);
    if(imagePicked != null){
      setState(() {
        imageCamera = File(imagePicked.path);
        imagePath = imagePicked.path;
        imageProofList.add(imagePath ?? '');
      });
    }else{
      debugPrint("Image kosong");
    }
  }
}

class ImageDialog extends StatelessWidget {
  final String? urlImage;
  const ImageDialog({super.key, this.urlImage});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        width: size.width - 50,
        height: size.width - 50,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: urlImage != null ? NetworkImage(urlImage!) : const AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) => const Icon(CupertinoIcons.photo, size: 30, color: GlobalVariable.secondaryColor),
          )
        ),
      ),
    );
  }
}
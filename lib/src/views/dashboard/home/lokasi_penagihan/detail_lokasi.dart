import 'dart:convert';
import 'dart:io';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class DetailLokasi extends StatefulWidget {
  final String? name;
  final String? code;
  final String? jadwaID;
  final String? subtitle;
  final String? status;
  final double? latitude;
  final double? longitude;
  const DetailLokasi({super.key, this.name, this.subtitle, this.latitude, this.longitude, this.code, this.jadwaID, this.status});

  @override
  State<DetailLokasi> createState() => _DetailLokasiState();
}

class _DetailLokasiState extends State<DetailLokasi> {
  RxInt indexSelected = RxInt(-1); // number from Index of array Rute
  RxString indexRuteID = RxString(""); // Rute ID
  RxString indexRuteName = RxString(""); // Rute Name
  LocationController locationController = Get.find();
  TrackingController trackingController = Get.find();
  AuthController authController = Get.find();
  MapController mapController = MapController();
  RxList imageProofList = [].obs;
  List<LatLng> routePoints = [];
  double? v1;
  double? v2;
  double? v3;
  double? v4;
  RxBool showTrackRoutes = false.obs;
  var result = "".obs;
  RxString setNameLocationFromLatLong = "".obs;

  getDestinationLocation(String destinationName) async {
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
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), (){
      getDestinationLocation(locationController.donaturLocation.value);
      trackingController.checkDetailsOfDonatur(code: widget.code, token: authController.token.value);
      locationController.getAddressFromLangitudeAndLongitudeForDonatur(latitude: widget.latitude, longitude: widget.longitude);
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight]
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // LatLng myPlace = LatLng(locationController.myLatitude.value, locationController.myLongitude.value);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Iconsax.arrow_left_2_bold, size: 30,)
        ),
        backgroundColor: Colors.white,
        title: Text(widget.name ?? "Tidak ada nama", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Obx(() => CupertinoButton(
            onPressed: locationController.isLoading.value ? null : (){
              locationController.getCurrentLocation();
            },
            child: const Icon(Icons.gps_fixed, color: GlobalVariable.secondaryColor), 
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.transparent,
              width: size.width,
              height: size.height / 2,
              child: AnimatedOpacity(
                opacity: locationController.isLoading.value ? 0.0 : 1.0, 
                duration: const Duration(milliseconds: 500),
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: LatLng(widget.latitude ?? locationController.myLatitude.value, widget.longitude ?? locationController.myLongitude.value), //?? LatLng(widget.latitude, widget.longitude),
                    initialZoom: 15
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
                        // markers: trackingController.detailDonaturModels.value == null ? [] :
                        // List.generate(trackingController.detailDonaturModels.value!.data.rute!.length + 1, (index) {
                        //   if(index != trackingController.detailDonaturModels.value?.data.rute?.length){
                        //     return Marker(
                        //       rotate: true,
                        //       alignment: Alignment.center,
                        //       width: 100,
                        //       point: LatLng(double.parse(trackingController.detailDonaturModels.value!.data.rute![index].lat), double.parse(trackingController.detailDonaturModels.value!.data.rute![index].lng)),
                        //       child: Tooltip(
                        //         message: trackingController.detailDonaturModels.value!.data.rute?[index].nama ?? "Tidak ada nama",
                        //         child: Obx(
                        //           () => InkWell(
                        //             onTap: locationController.isLoading.value ? null : (){
                        //               indexSelected.value = index;
                        //               indexRuteID.value = trackingController.detailDonaturModels.value!.data.rute![index].ruteId;
                        //               indexRuteName.value = trackingController.detailDonaturModels.value!.data.rute![index].nama;
                        //               locationController.getAddressFromLangitudeAndLongitudeV2(
                        //                 lat: double.parse(trackingController.detailDonaturModels.value!.data.rute![index].lat),
                        //                 long: double.parse(trackingController.detailDonaturModels.value!.data.rute![index].lng)
                        //               ).then((locationName){
                        //                 setNameLocationFromLatLong.value = locationName;
                        //               });
                        //               // print(trackingController.detailDonaturModels.value!.data!.rute![index].nama ?? "Tidak ada nama");
                        //             },
                        //             child: Column(
                        //               children: [
                        //                 const Icon(Icons.place_rounded, color: Colors.red, size: 15),
                        //                 DecoratedBox(
                        //                   decoration: const BoxDecoration(color: Colors.black),
                        //                   child: Text(trackingController.detailDonaturModels.value!.data.rute?[index].nama ?? "Tidak ada nama", style: const TextStyle(backgroundColor: Colors.black, color: Colors.white, fontSize: 8), textAlign: TextAlign.center),
                        //                 ),
                        //                 // Expanded(child: Text(trackingController.detailDonaturModels.value!.data!.rute![index].nama ?? "Tidak ada nama", style: const TextStyle(backgroundColor: Colors.black, color: Colors.white, fontSize: 8), textAlign: TextAlign.center,))
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   }
                        //   return Marker(
                        //     rotate: true,
                        //     point: LatLng(locationController.myLatitude.value, locationController.myLongitude.value),
                        //     child: const Icon(Icons.place_rounded, color: Colors.blue)
                        //   );
                        // },)
                        
                        markers: [
                          Marker(
                            rotate: true,
                            point: LatLng(widget.latitude!, widget.longitude!),
                            child: const Icon(Icons.place_rounded, color: Colors.red)
                          ),
                          Marker(
                            rotate: true,
                            point: LatLng(locationController.myLatitude.value, locationController.myLongitude.value),
                            child: const Icon(FontAwesome.person_running_solid, color: Colors.black, fill: 0.4, grade: 3)
                          ),
                        ]
                        
                      ),
                    )
                  ]
                ),
              ),
            ),

            Obx(() {
              if(trackingController.detailDonaturModels.value?.data.rute?.length == 0){
                return const SizedBox();
              }

              if(indexSelected.value == -1){
                return tileImageLocation(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => ImageDialog(urlImage: trackingController.detailDonaturModels.value?.data.thumbnail)
                    );
                  }, 
                  urlImage: trackingController.detailDonaturModels.value?.data.thumbnail);
              }else{
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: trackingController.isLoading.value 
                      ? [] 
                      : List.generate(trackingController.detailDonaturModels.value?.data.rute?[indexSelected.value].images.length ?? 0, (i) 
                        => tileImageLocation(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (_) => ImageDialog(urlImage: trackingController.detailDonaturModels.value?.data.rute?[indexSelected.value].images[i])
                            );
                          }, 
                      urlImage: trackingController.detailDonaturModels.value?.data.rute?[indexSelected.value].images[i])),
                    ),
                  ),
                );
              }
              } 
            ),

            // Obx(() {
            //   if(trackingController.detailDonaturModels.value?.data.rute?.length == 0){
            //     return const SizedBox();
            //   }

            //   if(indexSelected.value == -1){
            //     return ListTile(
            //       leading: const Icon(Icons.location_on, color: GlobalVariable.secondaryColor),
            //       title: Text(widget.name ?? "Tidak ada nama", style: GoogleFonts.poppins(color: Colors.black54, fontWeight: FontWeight.bold)),
            //       subtitle: Obx(() => Text(setNameLocationFromLatLong.value != "" ? setNameLocationFromLatLong.value : widget.subtitle!, style: const TextStyle(fontSize: 10, color: Colors.black54))),
            //     );
            //   }
            //   return ListTile(
            //     leading: const Icon(Icons.location_on, color: GlobalVariable.secondaryColor),
            //     title: Text(trackingController.detailDonaturModels.value?.data.rute?[indexSelected.value].nama ?? "Tidak ada nama", style: GoogleFonts.poppins(color: Colors.black54, fontWeight: FontWeight.bold)),
            //     subtitle: Obx(() => Text(setNameLocationFromLatLong.value != "" ? setNameLocationFromLatLong.value : widget.subtitle!, style: const TextStyle(fontSize: 10, color: Colors.black54))),
            //   );
            // } 
            // ),
            ListTile(
              leading: const Icon(Icons.place, color: GlobalVariable.secondaryColor),
              title: Text("Lokasi Donatur", style: GoogleFonts.poppins(color: Colors.black54, fontWeight: FontWeight.bold)),
              subtitle: Obx(() => Text(locationController.donaturLocation.value, style: const TextStyle(fontSize: 10, color: Colors.black54))),
            ),
            ListTile(
              leading: const Icon(Icons.my_location_rounded, color: GlobalVariable.secondaryColor),
              title: Text("Lokasi Saya", style: GoogleFonts.poppins(color: Colors.black54, fontWeight: FontWeight.bold)),
              subtitle: Obx(() => Text(locationController.myLocation.value, style: const TextStyle(fontSize: 10, color: Colors.black54))),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Obx(() {
          if(trackingController.detailDonaturModels.value != null){
            for(int i = 0; i < trackingController.detailDonaturModels.value!.data.rute!.length; i++){
              if(trackingController.detailDonaturModels.value!.data.rute![i].status == "2"){
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          side: const BorderSide(width: 2.0, color: GlobalVariable.secondaryColor),
                        ),
                        onPressed: (){}, 
                        child: const Text("Batalkan Pengambilan", style: TextStyle(color: GlobalVariable.secondaryColor, fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.clip, textAlign: TextAlign.center),
                      )
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GlobalVariable.secondaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                          onPressed: trackingController.isLoading.value ? (){} : (){}, 
                          child: const Text("Selesai", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))
                        ),
                      )
                    ),
                  ],
                );
              }
            }
          }
          return Obx(() => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: indexSelected.value > -1 ? Colors.green : GlobalVariable.secondaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: trackingController.isLoading.value ? (){} : (){
                trackingController.konfirmasiPengambilanRute(
                  jadwaID: widget.jadwaID
                ).then((value){
                  if(value){
                    showTrackRoutes(true);
                    Get.snackbar("Berhasil", "Berhasil mengarahkan ke rute", backgroundColor: Colors.green, colorText: Colors.white);
                  }else{
                    Get.snackbar("Gagal", "Gagal mengarahkan ke rute", backgroundColor: Colors.green, colorText: Colors.white);
                  }
                });
              }, 
              child: Obx(() {
                return const Text("Mulai perjalanan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
                // if(trackingController.isLoading.value){
                //   const SizedBox(
                //     width: 10,
                //     height: 10,
                //     child: CircularProgressIndicator(color: Colors.white)
                //   );
                // }
                // if(indexSelected.value == -1){
                //   return const Text("Mohon Pilih tempat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
                // }else{
                //   return const Text("Ambil Tempat!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
                // }
              })
            ),
          );
        }),
      ),
    );
  }

  showAddressLocation(){
    showModalBottomSheet(
      elevation: 0,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context, builder: (context) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                dense: true,
                title: const Text("Alamat Lengkap"),
                subtitle: Text(locationController.myLocation.value, maxLines: 2),
              )
            ],
          ),
        )
      )
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
    final XFile? imagePicked = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if(imagePicked != null){
      setState(() {
        imageCamera = File(imagePicked.path);
        imagePath = imagePicked.path;
        imageProofList.add(imagePath);
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
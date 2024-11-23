import 'dart:convert';
import 'dart:io';
import 'package:asb_app/src/components/alert/alert_success.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/perhitungan_perolehan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

enum Type {
  masjid,
  rumah
}

class DetailLokasi extends StatefulWidget {
  final String? name;
  final String? subtitle;
  final double? latitude;
  final double? longitude;
  final Type? type;
  const DetailLokasi({super.key, this.name, this.subtitle, this.latitude, this.longitude, this.type});

  @override
  State<DetailLokasi> createState() => _DetailLokasiState();
}

class _DetailLokasiState extends State<DetailLokasi> {
  var done = false.obs;
  var showAnimation = false.obs;
  LocationController locationController = Get.find();
  MapController mapController = MapController();
  RxList imageProofList = [].obs;
  List<LatLng> routePoints = [];
  double? v1;
  double? v2;
  double? v3;
  double? v4;
  var result = "".obs;

  getDestinationLocation(String destinationName) async {
    v3 = -7.443653; //Target lokasi latitude
    v4 = 112.682705; //Target lokasi longitude

    v1 = locationController.myLatitude.value;
    v2 = locationController.myLongitude.value;

    var url = Uri.parse('http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
    var response = await http.get(url);
    if(kDebugMode) {
      // print(response.body);
      result.value = response.body;
    };
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
    getDestinationLocation(locationController.myOfficeLocation.value);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    LatLng myPlace = LatLng(locationController.myLatitude.value, locationController.myLongitude.value);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
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
          )
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
                    initialCenter: myPlace, //?? LatLng(widget.latitude, widget.longitude),
                    initialZoom: 15
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                      maxNativeZoom: 19,
                      retinaMode: true,
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: routePoints, color: Colors.blue, strokeWidth: 4, borderColor: Colors.blue.shade800, borderStrokeWidth: 3)
                      ],
                    ),
                    Obx(() => locationController.isLoading.value 
                      ? Container() 
                      : MarkerLayer(
                        markers: [
                          const Marker(
                            rotate: true,
                            point: LatLng(-7.443653, 112.682705),
                            child: Icon(Icons.place_rounded, color: Colors.red)
                          ),
                          Marker(
                            rotate: true,
                            point: LatLng(locationController.myLatitude.value, locationController.myLongitude.value),
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(color: Colors.black54, blurRadius: 10)
                                ],
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                color: Colors.indigo
                              ),
                            )
                          ),
                        ]
                      ),
                    )
                  ]
                ),
              ),
            ),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(3, (i) => tileImageLocation(onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => const ImageDialog(urlImage: "https://static.promediateknologi.id/crop/0x150:1600x1053/0x0/webp/photo/p2/85/2023/06/26/oke-masjid-agung-salat-id-218673181.jpeg")
                  );
                }, urlImage: "https://static.promediateknologi.id/crop/0x150:1600x1053/0x0/webp/photo/p2/85/2023/06/26/oke-masjid-agung-salat-id-218673181.jpeg")),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.location_on, color: GlobalVariable.secondaryColor),
              title: Text(widget.name ?? "Tidak ada nama", style: GoogleFonts.poppins(color: Colors.black54, fontWeight: FontWeight.bold)),
              subtitle: Text(widget.subtitle ?? "Alamat tidak diketahui", style: const TextStyle(fontSize: 10, color: Colors.black54)),
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
        child: CupertinoButton(
          color: GlobalVariable.secondaryColor,
          onPressed: widget.type == Type.masjid ? (){
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return Obx(() => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        height: size.height / 2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black45),
                          borderRadius: BorderRadius.circular(10),
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
                                ],
                              ),
                              CupertinoButton(color: GlobalVariable.secondaryColor, child: const Text("Submit"), onPressed: (){
                                alertSuccess(context, title: "Berhasil", content: "Berhasil uplaod foto bukti pengambilan kotak", onOK: (){
                                  Navigator.of(context)..pop()..pop();
                                });
                              })
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } : (){
            Get.to(() => const PerhitunganPerolehan());
          },
          child: const Text("Selesai"), 
        ),
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
            fit: BoxFit.cover
          )
        ),
      ),
    );
  }
}
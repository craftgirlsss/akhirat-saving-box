/*
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:asb_app/src/controllers/utilities/timeline_controller.dart';
import 'package:asb_app/src/views/dashboard/home/donatur.dart';
import 'package:asb_app/src/views/dashboard/home/histrory.dart';
import 'package:asb_app/src/views/dashboard/home/invoice_page.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/menu_tim_distribusi.dart';
import 'package:asb_app/src/views/dashboard/profiles/index.dart';
import 'package:asb_app/src/views/dashboard/profiles/notification_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class DashboardTrainer extends StatefulWidget {
  const DashboardTrainer({super.key});

  @override
  State<DashboardTrainer> createState() => _DashboardTrainerState();
}

class _DashboardTrainerState extends State<DashboardTrainer> {
  AuthController authController = Get.find();
  final globalVariable = GlobalVariable();
  final globalTextStyle = GlobalTextStyle();
  bool isErrorOccured = false;
  RxBool wasSelfieAsFirst = false.obs;
  TimelineController controller = Get.put(TimelineController());
  DateTime now = DateTime.now();
  LocationController locationController = Get.put(LocationController());
  TrackingController trackingController = Get.put(TrackingController());

  Color getRandomColor(){
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.85);
  }

  List<Map<String, dynamic>> dataMenu = [
    {
      "details" : {
        "description" : "Informasi Daftar Lokasi dan Tempat pengambilan kotak amal",
        "nama" : "Tim Distribusi",
        "color" : Colors.green,
        "icon" : const Icon(LineAwesome.search_location_solid, size: 40, color: Colors.white),
        "to" : const InvoicePage()
      }
    },
    {
      "details" : {
        "description" : "Informasi Profil anda",
        "nama" : "Profile",
        "color" : Colors.orange,
        "icon" : const Icon(CupertinoIcons.person, size: 40, color: Colors.white),
        "to" : const InvoicePage()
      }
    },
    {
      "details" : {
        "description" : "Seluruh informasi notifikasi mengenai tugas dan informasi terkait akun anda",
        "nama" : "Notifikasi",
        "color" : Colors.blue,
        "icon" : const Icon(Icons.notifications_active, size: 40, color: Colors.white),
        "to" : const InvoicePage()
      }
    },
    {
      "details" : {
        "description" : "Informasi riwayat pengambilan kotak amal yang pernah anda ambil",
        "nama" : "History",
        "color" : Colors.indigo,
        "icon" : const Icon(BoxIcons.bx_history, size: 40, color: Colors.white),
        "to" : const InvoicePage()
      }
    },
    {
      "details" : {
        "description" : "Informasi Berita Umum bagi semua petugas",
        "nama" : "Tambah Donatur",
        "color" : Colors.cyan,
        "icon" : const Icon(Bootstrap.person_fill_add, size: 40, color: Colors.white),
        "to" : null
      }
    },
    {
      "details" : {
        "description" : "Informasi Berita Umum bagi semua petugas",
        "nama" : "Tambah Jadwal",
        "color" : Colors.greenAccent,
        "icon" : const Icon(Iconsax.calendar_add_bold, size: 40, color: Colors.white),
        "to" : null
      }
    },
    {
      "details" : {
        "description" : "Keluar dari akun anda",
        "nama" : "Sign Out",
        "color" : Colors.red,
        "icon" : const Icon(FontAwesome.power_off_solid, size: 40, color: Colors.white),
        "to" : null
      }
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      trackingController.checkingSelfFirst().then((result){
        if(result){
          wasSelfieAsFirst(true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text("Assalamualaikum, ${authController.profileModels.value?.data.name ?? 'user'}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                  Text(DateFormat.MMMMEEEEd().format(now), style: const TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ),
              CircleAvatar(
                // backgroundImage: isErrorOccured ? const AssetImage("assets/images/engine.jpg") : const NetworkImage("https://masputra.nextjiesdev.site/assets/mhs/lion.png"),
                backgroundImage: const AssetImage("assets/images/background.png"),
                onBackgroundImageError: (_, __) {
                  setState(() {
                    isErrorOccured = true;
                  });
                },
                radius: 20,
              ),
            ],
          ),
        ),
        leadingWidth: 0,
      ),
      body: SingleChildScrollView(
        padding: orientation == Orientation.landscape ? EdgeInsets.symmetric(horizontal: size.width / 3) : const EdgeInsets.all(15),
        child: Obx(() => trackingController.isLoading.value ? SizedBox(
          height: size.height / 1.2,
          width: size.width,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.red,),
              SizedBox(height: 10),
              Text("Loading...")
            ],
          ),
        ) : Column(
            children: [
              StaggeredGrid.count(
                crossAxisCount: orientation == Orientation.landscape ? 3 : 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: List.generate(dataMenu.length, (i) {
                  return StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: i.isEven ? 2 : 3,
                    child: CupertinoContextMenu(
                      enableHapticFeedback: true,
                      actions: [
                        Container(
                          alignment: Alignment.center,
                          width: size.width / 2,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white
                          ),
                          child: DefaultTextStyle(
                            style: const TextStyle(color: Colors.black,), textAlign: TextAlign.center, overflow: TextOverflow.clip,
                            child: Text(dataMenu[i]['details']['description'] ?? "Null", 
                          ),)
                        ),
                      ],
                      child: Material(
                        elevation: 0,
                        color: Colors.white,
                        type: MaterialType.card,
                        borderRadius: BorderRadius.circular(20),
                        shadowColor: Colors.white,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: (){
                            if(i == dataMenu.length - 1){
                              _showAlertDialog(context);
                            }else{
                              switch (i) {
                                case 0:
                                  Get.to(() => const MenuTimDistribusi());
                                  break;
                                case 1:
                                  Get.to(() => const AccountSettings());
                                  break;
                                case 2:
                                  Get.to(() => const NotificationPages());
                                  break;
                                case 3:
                                  Get.to(() => const HistoryPage());
                                  break;
                                case 4:
                                  Get.to(() => const DonaturPage());
                                  break;
                                default:
                              }
                            }
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              minWidth: size.width / 2,
                              minHeight: size.width / 2,
                            ),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: dataMenu[i]['details']['color'],
                              border: Border.all(color: Colors.black12, width: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                dataMenu[i]['details']['icon'],
                                const SizedBox(height: 5),
                                Text(dataMenu[i]['details']['nama'], style: globalTextStyle.defaultTextStyleBold(fontSize: orientation == Orientation.landscape ? 14: 17, color: Colors.white, withShadow: false), textAlign: TextAlign.center, maxLines: 3),
                              ],
                            ))
                          ),
                        ),
                      ),
                    ),
                  );
                })
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(authController.token.value),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      // await Clipboard.setData(ClipboardData(text: authController.token.value));
                      Share.share(authController.token.value);
                    },
                    child: const Icon(Icons.share_outlined), 
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Log Out'),
        content: const Text('Apakah anda ingin keluar dari akun anda?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tidak'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }
}

*/
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/cek_keberangkatan.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/daftar_lokasi_tagihan_v2.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/generate_kwitansi_page.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/menu_tim_distribusi.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/tambah_page_donatur.dart';
import 'package:asb_app/src/views/dashboard/profiles/notification_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class TimeDistribusi extends StatefulWidget {
  const TimeDistribusi({super.key});

  @override
  State<TimeDistribusi> createState() => _TimeDistribusiState();
}

class _TimeDistribusiState extends State<TimeDistribusi> {
  AuthController authController = Get.find();
  TrackingController trackingController = Get.put(TrackingController());
  LocationController locationController = Get.put(LocationController());
  RxString appVersion = ''.obs;

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), (){
      getAppVersion().then((version) => appVersion.value = version);
      trackingController.checkingSelfFirst();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return RefreshIndicator(
      onRefresh: () async {
        await locationController.getCurrentLocation();
        await trackingController.checkingSelfFirst();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: const Image(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
          centerTitle: false,
          forceMaterialTransparency: true,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(backgroundImage: AssetImage('assets/images/ic_launcher.png')),
              const SizedBox(width: 7),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Akhirat SavingBox", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Obx(() => Text("Assalamualaikum ${authController.profileModels.value?.data.name ?? 'Akhi'}", style: const TextStyle(fontSize: 14, color: Colors.black45)))
                ],
              ),
            ],
          ),
        ),
      
        body: Stack(
          children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: Image.asset("assets/images/background.jpg", fit: BoxFit.cover)),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 0, top: 20, bottom: 20),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: orientation == Orientation.landscape ? size.width / 2 : size.width,
                    height: orientation == Orientation.landscape ? size.height / 3 : size.width / 2.5,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(96, 81, 196, 1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(1, 2))
                      ],
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(96, 81, 196, 1),
                        Color.fromARGB(255, 65, 55, 133),
                        Color.fromARGB(255, 42, 36, 87),
                      ])
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Obx(() => locationController.isLoading.value ? const Text("Getting Location...", style: TextStyle(color: Colors.white60)) : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Lokasi Anda", style: TextStyle(color: Colors.white60, fontSize: 14)),
                                    Obx(() => Text(locationController.myLocationV2.value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))
                                  ],
                                ),
                                Obx(() => Text(locationController.myProvinsi.value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)))
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            // SizedBox(
                            //   width: size.width / 6,
                            //   child: Image.asset('assets/images/place.png')),
                            Obx(() => CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: locationController.isLoading.value ? null : (){
                                  locationController.getCurrentLocation();
                                },
                                child: Obx(() => locationController.isLoading.value ? const CupertinoActivityIndicator(color: Colors.white70) : const Icon(CupertinoIcons.refresh, size: 18, color: Colors.white70)), 
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: orientation == Orientation.landscape ? MainAxisAlignment.center :MainAxisAlignment.start,
                      children: const [
                        Text("Semua Menu", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),
                      
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: orientation == Orientation.landscape ? EdgeInsets.symmetric(horizontal: size.width / 6) : null,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Obx(() => menuItem(size, onTap: locationController.isLoading.value ? null : () async {
                            if(locationController.myLocationV2.value == ""){
                              final permissionLocation = await Permission.location.status;
                              Get.snackbar("Gagal", "Gagal mendapatkan lokasi anda", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                              if(permissionLocation.isDenied || permissionLocation.isPermanentlyDenied){
                                openAppSettings();
                              }
                            }else{
                              Get.to(() => const MenuTimDistribusi());
                            }
                          }, title: "Tim Distributor", urlImage: 'assets/images/group.png', color: const Color.fromARGB(255, 111, 16, 114), orientation: orientation),
                        ),
                        menuItem(size, onTap: (){}, title: "Donatur", color: const Color.fromARGB(255, 16, 114, 30), urlImage: 'assets/images/team.png', orientation: orientation, isCommingSoon: true),
                        menuItem(size, onTap: (){}, title: "Riwayat", color: const Color.fromARGB(255, 135, 127, 11), urlImage: 'assets/images/history.png', orientation: orientation, isCommingSoon: true),
                        menuItem(size, onTap: (){
                          Get.to(() => const NotificationPages());
                        }, title: "Notifikasi", color: const Color.fromARGB(255, 14, 149, 140), urlImage: 'assets/images/notification.png', orientation: orientation),
                      ]
                    ),
                  ),
                      
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: orientation == Orientation.landscape ? MainAxisAlignment.center : MainAxisAlignment.start,
                      children: const [
                        Text("Pintasan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ),
                      
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: orientation == Orientation.landscape ? size.width / 2 : size.width,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(96, 81, 196, 1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(1, 2))
                      ],
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(81, 196, 146, 1),
                        Color.fromARGB(255, 101, 133, 55),
                        Color.fromARGB(255, 87, 81, 36),
                      ])
                    ),
                    child: Obx(() => trackingController.isLoading.value ? const Center(child: CupertinoActivityIndicator(color: Colors.white)) : Wrap(
                        alignment: WrapAlignment.spaceAround,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Obx(() => itemShortcut(
                            onPressed: locationController.isLoading.value ? null : () async {
                              if(locationController.myLocationV2.value == ""){
                                final permissionLocation = await Permission.location.status;
                                Get.snackbar("Gagal", "Gagal mendapatkan lokasi anda", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                                if(permissionLocation.isDenied || permissionLocation.isPermanentlyDenied){
                                  openAppSettings();
                                }
                              }else{
                                Get.to(() => const TambahDonaturPage());
                              }
                            },
                            name: "Tambah\nDonatur", 
                            urlImage: 'assets/images/plus_blue.png')
                          ),
                          Obx(() => itemShortcut(
                            onPressed: trackingController.wasSelfieAsFirst.value ? (){
                              Get.to(() => const DaftarLokasiTagihanv2());
                            } : (){
                              Get.snackbar("Gagal", "Anda sudah melakukan cek keberangkatan untuk hari ini", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                            }, 
                            name: "H Donatur", 
                            urlImage: 'assets/images/h.png'),
                          ),
                          itemShortcut(
                            onPressed: (){Get.to(() => const DaftarLokasiTagihanv2(isReminder: true));},
                            name: "Reminder", 
                            urlImage: 'assets/images/reminder.png'),
                          Obx(() => itemShortcut(onPressed: trackingController.wasSelfieAsFirst.value ? (){
                              Get.snackbar("Gagal", "Anda sudah melakukan cek keberangkatan untuk hari ini", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                            } : (){
                              Get.to(() => const CekKeberangkatan());
                            }, name: "Mulai\nBerangkat", urlImage: 'assets/images/go.png'),
                          ),
                          Obx(() => itemShortcut(onPressed: trackingController.wasSelfieAsFirst.value ? (){
                              Get.to(() => const CekKeberangkatan(isGoBack: true));
                            } : (){
                              Get.snackbar("Gagal", "Anda sudah melakukan cek keberangkatan untuk hari ini", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                            }, name: "Selesai", urlImage: 'assets/images/done.png'),
                          ),
                          // itemShortcut(onPressed: (){
                          //   Get.to(() => const DaftarDonaturView());
                          // }, name: "Tambah\nJadwal", urlImage: 'assets/images/add_jadwal.png'),
                          itemShortcut(onPressed: (){
                            Get.to(() => const GenerateKwitansiPage());
                          }, name: "Kuitansi", urlImage: 'assets/images/payment.png'),
                        ],
                      ),
                    ),
                  ),
                      
                  const Text("App Version"),
                  Obx(() => Text(appVersion.value)),
                  const SizedBox(height: 100)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CupertinoButton menuItem(Size size, {String? title, Function()? onTap, Color? color, String? urlImage, Orientation? orientation, bool? isCommingSoon}){
    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Container(
            width: orientation == Orientation.landscape ? size.height / 3.8 : size.width / 3,
            height: orientation == Orientation.landscape ? size.height / 3.8 : size.width / 3,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(96, 81, 196, 1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black12),
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(1, 2))
              ],
              gradient:  LinearGradient(colors: [
                color ?? const Color.fromRGBO(96, 81, 196, 1),
                const Color.fromARGB(255, 65, 55, 133),
              ])
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, top: 8),
                          child: Text(title ?? "Menu", style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold), maxLines: 2),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(urlImage ?? 'assets/images/place.png')
                    ],
                  ),
                ),
              ],
            ),
          ),
          isCommingSoon == true || isCommingSoon != null ? 
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              margin: const EdgeInsets.all(10),
              width: orientation == Orientation.landscape ? size.height / 3.8 : size.width / 3,
              height: orientation == Orientation.landscape ? size.height / 3.8 : size.width / 3,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(20)
              ),
              child: const Center(
                child: Text("Comming Soon", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            )
          ) : const SizedBox()
        ],
      ),
    );
  }

  CupertinoButton itemShortcut({Function()? onPressed, String? name, String? urlImage, Orientation? orientation}){
    return CupertinoButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 2))
              ],
              border: Border.all(color: Colors.black12),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white70,
                  Colors.white60,
                  Colors.white54
                ]
              )
            ),
            child: Center(
              child: Image.asset(urlImage ?? 'assets/images/question.png', errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/question.png')),
            )
          ),
          const SizedBox(height: 3),
          Text(name ?? "Name", style: const TextStyle(color: Colors.white70, fontSize: 14), maxLines: 2, textAlign: TextAlign.center)
        ],
      ),
    );
  }
}


class DaftarDonaturView extends StatefulWidget {
  const DaftarDonaturView({super.key});

  @override
  State<DaftarDonaturView> createState() => _DaftarDonaturViewState();
}

class _DaftarDonaturViewState extends State<DaftarDonaturView> {

  RxInt selectedIndex = 0.obs;
  RxString query = "".obs;
  TrackingController trackingController = Get.put(TrackingController());
  RxBool startAnimation = false.obs;

  // RxList temporaryData = [].obs;
  RxList searchResult = [].obs;
  // RxBool showContainer = false.obs;
 
  // void onQueryChanged(String newQuery){
  //   searchResult.value = temporaryData.where((item) => item.toLowerCase().contains(newQuery.toLowerCase())).toList();
  // }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      trackingController.getDaftarJadwal().then((bool result){
        if(!result){
          Get.snackbar("Gagal", trackingController.responseMessage.value);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Daftar Donatur"),
          actions: [
            Obx(() => selectedIndex.value > 0 ? CupertinoButton(child: const Icon(Bootstrap.trash), onPressed: (){}) : const SizedBox())
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => 
                CupertinoSearchTextField(
                  enabled: trackingController.isLoading.value ? false : true,
                  enableIMEPersonalizedLearning: true,
                  onSubmitted: (value) {
                    searchResult.clear();
                    for(var id in trackingController.listJadwalDonatur.value!.data){
                      if(id.nama!.toLowerCase().contains(value.toLowerCase())){
                        searchResult.add(id);
                      }
                    }
                  },
                  // onChanged: (value) {
                  //   print(value.length);
                  //   if(value.isEmpty || value.length < 1){
                  //     searchResult(temporaryData.where((item) => item.nama.toLowerCase()).toList());
                  //   }
                  // },
                ),
              ),
            )
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await trackingController.getDaftarJadwal().then((bool result){
              if(!result){
                Get.snackbar("Gagal", trackingController.responseMessage.value);
              }
            });
          },
          child: Obx(() {
            if(searchResult.length < 1){
              return RefreshIndicator(
                onRefresh: () async {
                  trackingController.getDaftarJadwal();
                },
              backgroundColor: GlobalVariable.secondaryColor,
              color: Colors.white,
              child: Obx(() => trackingController.isLoading.value ? SizedBox(
                width: size.width,
                height: size.height,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: GlobalVariable.secondaryColor),
                    SizedBox(height: 7),
                    Text("Getting Data...")
                  ],
                ),
              ) : Obx(() => Scrollbar(
                radius: const Radius.circular(10),
                thickness: 8,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await trackingController.getDaftarJadwal().then((bool result){
                      if(!result){
                        Get.snackbar("Gagal", trackingController.responseMessage.value);
                      }
                    });
                  },
                  child: ListView(
                    shrinkWrap: true,
                      children: trackingController.listJadwalDonatur.value == null ? <Widget>[
                        SizedBox(
                          width: size.width,
                          height: size.height / 1.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/no_data.png', width: size.width / 2),
                              const Text("Tidak ada data"),
                            ],
                          )
                        )
                      ] : [
                            Obx(() => ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: trackingController.listJadwalDonatur.value!.data.length,
                              itemBuilder: (context, i) {
                                return Obx(() =>  itemCardDonatur(
                                    size,
                                    index: i,
                                    onPressed: trackingController.listJadwalDonatur.value?.data[i].status == "1" ? (){
                                      dateTimePickerWidget(context, i);
                                    } : (){
                                      Get.snackbar("Gagal", "Donatur sudah ditambahkan ke jadwal pengambilan kaleng bulan ini", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                                    },
                                    kode: trackingController.listJadwalDonatur.value?.data[i].kode,
                                    name: trackingController.listJadwalDonatur.value?.data[i].nama,
                                    status: trackingController.listJadwalDonatur.value?.data[i].status,
                                    hari: trackingController.listJadwalDonatur.value?.data[i].hari,
                                    jam: trackingController.listJadwalDonatur.value?.data[i].jam,
                                    statusStr: trackingController.listJadwalDonatur.value?.data[i].statusStr
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                ),
                  ),
                ),
              ),
            );}
            return Obx(() => trackingController.isLoading.value ? const SizedBox() : ListView(
              shrinkWrap: true,
                  children: List.generate(searchResult.length, (i){
                    return 
                    itemCardDonatur(
                      size,
                      onPressed: (){
                        dateTimePickerWidgetSearched(context, i);
                      },
                      kode: searchResult[i].kode,
                      name: searchResult[i].nama,
                      status: searchResult[i].status,
                      hari: searchResult[i].hari,
                      jam: searchResult[i].jam,
                      statusStr: searchResult[i].statusStr
                   );
                  }),
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  dateTimePickerWidget(BuildContext context, int i) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime.now(),
      maxDateTime: DateTime(2100),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) async {
        DateTime selectdate = dateTime;
        final selIOS = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectdate);
        await trackingController.updateTanggalPengambilan(
          date: selIOS,
          donaturRuteID: trackingController.listJadwalDonatur.value!.data[i].id
        ).then((result){
          if(result){
            Get.snackbar("Berhasil", trackingController.responseMessage.value, backgroundColor: Colors.green, colorText: Colors.white);
            trackingController.getDaftarJadwal().then((done) => Get.back());
          }else{
            Get.back();
            Get.snackbar("Gagal", trackingController.responseMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
          }
        });
      },
    );
  }

  dateTimePickerWidgetSearched(BuildContext context, int i) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime.now(),
      maxDateTime: DateTime(2100),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) async {
        DateTime selectdate = dateTime;
        final selIOS = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectdate);
        await trackingController.updateTanggalPengambilan(
          date: selIOS,
          donaturRuteID: searchResult[i].id
        ).then((result){
          if(result){
            Get.snackbar("Berhasil", trackingController.responseMessage.value, backgroundColor: Colors.green, colorText: Colors.white);
            trackingController.getDaftarJadwal().then((done) => Get.back());
          }else{
            Get.back();
            Get.snackbar("Berhasil", trackingController.responseMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
          }
        });
      },
    );
  }

  CupertinoButton itemCardDonatur(Size size, {Function()? onPressed, String? name, String? status, String? kode, String? jam, String? hari, String? statusStr, int? index}){
    return CupertinoButton(
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(96, 81, 196, 1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black12),
          boxShadow: const [
            BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(1, 2))
          ],
          gradient: LinearGradient(
            colors: hari != null || jam != null ? const [
              Color.fromRGBO(81, 196, 127, 1),
              Color.fromARGB(255, 55, 133, 107),
            ] : const [
              Color.fromRGBO(96, 81, 196, 1),
              Color.fromARGB(255, 65, 55, 133),
            ]
          )
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(name ?? "Tidak ada nama", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 2)),
                Text(kode ?? "ASB0000", style: const TextStyle(fontSize: 14, color: Colors.white60), maxLines: 1),
              ],  
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Clarity.clock_line, color: Colors.white60, size: 18),
                const SizedBox(width: 5),
                Text(hari ?? "Hari Kosong", style: const TextStyle(fontSize: 14, color: Colors.white60), maxLines: 1),
                const SizedBox(width: 5),
                const Text("-", style: TextStyle(fontSize: 14, color: Colors.white60)),
                const SizedBox(width: 5),
                Text("Pukul ${jam ?? '00:00 AM/PM'}", style: const TextStyle(fontSize: 14, color: Colors.white60), maxLines: 1)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if(status == "1")
                  const Icon(Icons.circle, size: 14, color: Colors.green)
                else if(status == "2" || status == "3")
                  const Icon(Icons.circle, size: 14, color: Colors.yellow)
                else if(status == "5")
                  const Icon(Icons.circle, size: 14, color: Colors.blue)
                else
                  const Icon(Icons.circle, size: 14, color: Colors.red),
                const SizedBox(width: 5),
                Text(statusStr ?? "Status 404", style: const TextStyle(fontSize: 14, color: Colors.white60))
              ],
            )
          ],
        ),
      ),
    );
  }
}
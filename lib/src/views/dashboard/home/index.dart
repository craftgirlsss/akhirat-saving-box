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
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/menu_tim_distribusi.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/tambah_page_donatur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class TimeDistribusi extends StatefulWidget {
  const TimeDistribusi({super.key});

  @override
  State<TimeDistribusi> createState() => _TimeDistribusiState();
}

class _TimeDistribusiState extends State<TimeDistribusi> {
  AuthController authController = Get.find();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/ic_launcher.png', width: 50),
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
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(Iconsax.notification_bold, color: GlobalVariable.secondaryColor), onPressed: (){})
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: RefreshIndicator(
          onRefresh: () async {
            await locationController.getCurrentLocation();
          },
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
                    Obx(() => locationController.isLoading.value ? const Text("Getting Location...", style: TextStyle(color: Colors.white60)) : Column(
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
                    Column(
                      children: [
                        Expanded(child: Image.asset('assets/images/place.png')),
                        Obx(() => CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: locationController.isLoading.value ? null : (){
                              locationController.getCurrentLocation();
                            },
                            child: Obx(() => locationController.isLoading.value ? const CupertinoActivityIndicator(color: Colors.white70) : const Icon(CupertinoIcons.refresh, size: 18, color: Colors.white70)), 
                          ),
                        )
                      ],
                    )
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
                    menuItem(size, onTap: (){}, title: "Donatur", color: const Color.fromARGB(255, 16, 114, 30), urlImage: 'assets/images/team.png', orientation: orientation),
                    menuItem(size, onTap: (){}, title: "Riwayat", color: const Color.fromARGB(255, 135, 127, 11), urlImage: 'assets/images/history.png', orientation: orientation),
                    menuItem(size, onTap: (){}, title: "Notifikasi", color: const Color.fromARGB(255, 14, 149, 140), urlImage: 'assets/images/notification.png', orientation: orientation),
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
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
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
                    itemShortcut(onPressed: (){}, name: "H", urlImage: 'assets/images/h.png'),
                    itemShortcut(onPressed: (){}, name: "Reminder", urlImage: 'assets/images/reminder.png'),
                    itemShortcut(onPressed: (){}, name: "Mulai\nBerangkat", urlImage: 'assets/images/go.png')
                  ],
                ),
              ),
                  
              const Text("App Version"),
              Obx(() => Text(appVersion.value)),
              const SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }

  CupertinoButton menuItem(Size size, {String? title, Function()? onTap, Color? color, String? urlImage, Orientation? orientation}){
    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      child: Container(
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
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:asb_app/src/controllers/utilities/timeline_controller.dart';
import 'package:asb_app/src/views/dashboard/home/invoice_page.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/cek_keberangkatan.dart';
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
  TimelineController controller = Get.put(TimelineController());
  DateTime now = DateTime.now();

  Color getRandomColor(){
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.85);
  }

  List<Map<String, dynamic>> dataMenu = [
    {
      "details" : {
        "description" : "Informasi Daftar Lokasi dan Tempat pengambilan kotak amal",
        "nama" : "Temukan Lokasi",
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
        "nama" : "Berita Umum",
        "color" : Colors.cyan,
        "icon" : const Icon(FontAwesome.newspaper, size: 40, color: Colors.white),
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: List.generate(dataMenu.length, (i) {
                return StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: i.isEven ? 2 : 1,
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
                          style: const TextStyle(color: Colors.black), textAlign: TextAlign.center, overflow: TextOverflow.clip,
                          child: Text(dataMenu[i]['details']['description'] ?? "Null", 
                        ),)
                      ),
                      // CupertinoContextMenuAction(
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //   },
                      //   trailingIcon: CupertinoIcons.heart,
                      //   child: const Text('Favorite'),
                      // ),
                      // CupertinoContextMenuAction(
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //   },
                      //   isDestructiveAction: true,
                      //   trailingIcon: CupertinoIcons.delete,
                      //   child: const Text('Delete'),
                      // ),
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
                                Get.to(() => const CekKeberangkatan());
                                break;
                              case 1:
                                Get.to(() => const AccountSettings());
                                break;
                              case 2:
                                Get.to(() => const NotificationPages());
                                break;
                              case 3:
                                // Get.to(() => const PerhitunganPerolehan());
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
                              Text(dataMenu[i]['details']['nama'], style: globalTextStyle.defaultTextStyleBold(fontSize: 17, color: Colors.white, withShadow: false), textAlign: TextAlign.center, maxLines: 3),
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
                  child: const Icon(Iconsax.share_bold), 
                )
              ],
            )
          ],
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
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:asb_app/src/views/auth/forgot.dart';
import 'package:asb_app/src/views/auth/introduction_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/components/utilities/utilities.dart';
import 'package:asb_app/src/views/dashboard/profiles/ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'change_password.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  AuthController authController = Get.find();
  final globalVariable = GlobalVariable();
  final textStyle = GlobalTextStyle();
  final utilities = Utilities();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        shadowColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("More"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                minRadius: 50,
                backgroundColor: Color.fromRGBO(229, 230, 225, 1),
                backgroundImage: AssetImage('assets/images/background.png')
              ),
              const SizedBox(height: 10),
              Obx(() => Text(authController.profileModels.value?.data.name ?? "Unknown Name", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              Obx(() => Text(authController.profileModels.value?.data.email ?? "Unknown Email", style: const TextStyle(fontSize: 14, color: Colors.black45))),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    utilities.cardTitle(title: "Settings"),
                    const SizedBox(height: 6),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword()));
                      },
                      dense: true,
                      title: const Text("Ganti Password"),
                      leading: const Icon(TeenyIcons.password, color: GlobalVariable.secondaryColor),
                      trailing: const CupertinoListTileChevron(),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: (){
                        Get.to(() => const TicketPage());
                      },
                      dense: true,
                      title: const Text("Chat Support"),
                      leading: const Icon(CupertinoIcons.bubble_left_bubble_right_fill, color: GlobalVariable.secondaryColor),
                      trailing: const CupertinoListTileChevron(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Obx(() => CupertinoButton(
                  onPressed: authController.isLoading.value ? null : () async {
                    _showAlertDialog(context);
                  },
                  child: AutoSizeText("Logout", maxLines: 1, style: textStyle.defaultTextStyleMedium(color: GlobalVariable.secondaryColor, fontSize: 17))
                ),
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
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('login');
              prefs.remove('token');
              Get.offAll(() => const IntroductionScreen());
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }

  CupertinoButton shortcutMenu({IconData? icon, Function()? onPressed, String? title}) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Container(
        width: 78,
        height: 78,
        constraints: const BoxConstraints(
          minWidth: 70,
          minHeight: 70,
          maxWidth: 80,
          maxHeight: 80
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon ?? Icons.add, color: GlobalVariable.secondaryColor),
            const SizedBox(height: 5),
            AutoSizeText(title ?? "Unknown", maxLines: 1, style: textStyle.defaultTextStyleMedium(color: GlobalVariable.secondaryColor))
          ],
        ),
      )
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';

class NotificationPages extends StatefulWidget {
  const NotificationPages({super.key});

  @override
  State<NotificationPages> createState() => _NotificationPagesState();
}

class _NotificationPagesState extends State<NotificationPages> {
  final textStyle = GlobalTextStyle();
  final globalVariable = GlobalVariable();
  List temporaryArray = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariable.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Notifikasi", style: textStyle.defaultTextStyleBold()),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: (){},
            child: const Icon(CupertinoIcons.trash, size: 22, color: GlobalVariable.secondaryColor),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children:[
            GestureDetector(
              onLongPress: (){
                showAlertDialog(context, onOK: (){
                  Navigator.pop(context);
                });
              },
              child: notificationItem(
                onPressed: (){},
                title: "Verifikas alamat email anda",
                icon: CupertinoIcons.mail,
                content: "Verifikasi email anda agar kami dapat memberikan akses jika suatu saat anda lupa atau terjadi masalah pada akun anda"
              ),
            ),
            notificationItem(
              onPressed: (){},
              title: "Diskon 10% menanti anda",
              icon: Bootstrap.percent,
              content: "Dapatkan diskon sebesar 10% untuk penlanggan baru. Perbanyak transaksi untuk mendapatkan benefitnya."
            ),
          ]
        ),
      ),
    );
  }

  Widget notificationItem({Function()? onPressed, String? title, String? content, IconData? icon}){
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title ?? "No Title", style: textStyle.defaultTextStyleMedium(fontSize: 16)),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(child: Text(content ?? "No available content", style: textStyle.defaultTextStyle(color: Colors.black54, fontSize: 14), maxLines: 2, overflow: TextOverflow.clip)),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade50
                  ),
                  child: Icon(icon ?? Icons.notifications, color: GlobalVariable.secondaryColor)
                )
              ],
            )
          ],
        ),
      )
    );
  }

  void showAlertDialog(BuildContext context, {String? title, String? content, String? textAccepted, String? textCancel, Function()? onOK}) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? 'Alert'),
        content: Text(content ?? 'Proceed with destructive action?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: onOK ?? () {
              Navigator.pop(context);
            },
            child: Text(textCancel ?? 'No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(textAccepted ?? 'Yes'),
          ),
        ],
      ),
    );
  }
}

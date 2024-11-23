import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';

class Utilities {
  final globalVariable = GlobalVariable();
  final textStyle = GlobalTextStyle();

  Widget cardTitle({String? title}){
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: GlobalVariable.secondaryColor
          ),
        ),
        const SizedBox(width: 8),
        AutoSizeText(title ?? "Unknown Title", style: textStyle.defaultTextStyleMedium(), minFontSize: 16, maxFontSize: 17, maxLines: 1, overflow: TextOverflow.clip)
      ],
    );
  }


  Widget floatingLoading() {
    return Container(
      color: CupertinoColors.black.withOpacity(0.3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(229, 223, 221, 1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black54, offset: Offset(0, 5))
                ],
                image: const DecorationImage(image: AssetImage('assets/images/loading.gif'))
              ),
              child: const Center(child: Text("Loading", style: TextStyle(fontSize: 12))),
            ),
          ],
        ),
      ),
    );
  }

  Widget couponCard(context, {Function()? onPressed, Color? color, int? discount, String? titleDiscount}){
    final size = MediaQuery.of(context).size;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
        margin: const EdgeInsets.all(7),
        constraints: BoxConstraints(
            maxWidth: size.width / 1.5,
            minWidth: size.width / 1.6
        ),
        decoration: BoxDecoration(
          color: color ?? GlobalVariable.secondaryColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AutoSizeText(titleDiscount ?? "Diskon Angkutan Darat", style: textStyle.defaultTextStyleMedium(fontSize: 14)),
                const SizedBox(width: 7),
                GestureDetector(
                    onTap: (){},
                    child: const Icon(Bootstrap.info_circle_fill, color: Colors.black, size: 18)
                )
              ],
            ),
            AutoSizeText("Diskon ${discount ?? 0}%", style: textStyle.defaultTextStyleMedium(fontSize: 32)),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                onPressed: onPressed, label: Text("Ambil Voucher", style: textStyle.defaultTextStyleMedium(color: color ?? GlobalVariable.secondaryColor.withOpacity(0.7))), icon: Icon(Icons.keyboard_arrow_right, color: color ?? GlobalVariable.secondaryColor.withOpacity(0.7)), iconAlignment: IconAlignment.end)
          ],
        ),
      ),
    );
  }
}

Widget floatingLoading() {
  return Container(
    color: CupertinoColors.black.withOpacity(0.3),
    child: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(color: CupertinoColors.white,),
        ],
      ),
    ),
  );
}
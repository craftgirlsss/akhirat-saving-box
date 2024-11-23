import 'package:flutter/material.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';

SizedBox roundedRectangleButton({double? size, String? text, Function()? onPressed, Color? color}){
  final textStyle = GlobalTextStyle();
  return SizedBox(
    width: size ?? 0,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: color ?? GlobalVariable.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        )
      ),
      child: Text(text ?? "Kirim Pesan", style: textStyle.defaultTextStyleBold(color: Colors.white))
    )
  );
}
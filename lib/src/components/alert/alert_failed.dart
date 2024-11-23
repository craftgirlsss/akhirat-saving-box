import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:flutter/material.dart';

alertFailed(BuildContext context, {required String? title, required String? content, Function()? onOK, String? textButtonOK}){
  final size = MediaQuery.of(context).size;
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    borderSide: const BorderSide(
      color: GlobalVariable.secondaryColor,
      width: 1,
    ),
    width: size.width,
    buttonsBorderRadius: const BorderRadius.all(
      Radius.circular(10),
    ),
    dismissOnTouchOutside: true,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    title: title,
    desc: content,
    btnOkText: textButtonOK ?? "OK",
    showCloseIcon: true,
    btnOkOnPress: onOK
  ).show();
}
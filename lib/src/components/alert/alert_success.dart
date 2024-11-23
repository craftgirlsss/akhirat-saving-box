import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:flutter/material.dart';

alertSuccess(BuildContext context, {required String? title, required String? content, Function()? onOK}){
  // final size = MediaQuery.of(context).size;
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    btnOkText: "OK",
    borderSide: const BorderSide(
      color: GlobalVariable.secondaryColor,
      width: 1,
    ),
    // width: size.width,
    buttonsBorderRadius: const BorderRadius.all(
      Radius.circular(10),
    ),
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: false,
    animType: AnimType.scale,
    title: title,
    desc: content,
    showCloseIcon: false,

    btnOkOnPress: onOK)
    .show();
}
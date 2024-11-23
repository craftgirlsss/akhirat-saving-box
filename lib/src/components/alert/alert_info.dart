import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:flutter/material.dart';

alertInfo(BuildContext context, {required String? title, required String? content, Function()? onOK, bool withCancelButton = true}){
  // final size = MediaQuery.of(context).size;
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.info,
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
    dismissOnTouchOutside: true,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    title: title,
    desc: content,
    showCloseIcon: withCancelButton,
    btnCancelOnPress: withCancelButton ? (){} : null,
    btnOkOnPress: onOK)
  .show();
}

alertInfoQuestion(BuildContext context, {required String? title, required String? content, Function()? onOK}){
  // final size = MediaQuery.of(context).size;
  return AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
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
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: title,
      desc: content,
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: onOK)
      .show();
}
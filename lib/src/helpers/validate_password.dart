import 'package:flutter/material.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';

bool validateStructure(String value){
  String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

extension PasswordValidator on String {
  bool isValidPassword() {
    return RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(this);
  }
}


class RowEliminateNumbers extends StatelessWidget {
  RowEliminateNumbers({
    super.key,
    required this.hasPasswordOneNumber,
  });

  final bool hasPasswordOneNumber;
  final globalVariable = GlobalVariable();
  final textStyle = GlobalTextStyle();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color: hasPasswordOneNumber ? GlobalVariable.secondaryColor : Colors.transparent,
              border: hasPasswordOneNumber
                ? Border.all(color: Colors.transparent)
                : Border.all(color: GlobalVariable.secondaryColor),
              borderRadius: BorderRadius.circular(50)),
          child: Center(
            child: Icon(
              Icons.check,
              color: hasPasswordOneNumber ? Colors.white : GlobalVariable.secondaryColor,
              size: 15,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text("Minimal terdapat 1 angka", style: textStyle.defaultTextStyleMedium(color: GlobalVariable.secondaryColor))
      ],
    );
  }
}

class RowEliminateCapitalizeWord extends StatelessWidget {
  RowEliminateCapitalizeWord({
    super.key,
    required this.hasLowerUpper,
  });

  final bool hasLowerUpper;
  final globalVariable = GlobalVariable();
  final textStyle = GlobalTextStyle();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color: hasLowerUpper ? GlobalVariable.secondaryColor : Colors.transparent,
              border: hasLowerUpper
                ? Border.all(color: Colors.transparent)
                : Border.all(color: GlobalVariable.secondaryColor),
              borderRadius: BorderRadius.circular(50)),
          child: Center(
            child: Icon(
              Icons.check,
              color: hasLowerUpper ? Colors.white : GlobalVariable.secondaryColor,
              size: 15,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text("Huruf kecil dan besar", style: textStyle.defaultTextStyleMedium(color: GlobalVariable.secondaryColor))
      ],
    );
  }
}

class RowEliminateLength extends StatelessWidget {
  RowEliminateLength({
    super.key,
    required this.isPasswordEightCharacters,
  });

  final bool isPasswordEightCharacters;
  final globalVariable = GlobalVariable();
  final textStyle = GlobalTextStyle();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color:
              isPasswordEightCharacters ? GlobalVariable.secondaryColor : Colors.transparent,
              border: isPasswordEightCharacters
                ? Border.all(color: Colors.transparent)
                : Border.all(color: GlobalVariable.secondaryColor),
              borderRadius: BorderRadius.circular(50)),
          child: Center(
            child: Icon(
              Icons.check,
              color: isPasswordEightCharacters ? Colors.white : GlobalVariable.secondaryColor,
              size: 15,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text("Panjang minimal 8 karakter", style: textStyle.defaultTextStyleMedium(color: GlobalVariable.secondaryColor),)
      ],
    );
  }
}

class RowEliminateSamePassword extends StatelessWidget {
  RowEliminateSamePassword({
    super.key,
    required this.isPasswordSameWithOther,
  });

  final bool isPasswordSameWithOther;
  final globalVariable = GlobalVariable();
  final textStyle = GlobalTextStyle();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color:
              isPasswordSameWithOther ? GlobalVariable.secondaryColor : Colors.transparent,
              border: isPasswordSameWithOther
                ? Border.all(color: Colors.transparent)
                : Border.all(color: GlobalVariable.secondaryColor),
              borderRadius: BorderRadius.circular(50)),
          child: Center(
            child: Icon(
              Icons.check,
              color: isPasswordSameWithOther ? Colors.white : GlobalVariable.secondaryColor,
              size: 15,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text("Password Sama", style: textStyle.defaultTextStyleMedium(color: GlobalVariable.secondaryColor),)
      ],
    );
  }
}
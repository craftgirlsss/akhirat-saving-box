import 'package:flutter/material.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/helpers/validate_password.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // AccountsController accountsController = Get.find();
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController reTypeNewPassword = TextEditingController();
  final textStyle = GlobalTextStyle();
  final globalVariable = GlobalVariable();

  bool showCurrentPassword = true;
  bool showNewPassword = true;
  bool showRetypeNewPassword = true;
  bool isPasswordEightCharacters = false;
  bool hasPasswordOneNumber = false;
  bool hasLowerUpper = false;
  bool hasPasswordSame = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final upperLowerRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z]).{8,}$');

    setState(() {
      isPasswordEightCharacters = false;
      if (password.length > 7) isPasswordEightCharacters = true;

      hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) hasPasswordOneNumber = true;
    });
    hasLowerUpper = false;
    if (upperLowerRegex.hasMatch(password)) hasLowerUpper = true;
  }

  onPasswordChangeConfirm(String newPassword, String reTypeNewPassword){
    setState(() {
      hasPasswordSame = false;
      if (newPassword == reTypeNewPassword) hasPasswordSame = true;
    });
  }

  @override
  void initState() {
    super.initState();
    newPassword.addListener(() {});
    reTypeNewPassword.addListener(() {});
  }

  @override
  void dispose() {
    currentPassword.dispose();
    newPassword.dispose();
    reTypeNewPassword.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Text("Ubah Password", style: textStyle.defaultTextStyleBold(fontSize: 17)),
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  TextFormField(
                    controller: currentPassword,
                    obscureText: showCurrentPassword,
                    keyboardAppearance: Brightness.dark,
                    style: textStyle.defaultTextStyleMedium(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Password Sekarang",
                      errorStyle: textStyle.defaultTextStyleMedium(color: Colors.red),
                      labelText: "Password Sekarang",
                      labelStyle: const TextStyle(color: GlobalVariable.secondaryColor),
                      hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
                      filled: false,
                      suffix: GestureDetector(
                        onTap: (){
                          setState(() {
                            showCurrentPassword = !showCurrentPassword;
                          });
                        },
                        child: showCurrentPassword == true ?  Icon(Icons.visibility, color: GlobalVariable.secondaryColor.withOpacity(0.5)) :  Icon(Icons.visibility_off, color: GlobalVariable.secondaryColor.withOpacity(0.5)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:GlobalVariable.secondaryColor
                          )
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:GlobalVariable.secondaryColor
                          )
                      ),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:GlobalVariable.secondaryColor
                          )
                      )
                    ),
                    onChanged: (text) => onPasswordChanged(text),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: newPassword,
                    obscureText: showNewPassword,
                    keyboardAppearance: Brightness.dark,
                    style: textStyle.defaultTextStyleMedium(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Set new password",
                      errorStyle: textStyle.defaultTextStyleMedium(color: Colors.red),
                      labelText: "Password Baru",
                      labelStyle: const TextStyle(color: GlobalVariable.secondaryColor),
                      hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
                      filled: false,
                      suffix: GestureDetector(
                        onTap: (){
                          setState(() {
                            showNewPassword = !showNewPassword;
                          });
                        },
                        child: showNewPassword == true ?  Icon(Icons.visibility, color: GlobalVariable.secondaryColor.withOpacity(0.5)) :  Icon(Icons.visibility_off, color: GlobalVariable.secondaryColor.withOpacity(0.5)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:GlobalVariable.secondaryColor
                          )
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:GlobalVariable.secondaryColor
                        )
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:GlobalVariable.secondaryColor
                        )
                      )
                    ),
                    onChanged: (text) => onPasswordChanged(text),
                  ),
                  const SizedBox(height: 15),
                  RowEliminateLength(
                      isPasswordEightCharacters: isPasswordEightCharacters),
                  const SizedBox(height: 10),
                  RowEliminateCapitalizeWord(hasLowerUpper: hasLowerUpper),
                  const SizedBox(height: 10),
                  RowEliminateNumbers(hasPasswordOneNumber: hasPasswordOneNumber),
                  const SizedBox(height: 10),
                  RowEliminateSamePassword(isPasswordSameWithOther: hasPasswordSame),
                  TextFormField(
                    controller: reTypeNewPassword,
                    obscureText: showRetypeNewPassword,
                    keyboardAppearance: Brightness.dark,
                    style: textStyle.defaultTextStyleMedium(fontSize: 13),
                    decoration: InputDecoration(
                        hintText: "Confirm password",
                        errorStyle: textStyle.defaultTextStyleMedium(color: Colors.red),
                        labelText: "Konfirmasi Password Baru",
                        labelStyle: const TextStyle(color: GlobalVariable.secondaryColor),
                        hintStyle: TextStyle(color: GlobalVariable.secondaryColor.withOpacity(0.7), fontSize: 15),
                        filled: false,
                        suffix: GestureDetector(
                          onTap: (){
                            setState(() {
                              showRetypeNewPassword = !showRetypeNewPassword;
                            });
                          },
                          child: showRetypeNewPassword == true ? const Icon(Icons.visibility, color: GlobalVariable.secondaryColor) :  Icon(Icons.visibility_off, color: GlobalVariable.secondaryColor.withOpacity(0.5)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:GlobalVariable.secondaryColor
                            )
                        ),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:GlobalVariable.secondaryColor
                            )
                        ),
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:GlobalVariable.secondaryColor
                            )
                        )
                    ),
                    onChanged: (text) => onPasswordChangeConfirm(newPassword.text, text),
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: GlobalVariable.secondaryColor,
                      ),
                      onPressed: (){

                      },
                      child: Text("Ubah Password", style: textStyle.defaultTextStyleMedium(fontSize: 16, color: Colors.white))
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Obx(() => accountsController.isLoading.value == true
        //     ? floatingLoading()
        //     : const SizedBox()),
      ],
    );
  }
}
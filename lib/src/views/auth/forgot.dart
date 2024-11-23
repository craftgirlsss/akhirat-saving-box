import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalTextStyle textStyle = GlobalTextStyle();
  GlobalVariable globalVariable = GlobalVariable();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text("Forgot Password", style: textStyle.defaultTextStyleMedium(fontSize: 18)),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          width: double.infinity,
          height: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Image.asset('assets/images/ic_launcher.png', width: size.width / 2.5),
                      // const FlutterLogo(size: 100, style: FlutterLogoStyle.stacked),
                      AutoSizeText("I lost my password", style: textStyle.defaultTextStyleBold(), maxLines: 1, minFontSize: 30, maxFontSize: 37, overflow: TextOverflow.fade),
                      const SizedBox(height: 10),
                      AutoSizeText("Inputkan alamat email yang telah didaftarkan sebelumnya oleh admin untuk dapat mengirim kode OTP", style: textStyle.defaultTextStyleMedium(color: Colors.black45), overflow: TextOverflow.clip, maxFontSize: 17, minFontSize: 14, textAlign: TextAlign.center,)
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: GlobalVariable.secondaryColor)),
                          label: Text("Email", style: textStyle.defaultTextStyleMedium(color: GlobalVariable.secondaryColor, fontSize: 16)),
                          prefixIcon: const Icon(Icons.email, color: GlobalVariable.secondaryColor)
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: GlobalVariable.secondaryColor,
                    ),
                    onPressed: (){
                      Get.back();
                    }, child: Text("Kirim kode OTP", style: textStyle.defaultTextStyleMedium(fontSize: 16, color: Colors.white))
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
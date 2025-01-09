import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:asb_app/src/views/dashboard/home/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/views/auth/forgot.dart';
import 'package:icons_plus/icons_plus.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthController authController = Get.find();
  GlobalTextStyle textStyle = GlobalTextStyle();
  GlobalVariable globalVariable = GlobalVariable();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: size.width,
            height: size.height,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Image.asset('assets/images/ic_launcher.png', width: size.width / 2),
                        // const FlutterLogo(size: 100, style: FlutterLogoStyle.stacked),
                        AutoSizeText("Easy Apps for tracking your work", style: textStyle.defaultTextStyleBold(), maxLines: 2, minFontSize: 30, maxFontSize: 37, overflow: TextOverflow.fade, textAlign: TextAlign.center),
                        const SizedBox(height: 10),
                        AutoSizeText("Masuk dengan akun yang telah didaftarkan sebelumnya oleh admin", style: textStyle.defaultTextStyleMedium(color: Colors.black45), overflow: TextOverflow.clip, maxFontSize: 17, minFontSize: 14, textAlign: TextAlign.center,)
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mohon masukkan email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: GlobalVariable.secondaryColor)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: GlobalVariable.secondaryColor)),
                            label: Text("Email", style: textStyle.defaultTextStyleMedium(color: GlobalVariable.secondaryColor, fontSize: 16)),
                            prefixIcon: const Icon(Icons.email, color: GlobalVariable.secondaryColor)
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: obscureText,
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mohon masukkan password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: CupertinoButton(
                              child: Icon(obscureText ? Clarity.eye_show_line : Clarity.eye_hide_line, color: GlobalVariable.secondaryColor), 
                              onPressed: (){
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              }
                            ),
                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: GlobalVariable.secondaryColor)),
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: GlobalVariable.secondaryColor)),
                            label: Text("Password", style: textStyle.defaultTextStyleMedium(color: GlobalVariable.secondaryColor, fontSize: 16)),
                            prefixIcon: const Icon(Icons.lock, color: GlobalVariable.secondaryColor)
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: GlobalVariable.secondaryColor,
                        ),
                        onPressed: authController.isLoading.value ? (){} : () async {
                          if(_formKey.currentState!.validate()){
                            if(await authController.loginController(email: emailController.text, password: passwordController.text)){
                              Get.offAll(() => const DashboardTrainer());
                              // SharedPreferences prefs = await SharedPreferences.getInstance();
                              // String? token = prefs.getString('token');
                              // if(token != null){
                              //   authController.getProfileController(token: token).then((result){
                              //     if(result){
                              //     }
                              //   });
                              // }else{
                              //   Get.snackbar('Gagal', authController.responseMessage.value, backgroundColor: Colors.red, colorText: Colors.white);  
                              // }
                            }else{
                              Get.snackbar('Gagal', authController.responseMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
                            }
                          }
                        }, 
                        child: authController.isLoading.value ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(color: Colors.white),
                        ) : Text("Sign in", style: textStyle.defaultTextStyleMedium(fontSize: 16, color: Colors.white))
                      ),
                    ),
                  ),
                  CupertinoButton(child: AutoSizeText("Lupa Password? Reset", style: textStyle.defaultTextStyleMedium(color: GlobalVariable.secondaryColor), minFontSize: 16, maxFontSize: 18), onPressed: (){
                    Get.to(() => const ForgotPassword());
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
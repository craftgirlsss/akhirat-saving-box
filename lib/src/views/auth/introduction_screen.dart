import 'package:asb_app/src/views/auth/forgot.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/views/auth/signin.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  GlobalTextStyle textStyle = GlobalTextStyle();
  GlobalVariable globalVariable = GlobalVariable();
  var signupSelected = true.obs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.topCenter,
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          // color: Colors.black,
          image: DecorationImage(image: AssetImage('assets/images/background.png'), fit: BoxFit.contain)
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 35),
                width: size.width,
                // height: size.height / 2.2,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35)
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText("Welcome to", style: textStyle.defaultTextStyleBold(), maxLines: 1, minFontSize: 40, maxFontSize: 45, overflow: TextOverflow.fade),
                          AutoSizeText("Akhirat Saving Box", style: textStyle.defaultTextStyleBold(color: GlobalVariable.secondaryColor), maxLines: 2, minFontSize: 35, maxFontSize: 40, overflow: TextOverflow.fade),
                          const SizedBox(height: 10),
                          AutoSizeText("Pengambilan amal lebih mudah dan cepat dengan satu genggaman", style: textStyle.defaultTextStyleMedium(color: Colors.black45), overflow: TextOverflow.clip, maxFontSize: 17, minFontSize: 14)
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.circular(30),
                        // border: Border.all(color: Colors.black45)
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Obx(() => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                  color: signupSelected.value ? GlobalVariable.secondaryColor : Colors.black12
                                ),
                                elevation: 0,
                                backgroundColor: signupSelected.value ? GlobalVariable.secondaryColor : Colors.white,
                              ),
                              onPressed: (){
                                signupSelected.value = true;
                                Get.to(() => const SignIn());
                              }, child: Text("Masuk", style: textStyle.defaultTextStyleMedium(fontSize: 16, color: signupSelected.value ? Colors.white : Colors.black))
                              ),
                            )
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Obx(() => ElevatedButton(
                              style: ElevatedButton.styleFrom( 
                                side: BorderSide(
                                  color: signupSelected.value ? Colors.black12 : GlobalVariable.secondaryColor
                                ),
                                elevation: 0,
                                backgroundColor: signupSelected.value ? Colors.white : GlobalVariable.secondaryColor,
                              ),
                              onPressed: (){
                                signupSelected.value = false;
                                Get.to((() => const ForgotPassword()));
                              }, child: Text("Lupa?", style: textStyle.defaultTextStyleMedium(fontSize: 16, color: signupSelected.value ? Colors.black : Colors.white))
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
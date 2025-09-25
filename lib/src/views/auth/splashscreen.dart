import 'package:asb_app/sources/views/dashboards/dashboard_view.dart';
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:asb_app/src/views/auth/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  AuthController authController = Get.put(AuthController());
  
  Future<bool> getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('login') ?? false;
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('token');
  }
  
  @override
  void initState() {  
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      final bool isLoggedIn = await getLogin();

      if (isLoggedIn) {
        final String? token = await getToken();

        if (token != null) {
          debugPrint("ini token user $token");
          authController.token.value = token;
          final bool profileSuccess = await authController.getProfileController(token: token);

          if (profileSuccess) {
            Get.offAll(() => DashboardView());
          } else {
            Get.snackbar("Gagal", "Gagal mendapatkan informasi akun anda, silahkan login ulang!", backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 2));
            await removeToken();
            Get.off(() => const IntroductionScreen());
          }
        } else {
          Get.snackbar("Gagal", "Gagal mendapatkan ID akun anda", backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 2));
          Get.off(() => const IntroductionScreen());
        }
      } else {
        Get.off(() => const IntroductionScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset('assets/images/ic_launcher.png', width: orientation == Orientation.portrait ? size.width / 2 : size.width / 4)),
              const Center(child: Text("Solusi Mudah, dalam Bersedekah", textAlign: TextAlign.center, style: TextStyle(fontSize: 12)))
            ],
          ),
        ),
      ),
    );
  }
}
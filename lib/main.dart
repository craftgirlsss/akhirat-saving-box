// import 'package:asb_app/sources/views/dashboards/absensi/absensi_keberangkatan_view.dart';
// import 'package:asb_app/sources/views/dashboards/dashboard_view.dart';
// import 'package:asb_app/src/components/global/index.dart';
// import 'package:asb_app/src/views/auth/signin.dart';
// import 'package:asb_app/src/views/auth/splashscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     return GetMaterialApp(
//       title: 'Akhirat SavingBox',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           centerTitle: true,
//           actionsIconTheme: IconThemeData(
//             color: GlobalVariable.secondaryColor
//           ),
//           iconTheme: IconThemeData(color: GlobalVariable.secondaryColor),
//         ),
//         textTheme: GoogleFonts.poppinsTextTheme(textTheme).copyWith(
//           bodyMedium: GoogleFonts.poppins(textStyle: textTheme.bodyMedium),
//         ),
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       initialRoute: '/splashscreen', // Tentukan rute awal
//       getPages: [
//         // Daftarkan semua halaman (views) di sini
//         GetPage(
//           name: '/splashscreen',
//           page: () => const Splashscreen(),
//         ),
//         GetPage(
//           name: '/login',
//           page: () => const SignIn(), // Asumsikan Anda memiliki LoginView
//         ),
//         GetPage(
//           name: '/dashboard',
//           page: () => DashboardView(), // DashboardView dari kode sebelumnya
//         ),
//         GetPage(
//           name: '/absensi-keberangkatan',
//           page: () => AbsensiKeberangkatanView(), // View absen keberangkatan
//         ),
//         // Tambahkan rute untuk halaman lain seperti Daftar Donatur, dll.
//         // GetPage(
//         //   name: '/donatur-list',
//         //   page: () => DonaturListView(),
//         // ),
//       ],
//     );
//   }
// }

import 'package:asb_app/src/views/auth/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: false, ignoreSsl: false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GetMaterialApp(
      title: 'Akhirat SavingBox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actionsIconTheme: IconThemeData(
            color: Colors.white
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(textTheme).copyWith(
          bodyMedium: GoogleFonts.poppins(textStyle: textTheme.bodyMedium),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Splashscreen(),
    );
  }
}
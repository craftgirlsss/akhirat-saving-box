// import 'package:internet_connection_checker/internet_connection_checker.dart';

// class ConnectionChecker {
//   final connectionChecker = InternetConnectionChecker.instance;
//   bool isConnected = false;
//   var subscription;

//   bool checkingConnection(){
//     subscription = connectionChecker.onStatusChange.listen(
//       (InternetConnectionStatus status) {
//         if (status == InternetConnectionStatus.connected) {
//           isConnected = true;
//           print('Connected to the internet');
//         } else {
//           isConnected = false;
//           print('Disconnected from the internet');
//         }
//       },
//     );
//     return isConnected;
//   }

//   void disposeConnection(){
//     subscription.cancel();
//   }

// }
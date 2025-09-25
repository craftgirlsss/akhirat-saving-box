import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/models/profile_models.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController{
  var isLoading = false.obs;
  RxString token = "".obs;
  RxString kodeKeberangkatan = "".obs;
  RxString responseMessage = "".obs;
  Rxn<ProfileModels> profileModels = Rxn<ProfileModels>();

  Future<bool> loginController({String? email, String? password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/signin")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'email': email,
          'password': password
        },
      );
      var result = jsonDecode(response.body);
      print("ini result login() => $result");
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          token.value = result['data']['token'];
          prefs.setBool('login', true);
          prefs.setString('token', result['data']['token']);
          responseMessage.value = result['message'];
          getProfileController(token: result['data']['token']);
          return true;
        }
        responseMessage.value = result['message'];
        return false;
      } else {
        responseMessage.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> resetPasswordController({String? email}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/reset-password")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'email': email,
        },
      );
      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          responseMessage.value = result['message'];
          return true;
        }
        responseMessage.value = result['message'];
        return false;
      } else {
        responseMessage.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> getProfileController({String? token}) async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/profile?user=$token")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      ).timeout(const Duration(seconds: 8));
      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          profileModels.value = ProfileModels.fromJson(result);
          responseMessage.value = result['message'];
          return true;
        }
        responseMessage.value = result['message'];
        return false;
      } else {
        responseMessage.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseMessage.value = e.toString();
      return false;
    }
  }
}
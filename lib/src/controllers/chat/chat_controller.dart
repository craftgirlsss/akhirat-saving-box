import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:asb_app/src/models/chat_models.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChatControllers extends GetxController{
  var isLoading = false.obs;
  var chatModels = Rxn<ChatsModels>();

  // @override
  // onInit(){
  //   super.onInit();
  //   getMessage();
  // }

  Future<bool> sendMessage({String? message})async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("https://gifx-wxgcod-api.techcrm.net/ticket")!,
        headers: {
          'x-api-key': 'fewAHdSkx28301294cKSnczdAs',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'id': id ?? 'cac9cd8e46b12dfa76b8c7a1d9cee348',
          'message': message
        },
      );
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        isLoading(false);
        if (result['status'] == "true") {
          return true;
        }
        return false;
      } else {
        Get.snackbar("Failed", result['message'], backgroundColor: Colors.white, colorText: Colors.black87);
        isLoading(false);
        return false;
      }
    } catch (e) {
      isLoading(false);
      return false;
    }
  }


  Future<bool> getMessage()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("https://gifx-wxgcod-api.techcrm.net/ticket-list")!,
        headers: {
          'x-api-key': 'fewAHdSkx28301294cKSnczdAs',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
          'id': id ?? 'cac9cd8e46b12dfa76b8c7a1d9cee348',
        },
      );
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        isLoading(false);
        if (result['status'] == "true") {
          chatModels.value = ChatsModels.fromJson(result);
          return true;
        }
        return false;
      } else {
        Get.snackbar("Failed", result['message'], backgroundColor: Colors.white, colorText: Colors.black87);
        isLoading(false);
        return false;
      }
    } catch (e) {
      isLoading(false);
      return false;
    }
  }
}
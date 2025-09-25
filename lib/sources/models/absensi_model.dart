import 'dart:io';

class AbsensiKeberangkatanModel {
  File? selfie;
  File? shoesAndPants;
  File? bikeAndCan;
  String? notes;

  bool get isValid => selfie != null && shoesAndPants != null && bikeAndCan != null;
}
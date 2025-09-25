// import 'package:asb_app/src/components/textformfield/rounded_rectangle_form_field.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:asb_app/src/controllers/wilayah/wilayah_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:latlong2/latlong.dart';

class TambahDonaturPage extends StatefulWidget {
  const TambahDonaturPage({super.key});

  @override
  State<TambahDonaturPage> createState() => _TambahDonaturPageState();
}

class _TambahDonaturPageState extends State<TambahDonaturPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            icon: const Icon(Iconsax.arrow_left_2_bold, size: 30,)
          ),
          backgroundColor:Colors.white,
          title: const Text("Daftar Donatur", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: const StepperView(),
      ),
    );
  }
}

class StepperView extends StatefulWidget {
  const StepperView({super.key});

  @override
  State<StepperView> createState() => _StepperViewState();
}

class _StepperViewState extends State<StepperView> {
  RxInt _index = 0.obs;

  // Indexed List Selected
  RxInt selectedWilayahIndex = 0.obs;
  RxInt selectedProvinceIndex = 0.obs;
  RxInt selectedKabupatenIndex = 0.obs;
  RxInt selectedKecamatanIndex = 0.obs;
  RxInt selectedProgramIndex = 0.obs;
  RxBool isLoading = false.obs;

  // Kecamatan Variable
  RxString selectedKecamatanString = ''.obs;

  // Provinsi Variable
  RxString selectedProvinsiString = ''.obs;
  RxString selectedProvinsiID = ''.obs;

  // Kabupaten Variable
  RxString selectedKabupatenString = ''.obs;
  RxString selectedKabupatenID = ''.obs;

  // Wilayah Variable
  RxString selectedWilayahString = ''.obs;
  RxString selectedWilayahID = ''.obs;

  // Program Variable
  RxString selectedProgramString = ''.obs;
  RxString selectedProgramID = ''.obs;

  // Jenis Kelamin Variable
  RxString selectedGenderString = ''.obs;

  //Lat Long Selected
  RxDouble latitudeSelected = 0.0.obs;
  RxDouble longitudeSelected = 0.0.obs;

  WilayahController wilayahController = Get.put(WilayahController());
  LocationController locationController = Get.find();
  TrackingController trackingController = Get.put(TrackingController());
  TextEditingController proviceController = TextEditingController();
  TextEditingController kabupatenController = TextEditingController();
  TextEditingController kecamatanController = TextEditingController();
  TextEditingController kodeASB = TextEditingController();
  TextEditingController namaLengkap = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController usia = TextEditingController();
  TextEditingController lat = TextEditingController();
  TextEditingController long = TextEditingController();
  final List<String> provinsiList = List.generate(50, (index) => 'Provinsi ${index + 1}');
  
  RxString selectedProvinsi = "".obs;
  RxString selectedKabupaten = "".obs;
  RxString selectedKecamatan = "".obs;
  RxString selectedDesa = "".obs;
  final formKey = GlobalKey<FormState>();

  
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      wilayahController.getWilayah().then((result){
        if(result){
          selectedWilayahString(wilayahController.wilayahModels.value!.data[0].nama);
          selectedWilayahID(wilayahController.wilayahModels.value!.data[0].id);
        }
      });
      wilayahController.getProvince();
    });
  }

  @override
  void dispose() {
    proviceController.dispose();
    kabupatenController.dispose();
    kecamatanController.dispose();
    namaLengkap.dispose();
    kodeASB.dispose();
    alamat.dispose();
    phone.dispose();
    usia.dispose();
    lat.dispose();
    long.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(() => Stepper(
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _index.value == 0 ? const SizedBox() : ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text('Kembali', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CupertinoColors.systemRed
                    ),
                    onPressed: (){
                      if (_index > 0) {
                        _index.value -= 1;
                      }
                    },
                  ),
                  _index.value == 1 ? 
                    Obx(() => ElevatedButton.icon(
                        onPressed: trackingController.isLoading.value ? null : () async {
                          await trackingController.tambahDonaturAPI(
                            province: proviceController.text,
                            kabupaten: kabupatenController.text,
                            kecamatan: kecamatanController.text,
                            wilayahID: selectedWilayahID.value,
                            programID: selectedProgramID.value,
                            kodeASB: kodeASB.text,
                            namaLengkap: namaLengkap.text,
                            gender: selectedGenderString.value,
                            usia: usia.text,
                            noHP: phone.text,
                            alamat: alamat.text,
                            lat: latitudeSelected.value,
                            long: longitudeSelected.value,
                          ).then((result) {
                            if(result){
                              //Reset variable
                              selectedWilayahID("");
                              selectedWilayahString("");
                              selectedWilayahIndex(0);
                              selectedProvinsiString("");
                              selectedProvinsiID("");
                              selectedProvinceIndex(0);
                              selectedKabupatenID("");
                              selectedKabupatenIndex(0);
                              selectedKabupatenString("");
                              selectedKecamatanString("");
                              selectedKecamatanIndex(0);
                              _index(0);
                              selectedProgramID("");
                              selectedProgramIndex(0);
                              selectedProgramString("");
                              selectedGenderString("");
                              latitudeSelected(0.0);
                              longitudeSelected(0.0);
                              Get.snackbar("Berhasil", "Berhasil menambah doantur", backgroundColor: Colors.green, colorText: Colors.white);
                              Future.delayed(const Duration(seconds: 2), () => Get.back());
                            }else{
                              Get.snackbar("Gagal", trackingController.responseMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
                            }
                          });
                        },
                        iconAlignment: IconAlignment.end,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(right: 8, left: 15),
                          backgroundColor: CupertinoColors.activeGreen
                        ),
                        icon: Obx(() => trackingController.isLoading.value ? const SizedBox() : const Icon(CupertinoIcons.check_mark, color: CupertinoColors.white)),
                        label: Obx(() => trackingController.isLoading.value ? const CupertinoActivityIndicator(color: Colors.black54) : const Text('Simpan', style: TextStyle(color: CupertinoColors.white))),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: (){
                        if (_index.value <= 0) {
                          if(proviceController.text == "" && kabupatenController.text == "" && kabupatenController.text == ""){
                            Get.snackbar("Gagal", "Mohon isi semua terlebih dahulu form area pada step 1", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                          }else{
                            _index.value += 1;
                            if(_index.value == 1){
                              wilayahController.getProgram();
                            }
                          }
                        }
                      },
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.arrow_forward_rounded, color: CupertinoColors.white),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(right: 8, left: 15),
                        backgroundColor: CupertinoColors.activeGreen
                      ),
                      label: const Text('Lanjut', style: TextStyle(color: CupertinoColors.white)),
                    ),
                ],
              ),
          );
        },
        currentStep: _index.value,
        onStepTapped: (int index) {
          if(proviceController.text == "" && kabupatenController.text == "" && kabupatenController.text == ""){
            Get.snackbar("Gagal", "Mohon isi semua terlebih dahulu form area pada step 1", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
          }else{
            _index.value = index;
          }
        },
        steps: <Step>[
          Step(
            isActive: _index.value > 0 ? true : false,
            subtitle: const Text("Pilih Area dan Lokasi"),
            title: const Text('Step 1 '),
            content: boxView(
              list: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: dropdownPickerWilayahArea(name: "Pilih Wilayah/Area", enable: true)),
                    const SizedBox(width: 5.0),
                    Expanded(
                      child: SizedBox(
                        height: 35,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field tidak boleh kosong';
                            }
                            return null;
                          },
                          controller: proviceController,
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: "Input Provinsi",
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12, width: 0.1)),
                          ),
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      ),
                    ),
                    // Expanded(child: dropdownPickerProvinsi(name: "Pilih Provinsi", enable: wilayahController.wilayahModels.value != null ? true : false)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 35,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field tidak boleh kosong';
                            }
                            return null;
                          },
                          controller: kabupatenController,
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: "Input Kabupaten",
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12, width: 0.1)),
                          ),
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Expanded(
                      child: SizedBox(
                        height: 35,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field tidak boleh kosong';
                            }
                            return null;
                          },
                          controller: kecamatanController,
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: "Input Kecamatan",
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12, width: 0.1)),
                          ),
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      ),
                    ),
                    // Expanded(child: Obx(() => dropdownPickerKabupaten(name: "Pilih Kabupaten", enable: selectedProvinsiString.value != "" ? true : false))),
                    // Expanded(child: Obx(() => dropdownPickerKecamatan(name: "Pilih Kecamatan", enable: selectedKabupatenString.value != "" ? true : false)))
                  ],
                ),
              ],
            )
          ),
          Step(
            subtitle: const Text("Detail Donatur"),
            title: const Text('Step 2'),
            content: boxView(
              list: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: dropdownPickerProgram(name: "Pilih Program", enable: proviceController.text != "" ? true : false)),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(" Kode ASB", style: TextStyle(fontSize: 14, color: Colors.black38)),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 36,
                          child: TextField(
                            controller: kodeASB,
                            keyboardType: TextInputType.name,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              // prefix: const Text("ASB"),
                              hintText: "Tulis Kode Donatur",
                              hintStyle: const TextStyle(color: Colors.black26),
                              contentPadding: const EdgeInsets.all(5),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              )
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(" Nama Lengkap", style: TextStyle(fontSize: 14, color: Colors.black38)),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 36,
                          child: TextField(
                            controller: namaLengkap,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Masukkan Nama",
                              hintStyle: const TextStyle(color: Colors.black26),
                              contentPadding: const EdgeInsets.all(5),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              )
                            ),
                          ),
                        ),
                      ],
                    )),
                    Expanded(child: Obx(() => isLoading.value ? const SizedBox() : showMenuData(enable: true, onPressed: (){showActionSheet(context, title: "Gender", message: "Pilih Gender", listMenu: [
                      CupertinoActionSheetAction(onPressed: (){selectedGenderString.value = "Laki-laki"; Navigator.pop(context);}, child: const Text("Laki-laki")),
                      CupertinoActionSheetAction(onPressed: (){selectedGenderString.value = "Perempuan"; Navigator.pop(context);}, child: const Text("Perempuan")),
                      CupertinoActionSheetAction(isDestructiveAction: true, onPressed: (){Navigator.pop(context);}, child: const Text("Cancel")),
                    ]);})))
                  ],
                ),
      
                const SizedBox(height: 5),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(" Usia", style: TextStyle(fontSize: 14, color: Colors.black38)),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 36,
                          child: TextField(
                            controller: usia,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Masukkan Usia",
                              hintStyle: const TextStyle(color: Colors.black26),
                              contentPadding: const EdgeInsets.all(5),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              )
                            ),
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(width: 3),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(" Nomor HP", style: TextStyle(fontSize: 14, color: Colors.black38)),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 36,
                          child: TextField(
                            controller: phone,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Masukkan Nomor HP",
                              hintStyle: const TextStyle(color: Colors.black26),
                              contentPadding: const EdgeInsets.all(5),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              )
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),  
      
                const SizedBox(height: 5),
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(" Alamat Lengkap", style: TextStyle(fontSize: 14, color: Colors.black38)),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 36,
                          child: TextField(
                            controller: alamat,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Masukkan Alamat",
                              hintStyle: const TextStyle(color: Colors.black26),
                              contentPadding: const EdgeInsets.all(5),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              )
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
      
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(" Latitude", style: TextStyle(fontSize: 14, color: Colors.black38)),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 36,
                          child: TextField(
                            controller: lat,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Masukkan Latitude",
                              hintStyle: const TextStyle(color: Colors.black26),
                              contentPadding: const EdgeInsets.all(5),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              )
                            ),
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(width: 3),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(" Longitude", style: TextStyle(fontSize: 14, color: Colors.black38)),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 36,
                          child: TextField(
                            controller: long,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Masukkan Longitude",
                              hintStyle: const TextStyle(color: Colors.black26),
                              contentPadding: const EdgeInsets.all(5),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(5),
                              )
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),

                const SizedBox(height: 15),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Pilih melalui Map", style: TextStyle(fontSize: 14, color: Colors.black38)),
                  ],
                ),
                const SizedBox(height: 5),
                // Latitude & Longitude from Map Selector
                Container(
                  height: size.width / 1.2,
                  color: Colors.transparent,
                  child: Obx(() => isLoading.value ? const SizedBox() : FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                      initialCenter: LatLng(locationController.myLatitude.value, locationController.myLongitude.value), //?? LatLng(widget.latitude, widget.longitude),
                      initialZoom: 8,
                      onTap: (tapPosition, point) {
                        latitudeSelected.value = point.latitude;
                        longitudeSelected.value = point.longitude;
                        lat.text = latitudeSelected.value.toString();
                        long.text = longitudeSelected.value.toString();
                        locationController.getAddressFromCoordinates(latitude: latitudeSelected.value, longitude: longitudeSelected.value).then((result) => alamat.text = result);
                      },
                    ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.asb.app',
                          maxNativeZoom: 19,
                          retinaMode: true,
                        ),
                        MarkerLayer(
                          rotate: true,
                          markers: [
                            Marker(point: LatLng(latitudeSelected.value, longitudeSelected.value), 
                              child: const Icon(CupertinoIcons.map_pin, color: GlobalVariable.secondaryColor)
                            )
                          ]
                        )
                      ]
                    ),
                  ),
                )
              ]
            ),
          ),
        ],
      ),
    );
  }

  Container boxView({List<Widget>? list}){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: list!
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
    
  Obx dropdownPickerWilayahArea({String? name, bool? enable}){
    RxList<String> listData = <String>['Cari Rute'].obs;
    return Obx(() => CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isLoading.value ? (){} : enable == false ? null : () => 
        _showDialog(
          CupertinoPicker(
            magnification: 1.5,
            squeeze: 1.3,
            useMagnifier: true,
            itemExtent: 25,
            scrollController: FixedExtentScrollController(
              initialItem: selectedWilayahIndex.value,
            ),
            onSelectedItemChanged: (int selectedItem) {
              selectedWilayahIndex.value = selectedItem;
              if(wilayahController.wilayahModels.value != null){
                selectedWilayahString.value = wilayahController.wilayahModels.value!.data[selectedItem].nama;
                selectedWilayahID.value = wilayahController.wilayahModels.value!.data[selectedItem].id;
                // if(kDebugMode) print("Ini hasil selected => ${selectedWilayahString.value} dan ${selectedWilayahID.value}");
              }
            },
            children: wilayahController.wilayahModels.value != null ? wilayahController.wilayahModels.value!.data.map((name) => Text(name.nama)).toList() : [Text(listData[0])],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(" Wilayah/Area", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Obx(() => Text(wilayahController.wilayahModels.value != null ? wilayahController.wilayahModels.value!.data[selectedWilayahIndex.value].nama : listData[0]))),
                  const Icon(Icons.keyboard_arrow_down_rounded)
                ],
              ),
            ),
          ],
        ),
      ),);
    }
  
  // DropDown untuk pilihan lokasi Provinsi
  Obx dropdownPickerProvinsi({String? name, bool? enable}){
    RxList<String> listData = <String>['Cari Provinsi'].obs;
    return Obx(() => CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isLoading.value ? (){} : enable == false ? null : () => _showDialog(
          CupertinoPicker(
            magnification: 1.5,
            squeeze: 1.3,
            useMagnifier: true,
            itemExtent: 25,
            scrollController: FixedExtentScrollController(
              initialItem: selectedProvinceIndex.value,
            ),
            onSelectedItemChanged: (int selectedItem) {
              selectedProvinceIndex.value = selectedItem;
              if(wilayahController.provinceModels.value != null){
                selectedProvinsiString.value = wilayahController.provinceModels.value!.rajaongkir.results[selectedItem].province;
                selectedProvinsiID.value = wilayahController.provinceModels.value!.rajaongkir.results[selectedItem].provinceId;
                // if(kDebugMode) print("Ini hasil selected => ${selectedProvinsiString.value} dan ${selectedProvinsiID.value}");
                wilayahController.getKabupaten(idProvince: selectedProvinsiID.value).then((result){
                  if(result) print("Success Get Kabupaten Data");
                });
              }
            },
            children: wilayahController.provinceModels.value != null ? wilayahController.provinceModels.value!.rajaongkir.results.map((name) => Text(name.province)).toList() : [Text(listData[0])],
          ),
        ), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(" Provinsi", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Obx(() => Text(wilayahController.provinceModels.value != null ? wilayahController.provinceModels.value!.rajaongkir.results[selectedProvinceIndex.value].province : listData[0]))),
                  const Icon(Icons.keyboard_arrow_down_rounded)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Obx dropdownPickerProvinsi({String? name, bool? enable}){
  //   return Obx(() => Column(
  //     children: [
  //       Text("Provinsi"),
  //       DropdownButton(
  //         padding: EdgeInsets.zero,
  //         underline: const SizedBox(),
  //         value: selectedProvinsiString.value,
  //         borderRadius: BorderRadius.circular(10.0),
  //         items: List.generate(wilayahController.provinceModels.value?.rajaongkir.results.length ?? 0, (i){
  //           return DropdownMenuItem(value: wilayahController.provinceModels.value?.rajaongkir.results[i].province ?? "-", child: Text(wilayahController.provinceModels.value?.rajaongkir.results[i].province ?? "-"));
  //         }),
  //         onChanged: (value) {
  //           selectedProvinceIndex(wilayahController.provinceModels.value?.rajaongkir.results.indexWhere((model) => model.province == value));
  //           selectedProvinsiID.value = wilayahController.provinceModels.value!.rajaongkir.results[selectedProvinceIndex.value].provinceId;
  //           wilayahController.getKabupaten(idProvince: selectedProvinsiID.value).then((result){
  //             if(result) print("Success Get Kabupaten Data");
  //           });
  //         },
  //       ),
  //     ],
  //   ));
  // }

  // DropDown untuk pilihan lokasi Kabupaten
  Obx dropdownPickerKabupaten({String? name, bool? enable}){
    RxList<String> listData = <String>['Cari Kabupaten'].obs;
    return Obx(() => CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isLoading.value ? (){} : enable == false ? null : () => _showDialog(
          CupertinoPicker(
            magnification: 1.5,
            squeeze: 1.3,
            useMagnifier: true,
            itemExtent: 25,
            scrollController: FixedExtentScrollController(
              initialItem: selectedKabupatenIndex.value,
            ),
            onSelectedItemChanged: (int selectedItem) {
              selectedKabupatenIndex.value = selectedItem;
              if(wilayahController.kabupatenModels.value != null){
                selectedKabupatenString.value = wilayahController.kabupatenModels.value!.rajaongkir.results[selectedItem].cityName;
                selectedKabupatenID.value = wilayahController.kabupatenModels.value!.rajaongkir.results[selectedItem].cityId;
                // if(kDebugMode) print("Ini hasil selected Kabupaten => ${selectedProvinsiString.value} dan ${selectedProvinsiID.value}");
                wilayahController.getKecamatan(idKabupaten: selectedKabupatenID.value, idProvince: selectedProvinsiID.value);
              }
            },
            children: wilayahController.kabupatenModels.value != null ? wilayahController.kabupatenModels.value!.rajaongkir.results.map((name) => Text(name.cityName)).toList() : [Text(listData[0])],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(" Kabupaten", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Obx(() => Text(wilayahController.kabupatenModels.value != null ? wilayahController.kabupatenModels.value!.rajaongkir.results[selectedKabupatenIndex.value].cityName : listData[0]))),
                  const Icon(Icons.keyboard_arrow_down_rounded)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // DropDown untuk pilihan lokasi Kabupaten
  Obx dropdownPickerKecamatan({String? name, bool? enable}){
    RxList<String> listData = <String>['Cari Kecamatan'].obs;
    return Obx(() => CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isLoading.value ? (){} : enable == false ? null : () => _showDialog(
          CupertinoPicker(
            magnification: 1.5,
            squeeze: 1.3,
            useMagnifier: true,
            itemExtent: 25,
            scrollController: FixedExtentScrollController(
              initialItem: selectedKecamatanIndex.value,
            ),
            onSelectedItemChanged: (int selectedItem) {
              selectedKecamatanIndex.value = selectedItem;
              if(wilayahController.kecamatanModels.value != null){
                selectedKecamatanString.value = wilayahController.kecamatanModels.value!.rajaongkir.results[selectedItem].subdistrictName;
              }
            },
            children: wilayahController.kecamatanModels.value != null ? wilayahController.kecamatanModels.value!.rajaongkir.results.map((name) => Text(name.subdistrictName)).toList() : [Text(listData[0])],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(" Kecamatan", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Obx(() => Text(wilayahController.kecamatanModels.value != null ? wilayahController.kecamatanModels.value!.rajaongkir.results[selectedKecamatanIndex.value].subdistrictName : listData[0]))),
                  const Icon(Icons.keyboard_arrow_down_rounded)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DropDown untuk pilihan daftar Program
  Obx dropdownPickerProgram({String? name, bool? enable}){
    RxList<String> listData = <String>['Cari Program'].obs;
    return Obx(() => CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isLoading.value ? (){} : enable == false ? null : () => _showDialog(
          CupertinoPicker(
            magnification: 1.5,
            squeeze: 1.3,
            useMagnifier: true,
            itemExtent: 25,
            scrollController: FixedExtentScrollController(
              initialItem: selectedProgramIndex.value,
            ),
            onSelectedItemChanged: (int selectedItem) {
              selectedProgramIndex.value = selectedItem;
              if(wilayahController.daftarProgram.value != null){
                selectedProgramString.value = wilayahController.daftarProgram.value!.data[selectedItem].nama;
                selectedProgramID.value = wilayahController.daftarProgram.value!.data[selectedItem].id;
              }
            },
            children: wilayahController.daftarProgram.value != null ? wilayahController.daftarProgram.value!.data.map((name) => Text(name.nama)).toList() : [Text(listData[0])],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(" Program", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Obx(() => Text(wilayahController.daftarProgram.value != null ? wilayahController.daftarProgram.value!.data[selectedProgramIndex.value].nama : listData[0]))),
                  const Icon(Icons.keyboard_arrow_down_rounded)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Gender String
  CupertinoButton showMenuData({Function()? onPressed, bool? enable}){
    return CupertinoButton(
      onPressed: enable != null || enable == true ? onPressed : null,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(" Gender", style: TextStyle(fontSize: 14)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(5)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Obx(() => Text(selectedGenderString.value == '' ? "Pilih Gender" : selectedGenderString.value))),
                const Icon(Icons.keyboard_arrow_down_rounded)
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showActionSheet(BuildContext context, {String? title, String? message, List<CupertinoActionSheetAction>? listMenu}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(title ?? 'Title'),
        message: Text(message ?? 'Message'),
        actions: listMenu
      ),
    );
  }
}
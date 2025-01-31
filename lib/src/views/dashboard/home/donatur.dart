import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/wilayah/wilayah_controller.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/tambah_page_donatur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DonaturPage extends StatefulWidget {
  const DonaturPage({super.key});

  @override
  State<DonaturPage> createState() => _DonaturPageState();
}

class _DonaturPageState extends State<DonaturPage> {
  final ScrollController _firstController = ScrollController();
  WilayahController wilayahController = Get.put(WilayahController());
  RxString wilayahID = ''.obs;
  int _selectedFruit = 0;
  double kItemExtent = 25;
  List<String> fruitNames = <String>[
    'Apple',
    'Mango',
    'Banana',
    'Orange',
    'Pineapple',
    'Strawberry',
  ];

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

  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource;

  @override
  void initState() {
    super.initState();
    wilayahController.getWilayah().then((result){
      if(result){
        fruitNames = [];
        for(int i = 0; i<wilayahController.wilayahModels.value!.data.length; i++){
          fruitNames.add(wilayahController.wilayahModels.value!.data[i].nama);
        }
        wilayahID.value = wilayahController.wilayahModels.value!.data[0].id;
        wilayahController.getDonaturByWilayahID(wilayahID: wilayahID.value).then((value){
          if(!result){
            Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: Colors.red, colorText: Colors.white);
          }
        });
      }else{
        Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: Colors.red, colorText: Colors.white);
      }
    });
    employees = getEmployeeData();
    employeeDataSource = EmployeeDataSource(employeeData: employees);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              height: 35,
              child: Obx(() => ElevatedButton.icon(
                onPressed: wilayahController.isLoading.value ? null : (){
                  Get.to(() => const TambahDonaturPage());
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: GlobalVariable.secondaryColor,
                  elevation: 0
                ),
                label: const Text("Tambah", style: TextStyle(color: Colors.white)),
                icon: const Icon(Icons.add, color: Colors.white), 
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: RawScrollbar(
            thumbVisibility: true,
            thickness: 15,
            radius: const Radius.circular(10),
            controller: _firstController,
            child: ListView(
              controller: _firstController,
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 0.5),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Pilih Wilayah/Rute: '),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => _showDialog(
                          CupertinoPicker(
                            magnification: 1.5,
                            squeeze: 1.3,
                            useMagnifier: true,
                            itemExtent: kItemExtent,
                            scrollController: FixedExtentScrollController(
                              initialItem: _selectedFruit,
                            ),
                            onSelectedItemChanged: (int selectedItem) {
                              setState(() {
                                _selectedFruit = selectedItem;
                              });
                            },
                            children:
                                List<Widget>.generate(fruitNames.length, (int index) {
                              return Center(child: Text(fruitNames[index]));
                            }),
                          ),
                        ),
                        child: Text(fruitNames[_selectedFruit], style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
          
                SizedBox(
                  height: size.height / 2,
                  child: SfDataGrid(
                    allowSorting: true,
                    sortingGestureType: SortingGestureType.tap,
                    source: employeeDataSource,
                    frozenColumnsCount: 1,
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: 'id',
                        label: Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.center,
                          child: const Text('Kode', style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      ),
                      GridColumn(
                        columnName: 'name',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Nama', style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      ),
                      GridColumn(
                        columnName: 'jk',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('JK', overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      ),
                      GridColumn(
                        columnName: 'usia',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Usia', style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      ),
                      GridColumn(
                        columnName: 'nohp',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('No HP', style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      ),
                          
                      GridColumn(
                        columnName: 'alamat',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Alamat', style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      ),
                      GridColumn(
                        columnName: 'kecamatan',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Kecamatan', style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      ),
                          
                      GridColumn(
                        columnName: 'kota',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Kota', style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      ),
                      GridColumn(
                        columnName: 'foto_lokasi',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Foto Lokasi', style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      ),
                          
                      GridColumn(
                        columnName: 'link_gmap',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Link GMaps', style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      ),
                      GridColumn(
                        columnName: 'program',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Program', style: TextStyle(fontWeight: FontWeight.bold))
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Employee> getEmployeeData({int? length = 0, String? id, String? name, String? jk, String? usia}) {
    return List.generate(5, (i) => Employee(id: 1000+i+1, name: 'James$i', jk: 'Project Lead', usia: 20000, nohp: "Hello", alamat: "alamat", kecamatan: "kecamatan", kota: "alamat", fotoLokasi: "kecamatan", linkGmap: "alamat", program: "kecamatan"));
  }
}


class Employee {
  Employee({this.id, this.name, this.jk, this.usia, this.nohp, this.alamat, this.kecamatan, this.kota, this.fotoLokasi, this.linkGmap, this.program});
  final int? id;
  final String? name;
  final String? jk;
  final int? usia;
  final String? nohp;
  final String? alamat;
  final String? kecamatan;
  final String? kota;
  final String? fotoLokasi;
  final String? linkGmap;
  final String? program;
}

class EmployeeDataSource extends DataGridSource {
  
  EmployeeDataSource({required List<Employee> employeeData}) {
    _employeeData = employeeData.map<DataGridRow>((e) => DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'id', value: e.id),
        DataGridCell<String>(columnName: 'name', value: e.name),
        DataGridCell<String>(columnName: 'jk', value: e.jk),
        DataGridCell<int>(columnName: 'usia', value: e.usia),
        DataGridCell<String>(columnName: 'nohp', value: e.nohp),
        DataGridCell<String>(columnName: 'alamat', value: e.alamat),
        DataGridCell<String>(columnName: 'kecamatan', value: e.kecamatan),
        DataGridCell<String>(columnName: 'kota', value: e.kota),
        DataGridCell<String>(columnName: 'foto_lokasi', value: e.fotoLokasi),
        DataGridCell<String>(columnName: 'link_gmap', value: e.linkGmap),
        DataGridCell<String>(columnName: 'program', value: e.program),
      ]))
    .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

   @override
  Widget? buildGroupCaptionCellWidget(
      RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Text(summaryValue));
  }
}

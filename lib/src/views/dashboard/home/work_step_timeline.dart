import 'package:auto_size_text/auto_size_text.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/views/dashboard/home/timeline_editor.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelines_plus/timelines_plus.dart';

const kTileHeight = 50.0;

class PackageDeliveryTrackingPage extends StatelessWidget {
  PackageDeliveryTrackingPage({super.key});
  
  final globalVariable = GlobalVariable();
  final textstyle = GlobalTextStyle();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Time Line"),
        forceMaterialTransparency: true,
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(Icons.add_circle, color: GlobalVariable.secondaryColor), 
            onPressed: (){
              Get.to(() => const TimelineEditor());
            }
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.delete_solid, color: GlobalVariable.secondaryColor), 
            onPressed: (){}
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(size.width / 3.5), 
          child: Column(
            children: [
              EasyDateTimeLine(
                initialDate: DateTime.now(),
                onDateChange: (selectedDate) {
                  //`selectedDate` the new date selected.
                },
                activeColor: const Color(0xff85A389),
                dayProps: const EasyDayProps(
                  borderColor: Colors.black38,
                  dayStructure: DayStructure.dayStrDayNumMonth,
                  activeDayStyle: DayStyle(borderRadius: 100),
                  inactiveDayStyle: DayStyle(borderRadius: 100),
                  todayStyle: DayStyle(borderRadius: 100),
                  height: 65,
                  width: 65,
                  todayHighlightStyle: TodayHighlightStyle.withBackground,
                  todayHighlightColor: Color(0xffE1ECC8),
                ),
              ),
              const Divider()
            ],
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: List.generate(dataJson.length, (i){
              return GestureDetector(
                onLongPress: () {
                  _showAlertDialog(context, title: dataJson[i]['nama_bagian']);
                },
                child: CupertinoButton(
                  onPressed: (){},
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(color: Colors.black12)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                '${dataJson[i]['nama_bagian']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              dataJson[i]['date'],
                              style: const TextStyle(
                                color: Color(0xffb6b2b2),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 10),
                          
                        // Body Timeline
                        FixedTimeline.tileBuilder(
                          theme: TimelineThemeData(
                            nodePosition: 0,
                            color: const Color(0xff989898),
                            indicatorTheme: const IndicatorThemeData(
                              position: 0,
                              size: 20.0,
                            ),
                            connectorTheme: const ConnectorThemeData(
                              thickness: 2.5,
                            ),
                          ),
                          builder: TimelineTileBuilder.connected(
                            itemCount: dataJson[i]['proses_utama'].length,
                            contentsBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if(dataJson[i]['proses_utama'][index]['proses_selesai'])
                                      Text(dataJson[i]['proses_utama'][index]['nama_proses'], style: DefaultTextStyle.of(context).style.copyWith(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.green.shade400))
                                    else
                                      Text(dataJson[i]['proses_utama'][index]['nama_proses'], style: DefaultTextStyle.of(context).style.copyWith(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.grey)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: FixedTimeline.tileBuilder(
                                        theme: TimelineTheme.of(context).copyWith(
                                          nodePosition: 0,
                                          connectorTheme: ConnectorThemeData(color: Colors.green.shade100),
                                          indicatorTheme: IndicatorThemeData(color: Colors.green.shade200),
                                        ),
                                        builder: TimelineTileBuilder.connectedFromStyle(
                                          contentsAlign: ContentsAlign.basic,
                                          connectorStyleBuilder: (context, indexJ) {
                                            if(dataJson[i]['proses_utama'][index]['sub_proses'][indexJ]['proses_selesai']){
                                              return ConnectorStyle.solidLine;
                                            }
                                            return ConnectorStyle.dashedLine;
                                          },
                                          indicatorStyleBuilder: (context, indexJ){
                                            if(dataJson[i]['proses_utama'][index]['sub_proses'][indexJ]['proses_selesai']){
                                              return IndicatorStyle.dot;
                                            }
                                            return IndicatorStyle.outlined;
                                          },
                                          firstConnectorStyle: ConnectorStyle.transparent,
                                          lastConnectorStyle: ConnectorStyle.transparent,
                                          contentsBuilder: (context, indexJ){
                                            if(dataJson[i]['proses_utama'][index]['sub_proses'][indexJ]['proses_selesai']){
                                              return Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Text('Pukul ${dataJson[i]['proses_utama'][index]['sub_proses'][indexJ]['start_proses']} : ${dataJson[i]['proses_utama'][index]['sub_proses'][indexJ]['nama_proses']}', style: textstyle.defaultTextStyleMedium(color: Colors.green), maxLines: 3)
                                            );
                                            }
                                            return Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Text('Pukul ${dataJson[i]['proses_utama'][index]['sub_proses'][indexJ]['start_proses']} : ${dataJson[i]['proses_utama'][index]['sub_proses'][indexJ]['nama_proses']}', style: textstyle.defaultTextStyleMedium(color: Colors.grey), maxLines: 3)
                                            );
                                          },
                                          itemCount: dataJson[i]['proses_utama'][index]['sub_proses'].length
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          
                            indicatorBuilder: (context, index) {
                              if(dataJson[i]['proses_utama'][index]["proses_selesai"]){
                                return DotIndicator(
                                  color: Colors.green.shade200,
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12.0,
                                  ),
                                );
                              }
                              return OutlinedDotIndicator(
                                color: Colors.grey.shade200,
                              );
                            },
                          
                            connectorBuilder: (context, index, type) {
                              if(dataJson[i]['proses_utama'][index]["proses_selesai"]){
                                return DashedLineConnector(
                                color: Colors.green.shade200
                              );
                              }
                              return SolidLineConnector(
                                color: Colors.grey.shade200,
                              );
                            },
                          ),
                        ),
                
                        const Divider(),
                        Row(
                          children: [
                            CircleAvatar(backgroundImage: NetworkImage(dataJson[i]['pic']['profile_picture'])),
                            const SizedBox(width: 10),
                            Text(dataJson[i]['pic']['name'], style: textstyle.defaultTextStyleBold(color: Colors.black54)),
                          ],
                        )
                      ],
                    )
                  ),
                ),
              );
            }),
          ),
        ),
      )
    );
  }

  void _showAlertDialog(BuildContext context, {String? title}) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Hapus'),
        content: Text('Apakah anda ingin menghapus item $title?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tidak'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }
}

List dataJson = [
  {
    "id" : 1,
    "nama_bagian" : "Informa Zoe Set Meja Makan 4 Bangku",
    "date" : "2024-11-04",
    "pic" : {
      "name" : "Divisi Meja",
      "profile_picture" : "https://i.pinimg.com/originals/08/45/81/084581e3155d339376bf1d0e17979dc6.jpg"
    },
    "proses_utama" : [
      {
        "nama_proses" : "Pemotongan Bahan",
        "proses_selesai" : true,
        "sub_proses"  : [
          {
            "start_proses" : "2024-12-03 12:12:00",
            "proses_selesai" : true,
            "nama_proses"  : "Start proses penurunan bahan dari gudang sebanyak 50 batang besi"
          },
          {
            "start_proses" : "2024-12-03 12:12:00",
            "proses_selesai" : true,
            "nama_proses"  : "Start pemotongan Bahan dengan gerinda menjadi 250 potong"
          },
          {
            "start_proses" : "2024-12-03 12:12:00",
            "proses_selesai" : true,
            "nama_proses"  : "Pemotongan Selesai"
          }
        ]
      },
      {
        "nama_proses" : "Pengecatan",
        "proses_selesai" : false,
        "sub_proses"  : [
          {
            "start_proses" : "2024-12-03 12:12:00",
            "proses_selesai" : true,
            "nama_proses"  : "Start proses pengecatan bahan dari gudang sebanyak 250 potong besi"
          },
          {
            "start_proses" : "2024-12-03 12:12:00",
            "proses_selesai" : true,
            "nama_proses"  : "Start pemotongan Bahan dengan gerinda menjadi 250 potong"
          },
          {
            "start_proses" : "2024-12-03 12:12:00",
            "proses_selesai" : false,
            "nama_proses"  : "Pemotongan Selesai"
          }
        ]
      },
      {
        "nama_proses" : "Finishing",
        "proses_selesai" : false,
        "sub_proses"  : [
          {
            "start_proses" : "2024-12-03 12:12:00",
            "proses_selesai" : false,
            "nama_proses"  : "Start proses pengecatan bahan dari gudang sebanyak 250 potong besi"
          },
          {
            "start_proses" : "2024-12-03 12:12:00",
            "proses_selesai" : false,
            "nama_proses"  : "Start pemotongan Bahan dengan gerinda menjadi 250 potong"
          },
          {
            "start_proses" : "2024-12-03 12:12:00",
            "proses_selesai" : false,
            "nama_proses"  : "Pemotongan Selesai"
          }
        ]
      }
    ]
  }
];
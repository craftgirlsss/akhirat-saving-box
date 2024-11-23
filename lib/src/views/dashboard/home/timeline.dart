import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/controllers/utilities/timeline_controller.dart';
import 'package:asb_app/src/views/dashboard/home/timeline_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class TimeLine extends StatefulWidget {
  const TimeLine({super.key});

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  final globalVariable = GlobalVariable();
  final globalTextStyle = GlobalTextStyle();
  TimelineController controller = Get.put(TimelineController());
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GlobalVariable.backgroundColor,
      appBar: AppBar(
        title: Text("Daftar Pekerjaan", style: globalTextStyle.defaultTextStyleBold(fontSize: 17)),
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Obx(() => controller.isLoading.value ? SizedBox(
          width: size.width,
          height: size.height,
          child: Shimmer.fromColors(
            baseColor: Colors.red,
            highlightColor: Colors.yellow,
            child: const Text(
              'Shimmer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),
        ) : controller.daftarPekerjaan.isEmpty ? Center(
        child: Container(
          color: Colors.transparent,
          width: size.width,
          height: size.height / 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: (){
                  Get.to(() => const TimelineEditor());
                },
                child: Image.network("https://cdn.icon-icons.com/icons2/522/PNG/512/data-add_icon-icons.com_52370.png", width: size.width / 4)),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text("Tidak ada pekerjaan ditambahkan", style: globalTextStyle.defaultTextStyleBold(fontSize: 13, color: Colors.black54), textAlign: TextAlign.center),
              )
            ],
          ),
        ),
      ) : StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: List.generate(controller.daftarPekerjaan.length, (i) {
                return StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: i.isEven ? 2 : 1,
                  child: CupertinoContextMenu(
                    enableHapticFeedback: true,
                    actions: [
                      CupertinoContextMenuAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        trailingIcon: CupertinoIcons.heart,
                        child: const Text('Favorite'),
                      ),
                      CupertinoContextMenuAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        isDestructiveAction: true,
                        trailingIcon: CupertinoIcons.delete,
                        child: const Text('Delete'),
                      ),
                    ],
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: (){},
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: size.width / 2,
                          minHeight: size.width / 2,
                        ),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: getRandomColor(),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)]
                        ),
                        child: Center(child: Text(controller.daftarPekerjaan[i].namaPekerjaan ?? "Tidak ada nama pekerjaan", style: globalTextStyle.defaultTextStyleBold(fontSize: 17, color: Colors.white, withShadow: true), textAlign: TextAlign.center, maxLines: 3))
                      ),
                    ),
                  ),
                );
              })
            ),
          ),
        ),
    );
  }

  Color getRandomColor(){
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.85);
  }
}
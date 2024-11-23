import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  existsInTrashCan(Course course) => trashCan.contains(course);
  List<Course> trashCan = [];
  final globalVariable = GlobalVariable();
  final textstyle = GlobalTextStyle();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        actions: [
          trashCan.isEmpty ? Container() : CupertinoButton(
            child: const Icon(CupertinoIcons.trash, color: Colors.black54), 
            onPressed: (){
              coursesData.removeWhere((item) => trashCan.contains(item));
              trashCan.clear();
              setState(() {});
            }
          )
        ],
        actionsIconTheme: const IconThemeData(
          color: Colors.white
        ),
        title: const Text("Notifikasi"),
      ),
      body: coursesData.isEmpty ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network("https://cdn3d.iconscout.com/3d/premium/thumb/no-notification-3d-illustration-download-in-png-blend-fbx-gltf-file-formats--empty-state-page-new-mail-pack-seo-web-illustrations-4468821.png", width: size.width / 2, height: size.width / 2),
            Text("Tidak ada notifikasi", style: textstyle.defaultTextStyleBold())
          ],
        )
      ) : ListView(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: coursesData.length,
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemBuilder: (BuildContext context, int index) {
              return PrettyCard(
                name: coursesData[index].name,
                isSelected: existsInTrashCan(coursesData[index]),
                trashCan: trashCan,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Single Tap!'),
                    duration: Duration(seconds: 1),
                  ));
                },
                onDelete: () {
                  if (trashCan.contains(coursesData[index])) {
                    trashCan.remove(coursesData[index]);
                    setState(() {});
                  } else {
                    trashCan.add(coursesData[index]);
                    setState(() {});
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}



class PrettyCard extends StatelessWidget {
  final String name;
  final bool isSelected;
  final void Function()? onDelete;
  final void Function()? onTap;
  final List trashCan;

  const PrettyCard(
      {super.key,
      required this.name,
      required this.isSelected,
      this.onDelete,
      this.onTap,
      required this.trashCan});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Card(
        surfaceTintColor: isSelected ? Colors.black : null,
        color: Colors.cyan.shade900,
        child: ListTile(
          dense: true,
          selected: isSelected,
          onTap: trashCan.isNotEmpty ? onDelete : onTap,
          onLongPress: onDelete,
          tileColor: Colors.cyan.shade900,
          selectedColor: Colors.white,
          selectedTileColor: Colors.cyan.shade900,
          title: Text(name),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.cyan.shade50,
              width: 3,
              style: isSelected ? BorderStyle.solid : BorderStyle.none)),
        ),
      ),
    );
  }
}

class Course {
  final String id;
  final String name;
  Course({
    required this.id,
    required this.name,
  });
}

List<Course> coursesData = [
  // Course(id: '1', name: 'MTH'),
  // Course(id: '2', name: 'STS'),
  // Course(id: '3', name: 'ACC'),
  // Course(id: '4', name: 'ETH'),
  // Course(id: '5', name: 'PHY'),
  // Course(id: '6', name: 'CSC'),
];
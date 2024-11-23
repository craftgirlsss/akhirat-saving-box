import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/components/utilities/utilities.dart';

class TruckBrandList extends StatefulWidget {
  const TruckBrandList({super.key});

  @override
  State<TruckBrandList> createState() => _TruckBrandListState();
}

class _TruckBrandListState extends State<TruckBrandList> {
  final textStyle = GlobalTextStyle();
  final globalVariable = GlobalVariable();
  final utilities = Utilities();
  final String urlAssetImage = "https://masputra.nextjiesdev.site/assets/mhs";

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text("Pilih Perusahaan Truck", style: textStyle.defaultTextStyleBold(fontSize: 16)),
        ),
        body: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: utilities.cardTitle(title: "List Perusahaan"),
                ),
                GridView.count(
                  shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 20,
                    physics: const BouncingScrollPhysics(),
                    children:[
                      cardItem(urlImage: '$urlAssetImage/dunex.jpeg', priceOff: null, title: "Dunex"),
                      cardItem(urlImage: '$urlAssetImage/indahcargo.png', priceOff: null, title: "Indah Cargo"),
                      cardItem(urlImage: '$urlAssetImage/ironbird.jpeg', priceOff: null, title: "Iron Bird"),
                      cardItem(urlImage: '$urlAssetImage/deloveree.jpeg', priceOff: null, title: "Deliveree"),
                    ]
                ),
              ],
            ),
          ),
        )
    );
  }

  // Container Card Item
  Widget cardItem({int? priceOff, String? urlImage, String? title}){
    final size = MediaQuery.of(context).size;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: (){},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width / 4.3,
              height: size.width / 4.3,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black38, width: 0.3),
                  image: DecorationImage(image: NetworkImage(urlImage ?? ''), fit: BoxFit.contain, onError: (exception, stackTrace) => const Icon(Bootstrap.box, size: 30))
              ),
              child: Stack(
                children: [
                  if(priceOff != null || priceOff == 0)
                    Positioned(
                        left: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: GlobalVariable.secondaryColor
                          ),
                          child: Text("$priceOff% OFF", style: textStyle.defaultTextStyleMedium(color: Colors.white)),
                        )
                    )
                ],
              ),
            ),
            const SizedBox(height: 8),
            AutoSizeText(title ?? "Tidak ada judul", style: textStyle.defaultTextStyleMedium(fontSize: 14))
          ],
        ),
      ),
    );
  }
}

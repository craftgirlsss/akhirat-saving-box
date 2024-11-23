import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/views/dashboard/home/create_invoice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

enum Invoice { unpaid, draft, paid }

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  Invoice invoice = Invoice.unpaid;
  final globalVariable = GlobalVariable();
  final globalTextStyle = GlobalTextStyle();
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
  @override
  Widget build(BuildContext context) {
  // final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 0,
        title: Text("Invoice", style: globalTextStyle.defaultTextStyleBold()),
        actions: [
          CupertinoButton(child: const Icon(Clarity.search_line), onPressed: (){})
        ],
        bottom: PreferredSize(
          preferredSize: preferredSize, 
          child: SegmentedButton<Invoice>(
            segments: const <ButtonSegment<Invoice>>[
              ButtonSegment<Invoice>(
                value: Invoice.unpaid,
                label: Text('Unpaid'),
                icon: Icon(Clarity.cancel_line)
              ),
              ButtonSegment<Invoice>(
                value: Invoice.draft,
                label: Text('Draft'),
                icon: Icon(Icons.drafts_outlined)
              ),
              ButtonSegment<Invoice>(
                value: Invoice.paid,
                label: Text('Paid'),
                icon: Icon(Icons.cloud_done_outlined)
              ),
            ],
            selected: <Invoice>{invoice},
            onSelectionChanged: (Set<Invoice> newSelection) {
              setState(() {
                invoice = newSelection.first;
              });
            },
          )
        ),
      ),
      body: bodyContent(),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){Get.to(() => const CreateInvoice());}, label: const Text("Buat Invoice", style: TextStyle(color: Colors.white)), icon: const Icon(Icons.add, color: Colors.white), backgroundColor: GlobalVariable.secondaryColor, shape: const StadiumBorder()),
    );
  }

  Widget bodyContent(){
    if(invoice == Invoice.unpaid){
      return Column(
        children: [
          bodyUnpaidOverdue(),
          bodyUnpaidSent()
        ],
      );
    }else if(invoice == Invoice.draft){
      return Container();
    }else{
      return Container();
    }
  }


  // ============================ Unpaid Body ============================ //
  ListTile itemListTileOverdue({String? title, String? urlImage, String? subtitle, String? trailing, String? due, Function()? onPressed}){
    return ListTile(
      onTap: onPressed,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(urlImage ?? "https://developer.apple.com/wwdc24/images/motion/axiju/endframe-small_2x.jpg"),
        backgroundColor: Colors.white,
      ),
      title: Text(title ?? "Tidak ada nama transaksi", style: globalTextStyle.defaultTextStyleBold()),
      subtitle: subtitle != null ? Text(subtitle, style: globalTextStyle.defaultTextStyleMedium(color: Colors.black54)) : null,
      trailing: trailing != null ? Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailing, style: globalTextStyle.defaultTextStyleMedium(color: Colors.black, fontSize: 15)),
          Text(due ?? "Due 0 day ago", style: globalTextStyle.defaultTextStyleMedium(color: Colors.red.shade300, fontSize: 13))
        ],
      ) : null,
    );
  }

  ListTile itemListTileSent({String? title, String? urlImage, String? subtitle, String? trailing, String? due, Function()? onPressed}){
    return ListTile(
      onTap: onPressed,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(urlImage ?? "https://developer.apple.com/wwdc24/images/motion/axiju/endframe-small_2x.jpg"),
        backgroundColor: Colors.white,
      ),
      title: Text(title ?? "Tidak ada nama transaksi", style: globalTextStyle.defaultTextStyleBold()),
      subtitle: subtitle != null ? Text(subtitle, style: globalTextStyle.defaultTextStyleMedium(color: Colors.black54)) : null,
      trailing: trailing != null ? Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailing, style: globalTextStyle.defaultTextStyleMedium(color: Colors.black, fontSize: 15)),
          Text(due ?? "Due in 0 day", style: globalTextStyle.defaultTextStyleMedium(color: Colors.black54, fontSize: 13))
        ],
      ) : null,
    );
  }

  Widget bodyUnpaidOverdue(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 0, left: 15, right: 15),
          child: Text("OVERDUE", style: globalTextStyle.defaultTextStyleMedium(fontSize: 18, color: Colors.black54)),
        ),
        SingleChildScrollView(
          child: Column(
            children: List.generate(2, (i) => itemListTileOverdue(title: "Jonathan Ive", subtitle: "Invoice #3203", trailing: "\$304", onPressed: (){})),
          ),
        )
      ],
    );
  }

  Widget bodyUnpaidSent(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 0, left: 15, right: 15),
          child: Text("SENT", style: globalTextStyle.defaultTextStyleMedium(fontSize: 18, color: Colors.black54)),
        ),
        SingleChildScrollView(
          child: Column(
            children: List.generate(2, (i) => itemListTileSent(title: "Jonathan Ive", subtitle: "Invoice #3203", trailing: "\$304", onPressed: (){})),
          ),
        )
      ],
    );
  }
}
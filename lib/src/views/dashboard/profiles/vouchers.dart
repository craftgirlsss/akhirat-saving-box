import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/components/utilities/utilities.dart';

class MyVoucher extends StatefulWidget {
  const MyVoucher({super.key});

  @override
  State<MyVoucher> createState() => _MyVoucherState();
}

class _MyVoucherState extends State<MyVoucher> {
  final textStyle = GlobalTextStyle();
  final globalVariable = GlobalVariable();
  final utilities = Utilities();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: GlobalVariable.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Voucherku", style: textStyle.defaultTextStyleBold()),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: (){},
            child: const Icon(CupertinoIcons.trash, size: 22, color: GlobalVariable.secondaryColor),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              utilities.couponCard(context, onPressed: (){}),
              utilities.couponCard(context, onPressed: (){}, color: Colors.greenAccent.shade100),
              utilities.couponCard(context, onPressed: (){}, color: Colors.lightBlueAccent.shade100),
            ]
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context, {String? title, String? content, String? textAccepted, String? textCancel, Function()? onOK}) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? 'Alert'),
        content: Text(content ?? 'Proceed with destructive action?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: onOK ?? () {
              Navigator.pop(context);
            },
            child: Text(textCancel ?? 'No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(textAccepted ?? 'Yes'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:asb_app/src/components/button/rounded_rectangle_button.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textformfield/rounded_rectangle_form_field.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/views/dashboard/profiles/room_chat.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final textStyle = GlobalTextStyle();
  final globalVariable = GlobalVariable();
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController message = TextEditingController();
  bool wasHaveToken = false;
  bool isTokenExpired = false;
  
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    subject.dispose();
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: GlobalVariable.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Talk to us!", style: textStyle.defaultTextStyleBold(fontSize: 17)),
          centerTitle: true,
        ),
        body: wasHaveToken
          ? isTokenExpired
            ? registerFirst(size.width)
            : Container()
          : registerFirst(size.width)
      ),
    );
  }

  Widget registerFirst(double size){
    return SizedBox(
      width: size,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 2)
          ]
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Tinggalkan pesan kepada admin jika anda ingin menanyakan sesuatu dan akan kami balas ke alamat email yang telah anda berikan.", style: textStyle.defaultTextStyleMedium(fontSize: 16), textAlign: TextAlign.center, maxLines: 4),
                CustomTextField(controller: name, label: "Nama Lengkap", keyboardType: TextInputType.name),
                CustomTextField(controller: email, label: "Alamat Email", keyboardType: TextInputType.emailAddress),
                CustomTextField(controller: subject, label: "Subjek"),
                CustomTextField(controller: message, label: "Pesan"),
                const SizedBox(height: 10),
                roundedRectangleButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatsV2()));
                    }else{
                      // print(false);
                    }
                  },
                  size: size,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
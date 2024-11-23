import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/controllers/chat/chat_controller.dart';

// 1 = admin belum membaca pesan
// -1 = admin sudah membaca

class ChatsV2 extends StatefulWidget {
  const ChatsV2({super.key});

  @override
  State<ChatsV2> createState() => _ChatsV2State();
}

class _ChatsV2State extends State<ChatsV2> {
  ChatControllers chatControllers = Get.put(ChatControllers());
  TextEditingController tc = TextEditingController();
  final globalVariable = GlobalVariable();
  final textStyle = GlobalTextStyle();

  @override
  void initState() {
    super.initState();
    chatControllers.getMessage();
  }

  @override
  void dispose() {
    chatControllers.dispose();
    super.dispose();
  }

  addMessage({
    String? content,
    bool? receiver = true,
    DateTime? time
  }){
    if(content == null){
      return;
    }
    messages.add(ChatMessage(content: content, whois: receiver == true ? "receiver" : "sender", time: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        await chatControllers.getMessage();
        setState(() {});
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              // resizeToAvoidBottomInset: false,
              backgroundColor: GlobalVariable.backgroundColor,
              appBar: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.white
                ),
                backgroundColor: GlobalVariable.secondaryColor,
                title: const Text("Help Center", style: TextStyle(color: Colors.white)), centerTitle: true, actions: [
                IconButton(
                    tooltip: "Refresh",
                    onPressed: (){
                      chatControllers.getMessage();
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white)
                )
              ]),
              body: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    reverse: true,
                    child: Obx(
                          () => chatControllers.chatModels.value?.response.length != 0 ? RefreshIndicator(
                        onRefresh: ()async{
                          chatControllers.getMessage();
                          setState(() {});
                        },
                        child: ListView.builder(
                          addAutomaticKeepAlives: true, // Add this property
                          cacheExtent: double.infinity,
                          itemCount: chatControllers.chatModels.value?.response.length ?? 0,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 10,bottom: 70),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                            return Container(
                              padding: const EdgeInsets.only(left: 14,right: 14,top: 0,bottom: 10),
                              child: Align(
                                alignment: (chatControllers.chatModels.value?.response[index].msgType == "receiver" ? Alignment.topLeft : Alignment.topRight),
                                child: Container(
                                  constraints: const BoxConstraints(minWidth: 80, maxWidth: 220),
                                  decoration: BoxDecoration(
                                    color: (chatControllers.chatModels.value?.response[index].msgType  == "receiver" ? Colors.grey.shade200 : GlobalVariable.secondaryColor),
                                    borderRadius: chatControllers.chatModels.value?.response[index].msgType == "receiver" ?  const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20)
                                    ) : const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: chatControllers.chatModels.value?.response[index].msgType == "receiver" ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                    children: [
                                      Text(chatControllers.chatModels.value?.response[index].content ?? '', style: textStyle.defaultTextStyle(fontSize: 14, color: Colors.black),),
                                      Text(DateFormat("dd-MM-yyyy").add_jm().format(DateTime.parse(chatControllers.chatModels.value?.response[index].datetime ?? '2024-01-01')),
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic, fontSize: 9,
                                            color: Colors.black54
                                        ),)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ) : Container(
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 80,
                        child : Center(
                          child: Text("No chats available", style: textStyle.defaultTextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
                      height: 60,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.white12)),
                        color: GlobalVariable.secondaryColor,
                      ),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: null,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: GlobalVariable.secondaryColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(EvaIcons.image, color: Colors.white, size: 30),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: size.width,
                                maxWidth: size.width,
                                minHeight: 25.0,
                                maxHeight: 205.0,
                              ),
                              child: Scrollbar(
                                child: TextField(
                                  style: textStyle.defaultTextStyle(fontSize: 15, color: Colors.white),
                                  cursorColor: GlobalVariable.secondaryColor,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  controller: tc,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      top: 2.0,
                                      left: 13.0,
                                      right: 13.0,
                                      bottom: 2.0
                                    ),
                                    hintText: "Type your message",
                                    hintStyle: TextStyle(
                                      color:Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15,),
                          Obx(() => FloatingActionButton.small(
                              onPressed: chatControllers.isLoading.value == true ? (){} : () async {
                                if(await chatControllers.sendMessage(
                                    message: tc.text
                                )){
                                  chatControllers.getMessage();
                                  tc.clear();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              },
                              backgroundColor: GlobalVariable.secondaryColor,
                              elevation: 0,
                              child: const Icon(Bootstrap.send, color: Colors.white),
                            ),
                          ),
                        ],

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() => chatControllers.isLoading.value == true
              ? const CircularProgressIndicator()
              : const SizedBox()),
        ],
      ),
    );
  }

  XFile? imageFile;
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = pickedFile;
    });
  }

  // void _handleAttachmentPressed() {
  //   showCupertinoActionSheet(
  //       context,
  //       cupertinoActionSheet: [
  //         CupertinoActionSheetAction(
  //             onPressed: (){
  //               Navigator.pop(context);
  //               pickImage();
  //               // _handleImageSelection();
  //             },
  //             child: const Text("Photo")
  //         ),
  //         CupertinoActionSheetAction(
  //             onPressed: (){
  //               Navigator.pop(context);
  //               // _handleFileSelection();
  //             },
  //             child: const Text("File")
  //         ),
  //       ],
  //       message: "Choose file",
  //       title: "File");
  // }

  List<ChatMessage> messages = [
    ChatMessage(content: "Hello, Will", whois: "receiver", time: DateTime.now()),
    ChatMessage(content: "How have you been?", whois: "receiver", time: DateTime.now()),
    ChatMessage(content: "Hey Kriss, I am doing fine dude. wbu?", whois: "sender", time: DateTime.now()),
    ChatMessage(content: "ehhhh, doing OK.", whois: "receiver", time: DateTime.now()),
  ];
}

class ChatMessage{
  String content;
  String whois;
  DateTime time;
  ChatMessage({
    required this.content, required this.whois, required this.time
  });
}
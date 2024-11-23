import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({super.key});

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  final globalVariable = GlobalVariable();
  final globalTextStyle = GlobalTextStyle();
  TextEditingController currencyController = TextEditingController();
  TextEditingController namaTransaksiController = TextEditingController();
  TextEditingController jumlahItemTransaksiController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  TextEditingController namaCustomer = TextEditingController();
  TextEditingController emailCustomer = TextEditingController();
  TextEditingController alamatCustomer = TextEditingController();

  bool wasSelectCustomer = false;
  final formatCurrency = NumberFormat.simpleCurrency(locale: "id", decimalDigits: 0, name: "IDR");
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  int totalPembelian = 0;
  int pajak = 0;
  int total = 0;
  DateTime? dateFirstInvoice;
  DateTime? dateEndInvoice;
  String? urlImage, invoiceName;
  final _formKey = GlobalKey<FormState>();
  final _formKeyCustomer = GlobalKey<FormState>();
  List<dynamic> addedItem = [];
  bool showInvoice = true;

  String setInvoiceName(){
    return invoiceName = DateFormat("ddMMyyhhmmss").format(DateTime.now());
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

  @override
  void initState() {
    setInvoiceName();
    super.initState();
  }

  @override
  void dispose() {
    currencyController.dispose();
    deskripsiController.dispose();
    jumlahItemTransaksiController.dispose();
    namaTransaksiController.dispose();
    namaCustomer.dispose();
    emailCustomer.dispose();
    alamatCustomer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
          toolbarHeight: preferredSize.height,
          title: Column(
            children: [
              Text("Buat Invoice", style: globalTextStyle.defaultTextStyleBold()),
              Text(showInvoice ? "Invoice #$invoiceName" : "* * * * * *", style: globalTextStyle.defaultTextStyleMedium(color: Colors.black54))
            ],
          ),
          actions: [
            CupertinoButton(child: Icon(showInvoice ? EvaIcons.eye_outline : EvaIcons.eye_off_2_outline, color: GlobalVariable.secondaryColor), onPressed: (){
              setState(() {
                showInvoice = !showInvoice;
              });
            })
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("INVOICE DETAILS", style: globalTextStyle.defaultTextStyleMedium(fontSize: 16, color: Colors.black54)),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: (){},
                          child: Row(
                            children: [
                              Text("Ubah", style: globalTextStyle.defaultTextStyleMedium(fontSize: 16, color: GlobalVariable.secondaryColor)),
                              const Icon(Icons.keyboard_arrow_right, color: GlobalVariable.secondaryColor)
                            ],
                          )
                        ),
                      ],
                    ),
                    wasSelectCustomer ? ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal:10),
                      dense: true,
                      onTap: (){
                        showModalBottomSheet(
                          context: context, 
                          isScrollControlled: true,
                          builder: (context) {
                            return Container(
                              height: size.height / 1.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: CupertinoColors.systemGroupedBackground
                              ),
                              child: Center(
                                child: Form(
                                  key: _formKey,
                                  autovalidateMode: AutovalidateMode.onUnfocus,
                                  onChanged: () {
                                    Form.maybeOf(primaryFocus!.context!)?.save();
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(right: 15, top: 10, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(width: size.width / 2.5),
                                            const Expanded(child: Text("Tambah Customer", style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.black))),
                                            CupertinoButton(padding: EdgeInsets.zero, child: const Text("Done", style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemBlue)), onPressed: (){}),
                                          ],
                                        ),
                                      ),
                                      const Divider(color: Colors.black12, height: 0.3),
                                      CupertinoFormSection.insetGrouped(
                                        header: const Text('FORM ITEM'),
                                        children: [
                                          CupertinoTextFormFieldRow(
                                            prefix: const Text('Nama', style: TextStyle(fontSize: 14)),
                                            placeholder: 'Type here',
                                            controller: namaTransaksiController,
                                            placeholderStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                                            validator: (String? value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Mohon isikan nama';
                                              }
                                              return null;
                                            },
                                          ),
                                          CupertinoTextFormFieldRow(
                                            prefix: const Text('Email', style: TextStyle(fontSize: 14)),
                                            placeholder: 'Type here',
                                            controller: currencyController,
                                            inputFormatters: [
                                              CurrencyTextInputFormatter.currency(locale: "id",decimalDigits: 0)
                                            ],
                                            keyboardType: TextInputType.number,
                                            placeholderStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                                            validator: (String? value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Mohon isikan alamat email customer';
                                              }
                                              return null;
                                            },
                                          ),
                                          CupertinoTextFormFieldRow(
                                            prefix: const Text('Alamat', style: TextStyle(fontSize: 14)),
                                            placeholder: 'Type here',
                                            controller: jumlahItemTransaksiController,
                                            keyboardType: TextInputType.number,
                                            placeholderStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                                            validator: (String? value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Mohon isikan alamat customer';
                                              }
                                              return null;
                                            },
                                          ),
                                        ]
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      leading: const CircleAvatar(
                        backgroundColor: GlobalVariable.secondaryColor,
                        child: Icon(Bootstrap.person_circle, size: 25, color: Colors.white),
                      ),
                      title: Text(namaCustomer.text, style: globalTextStyle.defaultTextStyleBold()),
                      subtitle: Text(emailCustomer.text, style: globalTextStyle.defaultTextStyleMedium(color: Colors.black54)),
                    ) : ListTile(
                      dense: true,
                      title: const Text("Tambah Customer"),
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 8,
                      subtitle: null,
                      leading: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.add_circled_solid, color: CupertinoColors.activeGreen, size: 28), 
                        onPressed: (){
                          showModalBottomSheet(
                            context: context, 
                            isScrollControlled: true,
                            builder: (context) {
                              return Container(
                                height: size.height / 1.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: CupertinoColors.systemGroupedBackground
                                ),
                                child: Center(
                                  child: Form(
                                    key: _formKeyCustomer,
                                    autovalidateMode: AutovalidateMode.onUnfocus,
                                    onChanged: () {
                                      Form.maybeOf(primaryFocus!.context!)?.save();
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15, top: 10, bottom: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: size.width / 2.5),
                                              const Expanded(child: Text("Tambah Customer", style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.black))),
                                              CupertinoButton(padding: EdgeInsets.zero, child: const Text("Done", style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemBlue)), onPressed: (){
                                                if(_formKeyCustomer.currentState!.validate()){
                                                  setState(() {
                                                    wasSelectCustomer = true;
                                                  });
                                                }
                                              }),
                                            ],
                                          ),
                                        ),
                                        const Divider(color: Colors.black12, height: 0.3),
                                        CupertinoFormSection.insetGrouped(
                                          header: const Text('FORM ITEM'),
                                          children: [
                                            CupertinoTextFormFieldRow(
                                              prefix: const Text('Nama', style: TextStyle(fontSize: 14)),
                                              placeholder: 'Type here',
                                              keyboardType: TextInputType.name,
                                              controller: namaCustomer,
                                              placeholderStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                                              validator: (String? value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Mohon isikan nama';
                                                }
                                                return null;
                                              },
                                            ),
                                            CupertinoTextFormFieldRow(
                                              prefix: const Text('Email', style: TextStyle(fontSize: 14)),
                                              placeholder: 'Type here',
                                              controller: emailCustomer,
                                              inputFormatters: [
                                                CurrencyTextInputFormatter.currency(locale: "id",decimalDigits: 0)
                                              ],
                                              keyboardType: TextInputType.emailAddress,
                                              placeholderStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                                              validator: (String? value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Mohon isikan alamat email customer';
                                                }
                                                return null;
                                              },
                                            ),
                                            CupertinoTextFormFieldRow(
                                              prefix: const Text('Alamat', style: TextStyle(fontSize: 14)),
                                              placeholder: 'Type here',
                                              controller: alamatCustomer,
                                              keyboardType: TextInputType.streetAddress,
                                              placeholderStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                                              validator: (String? value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Mohon isikan alamat customer';
                                                }
                                                return null;
                                              },
                                            ),
                                          ]
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      ),
                    ),
                    const Divider(color: Colors.black12),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          _showDialog(
                            CupertinoDatePicker(
                              initialDateTime: dateFirstInvoice,
                              mode: CupertinoDatePickerMode.date,
                              use24hFormat: true,
                              showDayOfWeek: true,
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() => dateFirstInvoice = newDate);
                              },
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Tanggal Awal", style: TextStyle(fontSize: 13, color: Colors.black54)),
                            Text(DateFormat('dd MMM yyyy').format(dateFirstInvoice ?? DateTime.now()), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: VerticalDivider(color: Colors.black12),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          _showDialog(
                            CupertinoDatePicker(
                              initialDateTime: dateEndInvoice,
                              mode: CupertinoDatePickerMode.date,
                              use24hFormat: true,
                              showDayOfWeek: true,
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() => dateEndInvoice = newDate);
                              },
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Jatuh Tempo", style: TextStyle(fontSize: 13, color: Colors.black54)),
                            Text(DateFormat('dd MMM yyyy').format(dateEndInvoice ?? DateTime.now()), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("ITEMS DETAILS", style: globalTextStyle.defaultTextStyleMedium(fontSize: 16, color: Colors.black54)),
                ],
              ),
              Column(
                children: List.generate(addedItem.length + 1, (i) {
                  if(i < addedItem.length){
                    return ListTile(
                      onTap: (){},
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 8,
                      leading: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.minus_circle_fill, color: CupertinoColors.systemRed, size: 28), onPressed: (){
                          setState(() {
                            addedItem.removeAt(i);
                          });
                        }),
                      title: Text(addedItem[i]['details']['nama'] ?? "Unknown Data", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                      subtitle: Text("${addedItem[i]['details']['jumlah']} x ${addedItem[i]['details']['price'] ?? 0}", style: const TextStyle(color: Colors.black45)),
                      trailing: Text('${addedItem[i]['details']['total'] != null ? formatCurrency.format(addedItem[i]['details']['total']) : 0}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    );
                  }
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 8,
                    leading: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.add_circled_solid, color: CupertinoColors.activeGreen, size: 28), onPressed: (){
                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: size.height / 1.2,
                              decoration: BoxDecoration(
                                color: CupertinoColors.tertiarySystemGroupedBackground,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Form(
                                  key: _formKey,
                                  autovalidateMode: AutovalidateMode.onUnfocus,
                                  onChanged: () {
                                    Form.maybeOf(primaryFocus!.context!)?.save();
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(right: 15, top: 10, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(width: size.width / 2.5),
                                            const Expanded(child: Text("Tambah Item", style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.black))),
                                            CupertinoButton(padding: EdgeInsets.zero, child: const Text("Done", style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemBlue)), onPressed: (){
                                              String? removeIDR;
                                              int? hargaItem;
                                              int total = 0;
                                              if(_formKey.currentState!.validate()){
                                                if(currencyController.text.isNotEmpty){
                                                  removeIDR = currencyController.text.substring(3);
                                                  removeIDR = removeIDR.replaceAll(".", '');
                                                  hargaItem = int.parse(removeIDR);
                                                  total = hargaItem * int.parse(jumlahItemTransaksiController.text);

                                                  setState(() => addedItem.add({
                                                    "details" : {
                                                      "nama" : namaTransaksiController.text,
                                                      "jumlah" : jumlahItemTransaksiController.text,
                                                      "price" : currencyController.text,
                                                      "deskripsi" : deskripsiController.text,
                                                      "total" : total
                                                    }
                                                  }));
                                                }
                                                namaTransaksiController.clear();
                                                jumlahItemTransaksiController.clear();
                                                currencyController.clear();
                                                deskripsiController.clear();
                                                Navigator.pop(context);
                                              }
                                            }),
                                          ],
                                        ),
                                      ),
                                      const Divider(color: Colors.black12, height: 0.3),
                                      CupertinoFormSection.insetGrouped(
                                        header: const Text('FORM ITEM'),
                                        children: [
                                          CupertinoTextFormFieldRow(
                                            prefix: const Text('Nama Transaksi', style: TextStyle(fontSize: 14)),
                                            placeholder: 'Type here',
                                            controller: namaTransaksiController,
                                            placeholderStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                                            validator: (String? value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Mohon isikan nama transaksi';
                                              }
                                              return null;
                                            },
                                          ),
                                          CupertinoTextFormFieldRow(
                                            prefix: const Text('Harga Item', style: TextStyle(fontSize: 14)),
                                            placeholder: 'Type here',
                                            controller: currencyController,
                                            inputFormatters: [
                                              CurrencyTextInputFormatter.currency(locale: "id",decimalDigits: 0)
                                            ],
                                            keyboardType: TextInputType.number,
                                            placeholderStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                                            validator: (String? value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Mohon isikan harga item';
                                              }
                                              return null;
                                            },
                                          ),
                                          CupertinoTextFormFieldRow(
                                            prefix: const Text('Jumlah Item', style: TextStyle(fontSize: 14)),
                                            placeholder: 'Type here',
                                            controller: jumlahItemTransaksiController,
                                            keyboardType: TextInputType.number,
                                            placeholderStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                                            validator: (String? value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Mohon isikan jumlah item';
                                              }
                                              return null;
                                            },
                                          ),
                                          CupertinoTextFormFieldRow(
                                            prefix: const Text('Deskripsi', style: TextStyle(fontSize: 14)),
                                            placeholder: 'Type here',
                                            controller: deskripsiController,
                                            keyboardType: TextInputType.text,
                                            placeholderStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                                            validator: (String? value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Mohon isikan deskripsi';
                                              }
                                              return null;
                                            },
                                          ),
                                        ]
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    title: const Text("Tambah Item atau Layanan", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    subtitle: null,
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("TOTAL SUMMARY", style: globalTextStyle.defaultTextStyleMedium(fontSize: 16, color: Colors.black54)),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal", style: globalTextStyle.defaultTextStyleMedium(fontSize: 14, color: Colors.black54)),
                  Text(formatCurrency.format(totalPembelian), style: globalTextStyle.defaultTextStyleBold(fontSize: 15, color: Colors.black54)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Inclusive Tax (11%)", style: globalTextStyle.defaultTextStyleMedium(fontSize: 14, color: Colors.black54)),
                  Text(formatCurrency.format(pajak), style: globalTextStyle.defaultTextStyleBold(fontSize: 15, color: Colors.black54)),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: Colors.black12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total", style: globalTextStyle.defaultTextStyleMedium(fontSize: 14, color: Colors.black54)),
                  Text(formatCurrency.format(total), style: globalTextStyle.defaultTextStyleBold(fontSize: 15, color: Colors.black54)),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: const ButtonStyle(
                    side: WidgetStatePropertyAll(BorderSide(color: GlobalVariable.secondaryColor))
                  ),
                  onPressed: (){}, child: Text("Save as draft", style: globalTextStyle.defaultTextStyleMedium(fontSize: 14, color: GlobalVariable.secondaryColor))
                  ),
                ),
              const SizedBox(width: 5),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      color: GlobalVariable.secondaryColor
                    ),
                    elevation: 0,
                    backgroundColor: GlobalVariable.secondaryColor,
                  ),
                  onPressed: (){}, 
                  child: Text("Send Invoice", style: globalTextStyle.defaultTextStyleMedium(fontSize: 14, color: Colors.white))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
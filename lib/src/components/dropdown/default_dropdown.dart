import 'package:asb_app/src/components/global/index.dart';
import 'package:flutter/material.dart';

class DefaultDropdownButton extends StatefulWidget {
  final List<String>? listContentDropDown;
  final Function()? onTap;
  final Function(String?)? onChanged;
  final String? dropdown;
  const DefaultDropdownButton({super.key, this.listContentDropDown, this.onTap, this.onChanged, this.dropdown});

  @override
  State<DefaultDropdownButton> createState() => _DefaultDropdownButtonState();
}

class _DefaultDropdownButtonState extends State<DefaultDropdownButton> {

  String? dropdownValue;
  List<DropdownMenuItem<String>> list2 = [const DropdownMenuItem(child: Text("Pilihan"))];

  @override
  void initState() {
    super.initState();
    if(widget.listContentDropDown != null){
      dropdownValue = widget.listContentDropDown?.first; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      enableFeedback: true,
      alignment: Alignment.centerLeft,
      isExpanded: true,
      value: widget.dropdown ?? "Pilihan",
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: GlobalVariable.secondaryColor),
      borderRadius: BorderRadius.circular(10),
      dropdownColor: Colors.white,
      elevation: 16,
      style: const TextStyle(color: GlobalVariable.secondaryColor),
      underline: Container(
        height: 2,
        color: GlobalVariable.secondaryColor,
      ),
      onChanged: widget.onChanged,
      // onChanged: (String? value) {
      //   setState(() {
      //     dropdownValue = value!;
      //   });
      // },
      items: widget.listContentDropDown != null ? widget.listContentDropDown?.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList() : list2
    );
  }
}
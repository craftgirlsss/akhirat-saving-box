import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:asb_app/src/components/textsyle/index.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  const CustomTextField({super.key, this.label, this.controller, this.keyboardType});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final textStyle = GlobalTextStyle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label ?? "Unknown Label"),
          const SizedBox(height: 5),
          TextFormField(

            keyboardType: widget.keyboardType ?? TextInputType.text,
            controller: widget.controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mohon isikan ${widget.label}';
              }
              return null;
            },
            style: textStyle.defaultTextStyleMedium(fontSize: 15),
            decoration: InputDecoration(
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.red)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.black12)
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.black12)
              )
            ),
          )
        ],
      ),
    );
  }
}
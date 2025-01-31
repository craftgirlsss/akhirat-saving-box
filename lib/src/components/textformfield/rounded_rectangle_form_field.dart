import 'package:flutter/material.dart';
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

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final GlobalKey<FormState>? formKey;
  final bool? readOnly;
  const CustomTextFormField({super.key, this.controller, this.hintText, this.keyboardType, this.formKey, this.readOnly});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        controller: widget.controller,
        readOnly: widget.readOnly ?? false,
        keyboardType: widget.keyboardType ?? TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter ${widget.hintText}';
          }
          return null;
        },
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: "-",
          label: Text(widget.hintText ?? "Label"),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12, width: 0.5)
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 0.5)
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12, width: 0.5)
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12, width: 0.5)
          ),
        ),
      )
    );
  }
}
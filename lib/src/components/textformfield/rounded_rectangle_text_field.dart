import 'package:flutter/material.dart';

class CustomRoundedTextField extends StatefulWidget {
  const CustomRoundedTextField({super.key, this.controller, this.label, this.placeholder, this.enable, this.onTap, this.keyboardType, this.readOnly, this.errorText});
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? label;
  final String? placeholder;
  final String? errorText;
  final bool? enable;
  final bool? readOnly;
  final Function()? onTap;

  @override
  State<CustomRoundedTextField> createState() => _CustomRoundedTextFieldState();
}

class _CustomRoundedTextFieldState extends State<CustomRoundedTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(widget.label ?? "Label", style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ),
          const SizedBox(height: 3),
          TextFormField(
            cursorColor: Colors.black54,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
            keyboardType: widget.keyboardType ?? TextInputType.name,
            enabled: widget.enable ?? true,
            onTap: widget.readOnly == true ? widget.onTap : null,
            readOnly: widget.readOnly ?? false,
            controller: widget.controller,
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.black26, fontSize: 14, fontWeight: FontWeight.w200, fontStyle: FontStyle.italic),
              hintText: widget.placeholder ?? "Inputkan Nama",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(color: Colors.black26, width: 0.5)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(color: Colors.black26, width: 0.5)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(color: Colors.black26, width: 0.5)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: const BorderSide(color: Colors.red, width: 0.5)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return widget.errorText ?? 'Mohon isi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
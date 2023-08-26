import 'package:flutter/material.dart';

//ignore: must_be_immutable
class Textfield extends StatefulWidget {
  Textfield({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    this.passwordText = false,
    this.viewButton = false,
    this.keyboardType = TextInputType.text,
    required this.validator,
  });

  final TextEditingController controller;
  final IconData icon;
  final String label;
  bool passwordText;
  final bool viewButton;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  @override
  State<Textfield> createState() => _TextFieldFormState();
}

class _TextFieldFormState extends State<Textfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: const TextStyle(color: Colors.blue),
      keyboardType: widget.keyboardType,
      obscureText: widget.passwordText,
      decoration: InputDecoration(
        label: Text(widget.label),
        prefixIcon: Icon(
          widget.icon,
          color: Colors.deepPurple,
        ),
        suffixIcon: widget.viewButton
            ? IconButton(
                onPressed: () {
                  widget.passwordText = !widget.passwordText;
                  setState(() {});
                },
                icon: Icon(widget.passwordText
                    ? Icons.remove_red_eye
                    : Icons.visibility_off),
              )
            : null,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
      validator: widget.validator,
      onChanged: (value) {},
    );
  }
}

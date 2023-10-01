import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class EditField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String initialValue;
  const EditField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.initialValue});

  @override
  Widget build(BuildContext context) {
    const border = UnderlineInputBorder(
        borderSide: BorderSide(
      color: primaryColor,
    ));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: TextFormField(
        onChanged: (value) {
          controller.text = value;
        },
        minLines: 1,
        maxLines: labelText == "Bio" ? 4 : 1,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        cursorColor: primaryColor,
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(fontSize: 18),
          floatingLabelStyle:
              const TextStyle(fontSize: 18, color: secondaryColor),
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }
}

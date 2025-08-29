import 'package:flutter/material.dart';
import 'package:protofolio_edit/constant.dart';

class FormButton extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;

  const FormButton({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty';
            }
            return null;
          },
          cursorColor: primaryColor,
          cursorErrorColor: primaryColor,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: 23,
              color: sectionColor,
              fontFamily: 'Rubic',
            ),
            hintStyle: const TextStyle(color: Color(0xffD7D7D7)),
            contentPadding: const EdgeInsets.all(20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xffD7D7D7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: sectionColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
        SizedBox(height: 25,),
      ],
    );
  }
}

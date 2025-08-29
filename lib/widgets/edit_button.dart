import 'package:flutter/material.dart';
import 'package:protofolio_edit/constant.dart';

class EditButton extends StatelessWidget {
  const EditButton({super.key, required this.page, required this.text});
  final Widget page;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: sectionColor,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => page));
        },

        child: Text(
          text,
          style: TextStyle(
            color: primaryColor,
            fontSize: 23,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubic',
          ),
        ),
      ),
    );
  }
}

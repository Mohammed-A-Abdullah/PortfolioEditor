import 'package:flutter/material.dart';
import '../../constant.dart';

class SkillItem extends StatefulWidget {
  final String text;

  const SkillItem({super.key, required this.text});

  @override
  State<SkillItem> createState() => _SkillItemState();
}

class _SkillItemState extends State<SkillItem> {

  @override
  Widget build(BuildContext context) {

    Widget content = Container(
      
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor.withValues(alpha: 0.3),
        border: Border.all(
          color: sectionColor,
        ),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(
          fontSize: 14,
          color: primaryColor,
          fontFamily: 'PT_sans',
        ),
      ),
    );

    
      return content;
    
  }
}

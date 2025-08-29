import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:protofolio_edit/sections/skillCard/skill_item.dart';
import '../../constant.dart';

class SkillCard extends StatefulWidget {
  final String title;
  final String docId;
  final String icon;

  const SkillCard({
    super.key,
    required this.title,
    required this.docId,
    required this.icon,
  });

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  @override
  Widget build(BuildContext context) {
    Widget cardContent = SizedBox(
      width: 350,
      height: 350,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: primaryColor, width: 2),
        ),
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor:Colors.transparent,
                        
                    maxRadius: 30,
                    child: SvgPicture.string(
                      widget.icon,
                      width: 40,
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rubic',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('skills')
                      .doc(widget.docId)
                      .collection('data')
                      .snapshots(),
                  builder: (context, itemsSnapshot) {
                    if (!itemsSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator(color: sectionColor,));
                    }

                    final items = itemsSnapshot.data!.docs;

                    if (items.isEmpty) {
                      return const Center(
                        child: Text(
                          "No data available",
                          style: TextStyle(color: primaryColor),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: items.map((item) {
                          return SkillItem(text: item['content']);
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return cardContent;
  }
}

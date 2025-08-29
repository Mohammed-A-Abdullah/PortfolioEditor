import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protofolio_edit/edit/skills_edit.dart';
import 'package:protofolio_edit/constant.dart';
import 'package:protofolio_edit/widgets/edit_button.dart';
import 'package:protofolio_edit/sections/skillCard/skill_card.dart';

class Skills extends StatefulWidget {
  const Skills({super.key});

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Center(
            child: Text(
              'Skills & Technologies',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Rubic',
                fontWeight: FontWeight.bold,
                color: sectionColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
    
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('skills')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
    
              final docs = snapshot.data!.docs;
    
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: docs.map((doc) {
                  final skillTitle = doc['title'];
                  final skillIcon = doc['icon'];
                  return SkillCard(title: skillTitle, docId: doc.id,icon: skillIcon,);
                }).toList(),
              );
            },
          ),
          SizedBox(height: 15,),
          EditButton(page: SkillsEdit(), text: 'Edit Skills')
        ],
      ),
    );
  }
}

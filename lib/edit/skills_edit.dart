import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protofolio_edit/constant.dart';
import 'package:protofolio_edit/widgets/form_button.dart';

class SkillsEdit extends StatefulWidget {
  const SkillsEdit({super.key});

  @override
  State<SkillsEdit> createState() => _SkillsEditState();
}

class _SkillsEditState extends State<SkillsEdit> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController icon = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController data = TextEditingController();

  final CollectionReference skillsRef = FirebaseFirestore.instance.collection(
    'skills',
  );

  Future<void> addSkill() async {
    FocusScope.of(context).unfocus();
    if (icon.text.isEmpty || title.text.isEmpty) return;

    await skillsRef.add({'icon': icon.text, 'title': title.text});
    icon.clear();
    title.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: sectionColor,
        content: Text(
          "Data Updated Successfully ✅",
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontFamily: 'Rubic',
          ),
        ),
      ),
    );
  }

  Future<void> addData(String skillId) async {
    FocusScope.of(context).unfocus();
    if (data.text.isEmpty) return;

    await skillsRef.doc(skillId).collection('data').add({'content': data.text});
    data.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: sectionColor,
        content: Text(
          "Data Updated Successfully ✅",
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontFamily: 'Rubic',
          ),
        ),
      ),
    );
  }

  Future<void> deleteSkill(String skillId) async {
    await skillsRef.doc(skillId).delete();
  }

  Future<void> deleteData(String skillId, String dataId) async {
    await skillsRef.doc(skillId).collection('data').doc(dataId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sectionColor,
        title: Text(
          'Edit Skills',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Rubic'),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),

            FormButton(labelText: 'Icon', controller: icon),
            SizedBox(height: 10),
            FormButton(labelText: 'Title', controller: title),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: sectionColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: addSkill,
                child: Text(
                  "Add Skill",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'PT_sans',
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            StreamBuilder<QuerySnapshot>(
              stream: skillsRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final skills = snapshot.data!.docs;

                return Column(
                  children: skills.map((skill) {
                    final skillId = skill.id;
                    return Card(
                      
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: cardColor,
                      child: ExpansionTile(
                        collapsedBackgroundColor: cardColor,
                        backgroundColor: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Text(
                          "${skill['title']}",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rubic',
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteSkill(skillId),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: FormButton(
                                    labelText: 'Skill',
                                    controller: data,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  onPressed: () => addData(skillId),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 2,),

                          StreamBuilder<QuerySnapshot>(
                            stream: skillsRef
                                .doc(skillId)
                                .collection('data')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return const SizedBox();

                              final datas = snapshot.data!.docs;

                              return Column(
                                children: datas.map((d) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          d['content'],
                                          style: TextStyle(color: primaryColor),
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              deleteData(skillId, d.id),
                                        ),
                                      ),
                                      Divider(height: 2,),
                                    ],
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

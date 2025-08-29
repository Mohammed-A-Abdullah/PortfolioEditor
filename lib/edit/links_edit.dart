import 'package:flutter/material.dart';
import 'package:protofolio_edit/constant.dart';
import 'package:protofolio_edit/widgets/form_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LinksEdit extends StatefulWidget {
  const LinksEdit({super.key});

  @override
  State<LinksEdit> createState() => _HomeEditState();
}

class _HomeEditState extends State<LinksEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController linkController = TextEditingController();
  TextEditingController logoLink = TextEditingController();
  TextEditingController name = TextEditingController();

  Future<void> _addLink() async {
    FocusScope.of(context).unfocus();
    if (linkController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('Links').add({
        'linkname':name.text,
        'url': linkController.text,
        'image': logoLink.text,
      });
      linkController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: sectionColor,
          content: Text(
            "Data Updated Successfully ✅",
            style: TextStyle(color: primaryColor,fontSize: 20,fontFamily: 'Rubic'),
          ),
        ),
      );
    }
  }

  Future<void> _removeLink(String docId) async {
    await FirebaseFirestore.instance.collection('Links').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sectionColor,
        title: Text(
                  'Edit Links',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rubic',
                  ),
                ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                FormButton(labelText: 'Link Name', controller: name),
                                FormButton(
                                  labelText: 'Link',
                                  controller: linkController,
                                ),
                                FormButton(
                                  labelText: 'Icon',
                                  controller: logoLink,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.green,
                              size: 35,
                            ),
                            onPressed: _addLink,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Links')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          var docs = snapshot.data!.docs;

                          if (docs.isEmpty) {
                            return const Text("No links added yet.");
                          }

                          return Column(
                            children: docs.map((doc) {
                              String link = doc['linkname'];
                              return Card(
                                color: cardColor,
                                child: ListTile(
                                  title: Text(
                                    link,
                                    style: TextStyle(color: primaryColor,fontSize: 23,fontFamily: 'Rubic',),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _removeLink(doc.id),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

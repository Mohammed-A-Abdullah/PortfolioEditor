import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protofolio_edit/constant.dart';
import 'package:protofolio_edit/widgets/form_button.dart';

class CertificateEdit extends StatefulWidget {
  const CertificateEdit({super.key});

  @override
  State<CertificateEdit> createState() => _CertificateEditState();
}

class _CertificateEditState extends State<CertificateEdit> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController image = TextEditingController();

  final CollectionReference certRef = FirebaseFirestore.instance.collection(
    'certificate',
  );
  String? editingId;


  Future<void> addCertificate() async {
    FocusScope.of(context).unfocus();
    if (title.text.isNotEmpty &&
        content.text.isNotEmpty &&
        image.text.isNotEmpty) {
      await certRef.add({
        'title': title.text,
        'content': content.text,
        'image': image.text,
      });

      title.clear();
      content.clear();
      image.clear();
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

  }

  void editCertificate(
    String docId,
    String oldTitle,
    String oldContent,
    String oldImage,
  ) {
    setState(() {
      editingId = docId; 
      title.text = oldTitle;
      content.text = oldContent;
      image.text = oldImage;
    });
  }

  Future<void> deleteCertificate(String docId) async {
    await certRef.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sectionColor,
        title: const Text(
          'Edit Certificate',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Rubic'),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),

            Form(
              key: formKey,
              child: Column(
                children: [
                  FormButton(labelText: 'Title', controller: title),
                  const SizedBox(height: 10),
                  FormButton(labelText: 'Content', controller: content),
                  const SizedBox(height: 10),
                  FormButton(labelText: 'Image', controller: image),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 15,
                          ),
                          backgroundColor: sectionColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          if (editingId != null) {
                            FocusScope.of(context).unfocus();
                            await certRef.doc(editingId).update({
                              'title': title.text,
                              'content': content.text,
                              'image': image.text,
                            });
                            setState(() {
                              editingId = null;
                              title.clear();
                              content.clear();
                              image.clear();
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: sectionColor,
                                content: Text(
                                  "Certificate Updated Successfully ✅",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 20,
                                    fontFamily: 'Rubic',
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Save changes",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'PT_sans',
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 15,
                          ),
                          backgroundColor: sectionColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: addCertificate,
                        child: const Text(
                          "Add certificate",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'PT_sans',
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            StreamBuilder<QuerySnapshot>(
              stream: certRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final certificates = snapshot.data!.docs;

                return Column(
                  children: certificates.map((cert) {
                    var data = cert.data() as Map<String, dynamic>;

                    return Card(
                      color: cardColor,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: data['image'] != null
                            ? Image.asset(
                                data['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(
                                  Icons.broken_image,
                                  color: primaryColor,
                                ),
                              )
                            : const Icon(
                                Icons.image_not_supported,
                                color: primaryColor,
                              ),
                        title: Text(
                          data['title'],
                          style: const TextStyle(
                            color: primaryColor,
                            fontFamily: 'Rubic',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => editCertificate(
                                cert.id,
                                data['title'],
                                data['content'],
                                data['image'],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteCertificate(cert.id),
                            ),
                          ],
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
    );
  }

}

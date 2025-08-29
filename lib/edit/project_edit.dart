import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protofolio_edit/constant.dart';
import 'package:protofolio_edit/widgets/form_button.dart';

class ProjectEdit extends StatefulWidget {
  const ProjectEdit({super.key});

  @override
  State<ProjectEdit> createState() => _ProjectEditState();
}

class _ProjectEditState extends State<ProjectEdit> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController url = TextEditingController();

  final CollectionReference certRef = FirebaseFirestore.instance.collection(
    'project',
  );

  Future<void> addProject() async {
    if (title.text.isNotEmpty &&
        content.text.isNotEmpty &&
        image.text.isNotEmpty) {
      await certRef.add({
        'title': title.text,
        'content': content.text,
        'image': image.text,
        'url': url.text,
      });

      title.clear();
      content.clear();
      image.clear();
      url.clear();
    }
  }

  Future<void> editProject(
    String docId,
    String oldTitle,
    String oldContent,
    String oldImage,
    String oldUrl,
  ) async {
    title.text = oldTitle;
    content.text = oldContent;
    image.text = oldImage;
    url.text = oldUrl;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        title: const Text("Edit project"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormButton(labelText: 'title', controller: title),
            SizedBox(height: 10),
            FormButton(labelText: 'content', controller: content),
            SizedBox(height: 10),
            FormButton(labelText: 'image', controller: image),
            SizedBox(height: 10),
            FormButton(labelText: 'url', controller: url),
            
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await certRef.doc(docId).update({
                'title': title.text,
                'content': content.text,
                'image': image.text,
                'url': url.text,
              });
              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteProject(String docId) async {
    await certRef.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sectionColor,
        title: Text(
          'Edit Project',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Rubic'),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
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
                    FormButton(labelText: 'Url', controller: url),
                    const SizedBox(height: 10),
                    
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: sectionColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: addProject,
                        child: Text(
                          "Save Changes",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'PT_sans',
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
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

                  final projects = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      var cert = projects[index];
                      var data = cert.data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: data['image'] != null
                              ? Image.asset(
                                  data['image'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) =>
                                      const Icon(Icons.broken_image),
                                )
                              : const Icon(Icons.image_not_supported),
                          title: Text(data['title']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => editProject(
                                  cert.id,
                                  data['title'],
                                  data['content'],
                                  data['image'],
                                  data['imageurl'],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteProject(cert.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protofolio_edit/constant.dart';
import 'package:protofolio_edit/widgets/form_button.dart';

class AboutEdit extends StatefulWidget {
  const AboutEdit({super.key});

  @override
  State<AboutEdit> createState() => _AboutEditState();
}

class _AboutEditState extends State<AboutEdit> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController about = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('about')
        .doc('EmHSzz0uEA0BWQ2H5Pav')
        .get();
    if (snapshot.exists) {
      setState(() {
        about.text = snapshot.data() ? ['aboutme']?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sectionColor,
        title:Text(
              'Edit About',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Rubic',
              ),
            ), 
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            
            const SizedBox(height: 20),

            Form(
              key: formKey,
              child: Column(
                children: [
                  FormButton(labelText: 'About', controller: about),
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
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (formKey.currentState!.validate()) {
                          await FirebaseFirestore.instance
                              .collection('about')
                              .doc("EmHSzz0uEA0BWQ2H5Pav")
                              .update({'aboutme': about.text});
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
                      },
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
          ],
        ),
      ),
    );
  }
}

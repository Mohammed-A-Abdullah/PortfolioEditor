import 'package:flutter/material.dart';
import 'package:protofolio_edit/constant.dart';
import 'package:protofolio_edit/widgets/form_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeEdit extends StatefulWidget {
  const HomeEdit({super.key});

  @override
  State<HomeEdit> createState() => _HomeEditState();
}

class _HomeEditState extends State<HomeEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController photo = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController jobName = TextEditingController();
  TextEditingController CV = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();

  TextEditingController linkController =
      TextEditingController();
      TextEditingController logoLink=TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('home')
        .doc("clGCtTR0H0lh8UKhPSky")
        .get();

    if (snapshot.exists) {
      setState(() {
        name.text = snapshot.data()?['title'] ?? '';
        photo.text = snapshot.data()?['profile'] ?? '';
        jobName.text = snapshot.data()?['job'] ?? '';
        CV.text = snapshot.data()?['cv'] ?? '';
        address.text = snapshot.data()?['address'] ?? '';
        phoneNumber.text = snapshot.data()?['phone'] ?? '';
        email.text = snapshot.data()?['email'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sectionColor,
        title: Text(
                  'Edit Home',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rubic',
                  ),
                ),
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    FormButton(
                      labelText: 'Photo',
                      controller: photo,
                    ),
                    FormButton(labelText: 'Name', controller: name),
                    FormButton(
                      labelText: 'Job Name',
                      controller: jobName,
                    ),
                    FormButton(labelText: 'CV', controller: CV),
                    FormButton(
                      labelText: 'Email',
                      controller: email,
                    ),
                    FormButton(
                      labelText: 'Address',
                      controller: address,
                    ),
                    FormButton(
                      labelText: 'Phone Number',
                      controller: phoneNumber,
                    ),
      
      
                    const SizedBox(height: 30),
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
                                .collection('home')
                                .doc("clGCtTR0H0lh8UKhPSky")
                                .update({
                                  'profile': photo.text,
                                  'job': jobName.text,
                                  'cv': CV.text,
                                  'title': name.text,
                                  'address': address.text,
                                  'phone': phoneNumber.text,
                                  'email': email.text,
                                });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: sectionColor,
                                content: Text("Data Updated Successfully ✅",style: TextStyle(color: primaryColor,fontSize: 20,fontFamily: 'Rubic'),),
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
      ),
    );
  }
}


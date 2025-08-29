import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protofolio_edit/edit/about_edit.dart';
import 'package:protofolio_edit/constant.dart';
import 'package:protofolio_edit/widgets/edit_button.dart';


class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'About Me',
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'Rubic',
                fontWeight: FontWeight.bold,
                color: sectionColor,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Card(
              color:primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.zero,
              child: Card(
                margin: const EdgeInsets.all(2),
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('about')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            "Error loading data",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "No About Me info available",
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                            
                      final docs = snapshot.data!.docs.first;
                      final text = docs['aboutme'];
                            
                      return Text(
                        text,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 20,
                          color: contentColor,
                          fontFamily: 'PT_sans',
                          height: 1.6,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          EditButton(page: AboutEdit(), text: 'Edit About'),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

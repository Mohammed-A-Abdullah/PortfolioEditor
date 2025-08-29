import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protofolio_edit/constant.dart';

class CertficateDetails extends StatelessWidget {
  final String projectId;

  const CertficateDetails({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: sectionColor,
        title: Text('Content',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Rubic',

        ),),
      ),
      backgroundColor: const Color(0xFF1E212D),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('certificate')
            .doc(projectId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final doc = snapshot.data!;
          return SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      doc['image'],
                      //height: 350,
                      width: 600,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 25),

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Text(
                      doc['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontFamily: 'Rubic',
                        fontWeight: FontWeight.bold,
                        color: sectionColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 10,
                      ),
                      child: Container(
                        alignment: Alignment.topLeft,
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: sectionColor, width: 4),
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          doc['content'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'PT_sans',
                            height: 1.6,
                            color: Color(0xFFFFEBD2),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

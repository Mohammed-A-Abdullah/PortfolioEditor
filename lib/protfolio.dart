import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protofolio_edit/sections/messages.dart';
import 'sections/about.dart';
import 'sections/contact.dart';
import 'sections/home.dart';
import 'sections/projects.dart';
import 'sections/skills.dart';
import 'sections/certificate.dart';
import 'package:animate_do/animate_do.dart';
import 'constant.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Protfolio extends StatefulWidget {
  const Protfolio({super.key});

  @override
  State<Protfolio> createState() => _ProtfolioState();
}

class _ProtfolioState extends State<Protfolio> {
  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final projectKey = GlobalKey();
  final skillsKey = GlobalKey();
  final contactKey = GlobalKey();
  final certifiKey = GlobalKey();

  bool aniHome = false;
  bool aniAbout = false;
  bool aniskill = false;
  bool anicotact = false;
  bool aniCertificate = false;
  bool aniproject = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .where('isRead', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          int unreadCount = 0;
          if (snapshot.hasData) {
            unreadCount = snapshot.data!.docs.length;
          }

          
          return Stack(
            clipBehavior: Clip.none,
            children: [
              FloatingActionButton(
                backgroundColor: sectionColor,
                child: const Icon(Icons.message, color: primaryColor),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Messages()),
                  );
                },
              ),

              if (unreadCount > 0)
                Positioned(
                  right: 0,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      
      backgroundColor: const Color(0xFF1E212D),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Column(
                    children: [
                      SizedBox(height: 30),

                      /// Home
                      VisibilityDetector(
                        key: homeKey,
                        onVisibilityChanged: (info) {
                          setState(() {
                            aniHome = info.visibleFraction > 0;
                          });
                        },
                        child:
                            Container(
                              alignment: Alignment.center,
                              height: 700,
                              child: const Home(),
                            ).fadeInUp(
                              animate: aniHome,
                              duration: const Duration(milliseconds: 800),
                            ),
                      ),

                      VisibilityDetector(
                        key: aboutKey,
                        onVisibilityChanged: (info) {
                          setState(() {
                            aniAbout = info.visibleFraction > 0.09;
                          });
                        },
                        child:
                            Container(
                              constraints: BoxConstraints(minHeight: 700),
                              alignment: Alignment.center,
                              child: const About(),
                            ).fadeInLeft(
                              animate: aniAbout,
                              duration: const Duration(milliseconds: 800),
                            ),
                      ),

                      VisibilityDetector(
                        key: skillsKey,
                        onVisibilityChanged: (info) {
                          setState(() {
                            aniskill = info.visibleFraction > 0;
                          });
                        },
                        child:
                            Container(
                              constraints: BoxConstraints(minHeight: 700),
                              alignment: Alignment.center,
                              child: const Skills(),
                            ).zoomIn(
                              animate: aniskill,
                              duration: const Duration(milliseconds: 800),
                            ),
                      ),

                      VisibilityDetector(
                        key: certifiKey,
                        onVisibilityChanged: (info) {
                          setState(() {
                            aniCertificate = info.visibleFraction > 0;
                          });
                        },
                        child:
                            Container(
                              constraints: BoxConstraints(minHeight: 700),
                              alignment: Alignment.center,
                              child: const Certificate(),
                            ).fadeInDown(
                              animate: aniCertificate,
                              duration: const Duration(milliseconds: 800),
                            ),
                      ),

                      VisibilityDetector(
                        key: projectKey,
                        onVisibilityChanged: (info) {
                          setState(() {
                            aniproject = info.visibleFraction > 0;
                          });
                        },
                        child:
                            Container(
                              constraints: BoxConstraints(minHeight: 700),
                              alignment: Alignment.center,
                              child: const Projects(),
                            ).fadeInDown(
                              animate: aniproject,
                              duration: const Duration(milliseconds: 800),
                            ),
                      ),

                      VisibilityDetector(
                        key: contactKey,
                        onVisibilityChanged: (info) {
                          setState(() {
                            anicotact = info.visibleFraction > 0;
                          });
                        },
                        child:
                            Container(
                              constraints: BoxConstraints(minHeight: 700),
                              alignment: Alignment.center,
                              child: const Contact(),
                            ).fadeInUp(
                              animate: anicotact,
                              duration: const Duration(milliseconds: 800),
                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.copyright, size: 25, color: primaryColor),
                          SizedBox(width: 5),
                          Text(
                            "2025 ",
                            style: TextStyle(
                              color: sectionColor,
                              fontSize: 20,
                              fontFamily: 'Rubic',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "made by ",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 20,
                              fontFamily: 'Rubic',
                            ),
                          ),
                          Text(
                            "Mohamed Abdullah ",
                            style: TextStyle(
                              color: sectionColor,
                              fontSize: 20,
                              fontFamily: 'Rubic',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

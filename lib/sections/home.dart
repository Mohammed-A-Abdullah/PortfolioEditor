import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protofolio_edit/edit/home_edit.dart';
import 'package:protofolio_edit/edit/links_edit.dart';
import 'package:protofolio_edit/constant.dart';
import 'package:protofolio_edit/widgets/edit_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isHovered = false;
  bool isHoveredJob = false;
  bool isHoveredCV = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('home').snapshots(),
      builder: (context, homeSnapshot) {
        if (!homeSnapshot.hasData || homeSnapshot.data!.docs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
    
        final homeData = homeSnapshot.data!.docs.first;
        final profile = homeData['profile'];
        final title = homeData['title'];
        final job = homeData['job'];
        final cv = homeData['cv'];
    
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: sectionColor,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFEBD2).withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  profile,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
    
            const SizedBox(height: 25),
    
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Links')
                  .snapshots(),
              builder: (context, linkSnapshot) {
                if (!linkSnapshot.hasData ||
                    linkSnapshot.data!.docs.isEmpty) {
                  return const CircularProgressIndicator();
                }
    
                final docs = linkSnapshot.data!.docs;
                return Wrap(
                  spacing: 10,
                  children: docs.map((doc) {
                    final image = doc['image'];
                    final url = doc['url'];
                    return InkResponse(
                      onTap: () async {
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        }
                      },
                      radius: 25,
                      child: SvgPicture.string(
                        image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                          primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Rubic',
                color: isHovered ? sectionColor : primaryColor,
              ),
            ),
            const SizedBox(height: 15),
    
            Text(
              job,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Rubic',
                color: isHoveredJob ? sectionColor : primaryColor,
              ),
            ),
            const SizedBox(height: 24),
    
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse(cv))) {
                    await launchUrl(Uri.parse(cv));
                  }
                },
                label: const Text(
                  "Download CV",
                  style: TextStyle(fontSize: 20, fontFamily: 'Rubic'),
                ),
                icon: const Icon(Icons.file_download_outlined, size: 25),
                iconAlignment: IconAlignment.end,
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: 200,
              child: EditButton(page: HomeEdit(), text: 'Edit Home')),
            SizedBox(height: 15,),
            SizedBox(
              width: 200,
              child: EditButton(page: LinksEdit(), text: 'Edit Links')),
          ],
        );
      },
    );
  }
}

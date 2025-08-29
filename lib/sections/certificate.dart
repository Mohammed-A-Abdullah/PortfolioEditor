import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protofolio_edit/edit/certificate_edit.dart';
import 'package:protofolio_edit/sections/details/certficate_details.dart';
import 'package:protofolio_edit/constant.dart';
import 'package:protofolio_edit/widgets/edit_button.dart';

class Certificate extends StatefulWidget {
  const Certificate({super.key});

  @override
  State<Certificate> createState() => _ProjectsState();
}

class _ProjectsState extends State<Certificate> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  void _nextPage(int count) {
    if (_currentPage < count - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Certificate",
            style: TextStyle(
              fontSize: 35,
              fontFamily: "Rubic",
              fontWeight: FontWeight.bold,
              color: sectionColor,
            ),
          ),
          const SizedBox(height: 30),

          SizedBox(
            height: 500,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("certificate")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final project = docs[index];

                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double value = 1.0;
                            if (_pageController.position.haveDimensions) {
                              value = (_pageController.page! - index);
                              value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                            }
                            return Center(
                              child: SizedBox(
                                height: Curves.easeOut.transform(value) * 400,
                                width: Curves.easeOut.transform(value) * 800,
                                child: child,
                              ),
                            );
                          },
                          child: _CertificateCard(
                            id: project.id,
                            title: project["title"],
                            image: project["image"],
                          ),
                        );
                      },
                    ),

                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                        color: backgroundColor,
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 35,
                          color: sectionColor,
                        ),
                        onPressed: _previousPage,
                      ),
                    ),

                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                        color: backgroundColor,
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 35,
                          color: sectionColor,
                        ),
                        onPressed: () => _nextPage(docs.length),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 15,),
          EditButton(page: CertificateEdit(), text: "Edit certificate"),
        ],
      ),
    );
  }
}

class _CertificateCard extends StatefulWidget {
  final String id;
  final String title;
  final String image;

  const _CertificateCard({
    required this.id,
    required this.title,
    required this.image,
  });

  @override
  State<_CertificateCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_CertificateCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(widget.image, fit: BoxFit.cover),

          Container(
            color: Colors.black.withValues(alpha: 0.7),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Rubic",
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: sectionColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                CertficateDetails(projectId: widget.id),
                          ),
                        );
                      },
                      icon: Icon(Icons.notes, color: primaryColor),
                      label: const Text(
                        "Details",
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

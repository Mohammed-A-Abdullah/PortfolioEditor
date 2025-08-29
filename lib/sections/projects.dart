import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protofolio_edit/edit/project_edit.dart';
import 'package:protofolio_edit/sections/details/project_details.dart';
import 'package:protofolio_edit/constant.dart';
import 'package:protofolio_edit/widgets/edit_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
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
            "Projects",
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
                  .collection("project")
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
                                height: Curves.easeOut.transform(value) * 500,
                                width: Curves.easeOut.transform(value) * 800,
                                child: child,
                              ),
                            );
                          },
                          child: _ProjectCard(
                            id: project.id,
                            title: project["title"],
                            image: project["image"],
                            githubUrl: project["url"] ?? "",
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
          SizedBox(height: 15),
          EditButton(page: ProjectEdit(), text: "Edit Project"),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final String id;
  final String title;
  final String image;
  final String githubUrl;

  const _ProjectCard({
    required this.id,
    required this.title,
    required this.image,
    required this.githubUrl,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(widget.image, fit: BoxFit.cover),
    
          Opacity(
            opacity: 1,
            child: Container(
              color: Colors.black.withValues(alpha: 0.7),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Rubic",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.githubUrl.isNotEmpty)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: sectionColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _launchURL(widget.githubUrl),
                          icon: FaIcon(
                            FontAwesomeIcons.github,
                            color: primaryColor,
                          ),
                          label: const Text(
                            "GitHub",
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
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
                              builder: (context) => ProjectDetails(projectId: widget.id ,),
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
          ),
        ],
      ),
    );
  }
}

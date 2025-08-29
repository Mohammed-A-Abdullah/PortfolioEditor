import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protofolio_edit/constant.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final _formKey = GlobalKey<FormState>();
  bool isHovered = false;
  TextEditingController email = TextEditingController();
  TextEditingController content = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection("messages").add({
          "email": email.text.trim(),
          "message": content.text.trim(),
          "timestamp": FieldValue.serverTimestamp(),
          "isRead": false,
        });

        email.clear();
        content.clear();

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            width: 500,
            backgroundColor: sectionColor,
            content: const Center(
              child: Text(
                "Message Sent Successfully 👍",
                style: TextStyle(
                  fontFamily: 'Rubic',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        );
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(12),
            backgroundColor: sectionColor,
            content: Center(
              child: Text(
                "Error: $e",
                style: const TextStyle(
                  fontFamily: 'Rubic',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Contact Me',
            style: TextStyle(
              fontSize: 35,
              fontFamily: 'Rubic',
              fontWeight: FontWeight.bold,
              color: sectionColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 800;

              return isMobile
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 250,
                          child: Image.asset('images/contact.png'),
                        ),
                        SizedBox(height: 10),
                        _buildForm(constraints.maxWidth * 0.9),
                        const SizedBox(height: 40),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 500,
                          child: Image.asset('images/contact.png'),
                        ),
                        _buildForm(600),
                      ],
                    );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForm(double width) {
    return MouseRegion(
      onEnter: (event) => setState(() => isHovered = true),
      onExit: (event) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isHovered ? sectionColor : primaryColor,
            width: isHovered ? 2.5 : 1.5,
          ),
          color: cardColor,
          boxShadow: [
            if (isHovered)
              BoxShadow(
                color: sectionColor.withValues(alpha: 0.5),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    scale: isHovered ? 1.1 : 1.0,
                    child: Text(
                      'Message Me',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'PT_sans',
                        fontWeight: FontWeight.bold,
                        color: isHovered ? sectionColor : primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: email,
                  cursorColor: primaryColor,
                  cursorErrorColor: primaryColor,
                  style: const TextStyle(color: primaryColor, fontSize: 18),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    hintText: "Write your Email",
                    hintStyle: const TextStyle(color: primaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: sectionColor),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: content,
                  cursorColor: primaryColor,
                  cursorErrorColor: primaryColor,
                  maxLines: MediaQuery.of(context).size.width < 600 ? 3 : 6,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "Write your message",
                    hintStyle: const TextStyle(color: Color(0xffD7D7D7)),
                    contentPadding: const EdgeInsets.all(20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xffD7D7D7)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: sectionColor),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your message";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                MouseRegion(
                  onEnter: (event) => setState(() => isHovered = true),
                  onExit: (event) => setState(() => isHovered = false),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    scale: isHovered ? 1.0 : 0.9,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: isHovered
                            ? sectionColor
                            : primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _sendMessage,
                      child: Text(
                        "Send Message",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'PT_sans',
                          fontWeight: FontWeight.bold,
                          color: isHovered ? primaryColor : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

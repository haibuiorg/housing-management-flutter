import 'package:flutter/material.dart';

const contactUsPublicScreenRoute = '/contact-us';

class ContactUsPublicScreen extends StatefulWidget {
  const ContactUsPublicScreen({super.key});

  @override
  State<ContactUsPublicScreen> createState() => _ContactUsPublicScreenState();
}

class _ContactUsPublicScreenState extends State<ContactUsPublicScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/logo.png'),
        title: const Text('Contact Us'),
      ),
      body: const Center(
        child: Text('Contact Us'),
      ),
    );
  }
}

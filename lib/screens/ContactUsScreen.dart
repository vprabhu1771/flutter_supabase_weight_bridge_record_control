import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ContactUsScreen extends StatefulWidget {

  final String title;

  const ContactUsScreen({super.key, required this.title});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  // Function to launch the phone app with a specified phone number
  Future<void> _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await launcher.canLaunch(url)) {
      await launcher.launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to launch WhatsApp with a specified phone number
  Future<void> _launchWhatsApp(String phoneNumber) async {
    final whatsappUrl = 'https://wa.me/$phoneNumber';
    if (await launcher.canLaunch(whatsappUrl)) {
      await launcher.launch(whatsappUrl);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  // Function to launch Instagram
  Future<void> _launchInstagram() async {
    const instagramUrl = 'https://www.instagram.com/prasanna.g02/#';
    if (await launcher.canLaunch(instagramUrl)) {
      await launcher.launch(instagramUrl);
    } else {
      throw 'Could not launch Instagram';
    }
  }

  // Function to launch Gmail
  Future<void> _launchGmail(String email) async {
    final gmailUrl = 'mailto:$email';
    if (await launcher.canLaunch(gmailUrl)) {
      await launcher.launch(gmailUrl);
    } else {
      throw 'Could not launch Gmail';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 22)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Support Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.location_on, size: 40, color: Colors.green),
                    const SizedBox(height: 8),
                    const Text(
                      'ABC Weight Bridge, Cuddalore to Vadaloor Main Road, Subramaniyapuram, Cuddalore.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _buildContactButton(
                  icon: 'assets/support_icon/call_icon.png',
                  label: "Call",
                  onTap: () => _launchPhone('+918428019591'),
                ),
                _buildContactButton(
                  icon: 'assets/support_icon/whatsapp_icon.png',
                  label: "WhatsApp",
                  onTap: () => _launchWhatsApp('+918428019591'),
                ),
                _buildContactButton(
                  icon: 'assets/support_icon/instagram_icon.png',
                  label: "Instagram",
                  onTap: _launchInstagram,
                ),
                _buildContactButton(
                  icon: 'assets/support_icon/gmail_icon.png',
                  label: "Email",
                  onTap: () => _launchGmail('prasannaganesan1602@gmail.com'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({required String icon, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, blurRadius: 8, spreadRadius: 1),
              ],
            ),
            child: Image.asset(icon, width: 40, height: 40),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
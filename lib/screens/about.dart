import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  void _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contact Management App",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Version: $_appVersion", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Developed by:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Ewura Abena Opare - Ansah - 98322025",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Description:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              "This is a simple Contact Management App that allows users to add, edit, and delete contacts. "
              "The app is built using Flutter and integrates with a RESTful API.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

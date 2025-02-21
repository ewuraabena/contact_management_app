import 'package:flutter/material.dart'; // Import Flutter material package for UI components
import 'package:package_info_plus/package_info_plus.dart'; // Import package to get app version info

// AboutScreen is a StatefulWidget because it dynamically fetches the app version
class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion =
      "Loading..."; // Default text while fetching the app version

  @override
  void initState() {
    super.initState();
    _loadAppVersion(); // Fetch app version when the screen initializes
  }

  // Fetches the app version using PackageInfo plugin
  void _loadAppVersion() async {
    PackageInfo packageInfo =
        await PackageInfo.fromPlatform(); // Get package info
    setState(() {
      _appVersion = packageInfo.version; // Update state with fetched version
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')), // AppBar with title
      body: Padding(
        padding: EdgeInsets.all(16.0), // Add padding for better layout
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the left
          children: [
            // App Title
            Text(
              "Contact Management App",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10), // Add spacing

            // Display App Version
            Text("Version: $_appVersion", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20), // Add spacing

            // Developer Information
            Text("Developed by:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Ewura Abena Opare - Ansah - 98322025",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20), // Add spacing

            // App Description
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

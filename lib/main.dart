import 'package:flutter/material.dart'; // Import Flutter material package for UI components
import 'screens/contacts_list.dart'; // Import Contacts List screen
import 'screens/add_contact.dart'; // Import Add Contact screen
import 'screens/about.dart'; // Import About screen

// Main function that runs the app
void main() {
  runApp(ContactManagementApp()); // Runs the Contact Management app
}

// StatefulWidget is used because we need to track the selected tab in BottomNavigationBar
class ContactManagementApp extends StatefulWidget {
  @override
  _ContactManagementAppState createState() => _ContactManagementAppState();
}

class _ContactManagementAppState extends State<ContactManagementApp> {
  int _selectedIndex = 0; // Tracks the selected tab (default is 0)

  // List of screens corresponding to each BottomNavigationBar item
  final List<Widget> _screens = [
    ContactsListScreen(), // Contacts List screen
    AddContactScreen(), // Add Contact screen
    AboutScreen(), // About screen
  ];

  // Function to handle bottom navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner
      home: Scaffold(
        body: _screens[_selectedIndex], // Display the selected screen
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // Highlight selected tab
          onTap: _onItemTapped, // Call function when tab is tapped
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.contacts), label: "Contacts"), // Contacts tab
            BottomNavigationBarItem(
                icon: Icon(Icons.add), label: "Add Contact"), // Add Contact tab
            BottomNavigationBarItem(
                icon: Icon(Icons.info), label: "About"), // About tab
          ],
        ),
      ),
    );
  }
}

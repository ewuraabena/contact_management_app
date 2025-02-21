import 'package:flutter/material.dart';
import 'screens/contacts_list.dart';
import 'screens/add_contact.dart';
import 'screens/about.dart';

void main() {
  runApp(ContactManagementApp());
}

class ContactManagementApp extends StatefulWidget {
  @override
  _ContactManagementAppState createState() => _ContactManagementAppState();
}

class _ContactManagementAppState extends State<ContactManagementApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ContactsListScreen(),
    AddContactScreen(),
    AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.contacts), label: "Contacts"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Contact"),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
          ],
        ),
      ),
    );
  }
}

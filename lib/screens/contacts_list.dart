import 'package:flutter/material.dart'; // Import Flutter material package for UI components
import 'package:contact_management_app/services/api_services.dart'; // Import API service to fetch contact data
import 'package:contact_management_app/screens/edit_contact.dart'; // Import Edit Contact screen for editing contacts

// StatefulWidget is used because the contacts list updates dynamically
class ContactsListScreen extends StatefulWidget {
  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  final ApiService _apiService =
      ApiService(); // Instance of API service to handle API requests
  List<dynamic> _contacts = []; // List to store all contacts
  List<dynamic> _filteredContacts =
      []; // List to store filtered contacts (for search functionality)
  bool _isLoading = true; // Boolean to track loading state
  bool _hasError = false; // Boolean to track API call failure
  final TextEditingController _searchController =
      TextEditingController(); // Controller for search input field

  @override
  void initState() {
    super.initState();
    _fetchContacts(); // Fetch contacts when screen initializes
    _searchController
        .addListener(_filterContacts); // Attach listener to search input field
  }

  // Fetch contacts from API
  Future<void> _fetchContacts() async {
    setState(() {
      _isLoading = true; // Show loading indicator
      _hasError = false; // Reset error state
    });

    try {
      List<dynamic> contacts =
          await _apiService.getAllContacts(); // Fetch contacts from API
      setState(() {
        _contacts = contacts; // Store contacts
        _filteredContacts = contacts; // Initially, filtered list = full list
        _isLoading = false; // Hide loading indicator
      });
    } catch (e) {
      setState(() {
        _hasError = true; // Show error message
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Filter contacts based on search query
  void _filterContacts() {
    String query =
        _searchController.text.toLowerCase(); // Get lowercase search query
    setState(() {
      _filteredContacts = _contacts
          .where((contact) =>
              contact['pname']
                  .toLowerCase()
                  .contains(query) || // Filter by name
              contact['pphone'].contains(query)) // Filter by phone number
          .toList();
    });
  }

  // Delete a contact after confirmation
  void _deleteContact(int id) async {
    bool confirm = await _showDeleteConfirmation(); // Show confirmation dialog
    if (confirm) {
      bool success =
          await _apiService.deleteContact(id); // Call API to delete contact
      if (success) {
        _fetchContacts(); // Refresh contact list after deletion
      }
    }
  }

  // Show a confirmation dialog before deleting a contact
  Future<bool> _showDeleteConfirmation() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Delete Contact"), // Dialog title
            content: Text(
                "Are you sure you want to delete this contact?"), // Dialog message
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, false), // Cancel deletion
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, true), // Confirm deletion
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false; // Default to false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts List'), // Screen title
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching contacts
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Failed to load contacts."), // Show error message
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed:
                            _fetchContacts, // Retry button to reload contacts
                        child: Text("Retry"),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller:
                            _searchController, // Attach controller to text field
                        decoration: InputDecoration(
                          labelText: "Search", // Label for search field
                          prefixIcon: Icon(Icons.search), // Search icon
                          border: OutlineInputBorder(), // Add border styling
                        ),
                      ),
                    ),

                    // List of contacts
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            _filteredContacts.length, // Number of items in list
                        itemBuilder: (context, index) {
                          var contact =
                              _filteredContacts[index]; // Get current contact
                          return ListTile(
                            title: Text(contact['pname']), // Contact name
                            subtitle:
                                Text(contact['pphone']), // Contact phone number
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Edit button
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Colors.blue), // Edit icon
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditContactScreen(
                                        contactId:
                                            contact['pid'], // Pass contact ID
                                        initialName: contact[
                                            'pname'], // Pass initial name
                                        initialPhone: contact[
                                            'pphone'], // Pass initial phone number
                                      ),
                                    ),
                                  ).then((_) =>
                                      _fetchContacts()), // Refresh list after editing
                                ),

                                // Delete button
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.red), // Delete icon
                                  onPressed: () => _deleteContact(
                                      contact['pid']), // Call delete function
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}

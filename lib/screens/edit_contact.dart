import 'package:flutter/material.dart'; // Import Flutter material package for UI components
import 'package:contact_management_app/services/api_services.dart'; // Import API service to handle API calls

// StatefulWidget is used because we need to handle form input and API calls
class EditContactScreen extends StatefulWidget {
  final int contactId; // Contact ID to identify the contact being edited
  final String initialName; // Initial name of the contact (pre-filled)
  final String initialPhone; // Initial phone number of the contact (pre-filled)

  // Constructor requires the contact's ID, name, and phone number
  EditContactScreen({
    required this.contactId,
    required this.initialName,
    required this.initialPhone,
  });

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _formKey =
      GlobalKey<FormState>(); // Key to track form state and validation
  final _nameController =
      TextEditingController(); // Controller for name input field
  final _phoneController =
      TextEditingController(); // Controller for phone number input field
  final ApiService _apiService =
      ApiService(); // Instance of API service to handle requests
  bool _isLoading = false; // Boolean to track loading state during API call

  @override
  void initState() {
    super.initState();
    _nameController.text =
        widget.initialName; // Pre-fill name field with initial name
    _phoneController.text =
        widget.initialPhone; // Pre-fill phone field with initial phone number
  }

  // Function to update the contact
  void _updateContact() async {
    if (!_formKey.currentState!.validate())
      return; // Validate form fields before submitting

    setState(() =>
        _isLoading = true); // Show loading indicator while updating contact

    // Call API to edit contact and store the result
    bool success = await _apiService.editContact(
      widget.contactId, // Send contact ID
      _nameController.text, // Send updated name
      _phoneController.text, // Send updated phone number
    );

    setState(() => _isLoading = false); // Hide loading indicator after API call

    if (success) {
      // Show success message using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact updated successfully!')),
      );

      // Close screen and return success
      Navigator.pop(context, true);
    } else {
      // Show error message if API call fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update contact')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Contact')), // AppBar with title
      body: Padding(
        padding: EdgeInsets.all(16.0), // Add padding for better layout
        child: Form(
          key: _formKey, // Assign form key to track validation state
          child: Column(
            children: [
              // Input field for full name
              TextFormField(
                controller:
                    _nameController, // Attach controller to track user input
                decoration: InputDecoration(
                    labelText: 'Full Name'), // Input field label
                validator: (value) => value!.isEmpty
                    ? 'Please enter a name'
                    : null, // Validation rule
              ),

              // Input field for phone number
              TextFormField(
                controller:
                    _phoneController, // Attach controller to track user input
                decoration: InputDecoration(
                    labelText: 'Phone Number'), // Input field label
                keyboardType:
                    TextInputType.phone, // Set keyboard type to numeric
                validator: (value) => value!.isEmpty
                    ? 'Please enter a phone number'
                    : null, // Validation rule
              ),

              SizedBox(height: 20), // Add spacing between fields and button

              // Show loading indicator if API request is in progress, otherwise show button
              _isLoading
                  ? CircularProgressIndicator() // Loading animation
                  : ElevatedButton(
                      onPressed: _updateContact, // Call function to submit form
                      child: Text('Update Contact'), // Button text
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

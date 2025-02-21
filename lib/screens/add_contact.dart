import 'package:flutter/material.dart'; // Import Flutter material package for UI components
import 'package:contact_management_app/services/api_services.dart'; // Import API service to handle API calls

// StatefulWidget is used because we need to handle user input and API calls
class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey =
      GlobalKey<FormState>(); // Key to track form state and validation
  final _nameController =
      TextEditingController(); // Controller for name input field
  final _phoneController =
      TextEditingController(); // Controller for phone number input field
  final ApiService _apiService =
      ApiService(); // Instance of API service for handling requests

  bool _isLoading = false; // Boolean to track loading state during API call

  // Function to submit the form and add a contact
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Validate form fields
      setState(() => _isLoading = true); // Show loading indicator

      // Call API to add contact and store the result
      bool success = await _apiService.addContact(
        _nameController.text,
        _phoneController.text,
      );

      setState(
          () => _isLoading = false); // Hide loading indicator after API call

      if (success) {
        // Show success message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contact added successfully!')),
        );

        // Clear input fields after successful submission
        _nameController.clear();
        _phoneController.clear();
      } else {
        // Show error message if API call fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add contact')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Contact')), // AppBar with title
      body: Padding(
        padding: EdgeInsets.all(16.0), // Add padding for layout consistency
        child: Form(
          key: _formKey, // Assign form key to track validation state
          child: Column(
            children: [
              // Input field for full name
              TextFormField(
                controller:
                    _nameController, // Assign controller to track user input
                decoration: InputDecoration(
                    labelText: 'Full Name'), // Input field label
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name'; // Validation: Check if name is empty
                  }
                  return null; // No error
                },
              ),

              // Input field for phone number
              TextFormField(
                controller:
                    _phoneController, // Assign controller to track user input
                decoration: InputDecoration(
                    labelText: 'Phone Number'), // Input field label
                keyboardType:
                    TextInputType.phone, // Set keyboard type to numeric
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number'; // Validation: Check if phone is empty
                  } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Enter a valid phone number'; // Validation: Ensure only numbers are entered
                  }
                  return null; // No error
                },
              ),

              SizedBox(height: 20), // Add spacing between fields and button

              // Show loading indicator if API request is in progress, otherwise show button
              _isLoading
                  ? CircularProgressIndicator() // Loading animation
                  : ElevatedButton(
                      onPressed: _submitForm, // Call function to submit form
                      child: Text('Add Contact'), // Button text
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:dio/dio.dart'; // Import Dio package for handling HTTP requests
import 'dart:convert'; // Import for decoding JSON responses

class ApiService {
  final Dio _dio = Dio(); // Create an instance of Dio for API communication

  // Fetch all contacts from the API
  Future<List<dynamic>> getAllContacts() async {
    try {
      Response response = await _dio.get(
        "https://apps.ashesi.edu.gh/contactmgt/actions/get_all_contact_mob",
      );

      print(
          "Raw API Response: ${response.data}"); // Debugging: Print raw API response

      if (response.statusCode == 200) {
        if (response.data is String) {
          // Decode the JSON string manually if the response is a string
          return jsonDecode(response.data);
        } else if (response.data is List) {
          return response.data; // Return the list directly if already decoded
        } else {
          throw Exception(
              "Unexpected response format"); // Handle unexpected API response
        }
      } else {
        throw Exception(
            "Failed to load contacts, status: ${response.statusCode}"); // Handle API failure
      }
    } catch (e) {
      print("Error fetching contacts: $e"); // Debugging: Print error message
      throw Exception(
          "Failed to load contacts"); // Rethrow exception for UI handling
    }
  }

  // Fetch a single contact by ID
  Future<Map<String, dynamic>> getContact(int id) async {
    try {
      Response response = await _dio.get(
          "https://apps.ashesi.edu.gh/contactmgt/actions/get_a_contact_mob?contid=6");

      return response.data; // Return contact data as a map
    } catch (e) {
      throw Exception(
          "Failed to load contact"); // Handle error by throwing an exception
    }
  }

  // Add a new contact to the API
  Future<bool> addContact(String name, String phone) async {
    try {
      // Create form data for the API request
      FormData formData =
          FormData.fromMap({"ufullname": name, "uphonename": phone});

      // Send a POST request to add a contact
      Response response = await _dio.post(
          "https://apps.ashesi.edu.gh/contactmgt/actions/add_contact_mob",
          data: formData);

      return response.data ==
          "success"; // Check if the response indicates success
    } catch (e) {
      return false; // Return false if the request fails
    }
  }

  // Edit an existing contact
  Future<bool> editContact(int id, String name, String phone) async {
    try {
      // Create form data for updating contact details
      FormData formData =
          FormData.fromMap({"cid": id, "cname": name, "cnum": phone});

      // Send a POST request to update contact information
      Response response = await _dio.post(
          "https://apps.ashesi.edu.gh/contactmgt/actions/update_contact",
          data: formData);

      return response.data == "success"; // Check if update was successful
    } catch (e) {
      return false; // Return false if the request fails
    }
  }

  // Delete a contact by ID
  Future<bool> deleteContact(int id) async {
    try {
      // Create form data containing the contact ID to delete
      FormData formData = FormData.fromMap({"cid": id});

      // Send a POST request to delete the contact
      Response response = await _dio.post(
          "https://apps.ashesi.edu.gh/contactmgt/actions/delete_contact",
          data: formData);

      return response.statusCode ==
          200; // Return true if status code is 200 (successful request)
    } catch (e) {
      return false; // Return false if deletion fails
    }
  }
}

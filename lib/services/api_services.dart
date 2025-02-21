import 'package:dio/dio.dart';
import 'dart:convert';

class ApiService {
  final Dio _dio = Dio();

  Future<List<dynamic>> getAllContacts() async {
    try {
      Response response = await _dio.get(
        "https://apps.ashesi.edu.gh/contactmgt/actions/get_all_contact_mob",
      );

      print("Raw API Response: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is String) {
          // Decode the JSON string manually
          return jsonDecode(response.data);
        } else if (response.data is List) {
          return response.data;
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception(
            "Failed to load contacts, status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching contacts: $e");
      throw Exception("Failed to load contacts");
    }
  }

  Future<Map<String, dynamic>> getContact(int id) async {
    try {
      Response response = await _dio.get(
          "https://apps.ashesi.edu.gh/contactmgt/actions/get_a_contact_mob?contid=6");
      return response.data;
    } catch (e) {
      throw Exception("Failed to load contact");
    }
  }

  Future<bool> addContact(String name, String phone) async {
    try {
      FormData formData =
          FormData.fromMap({"ufullname": name, "uphonename": phone});
      Response response = await _dio.post(
          "https://apps.ashesi.edu.gh/contactmgt/actions/add_contact_mob",
          data: formData);
      return response.data == "success";
    } catch (e) {
      return false;
    }
  }

  Future<bool> editContact(int id, String name, String phone) async {
    try {
      FormData formData =
          FormData.fromMap({"cid": id, "cname": name, "cnum": phone});
      Response response = await _dio.post(
          "https://apps.ashesi.edu.gh/contactmgt/actions/update_contact",
          data: formData);
      return response.data == "success";
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteContact(int id) async {
    try {
      FormData formData = FormData.fromMap({"cid": id});
      Response response = await _dio.post(
          "https://apps.ashesi.edu.gh/contactmgt/actions/delete_contact",
          data: formData);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

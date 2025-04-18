import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000/api/auth';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // API: Sign Up
  Future<Map<String, dynamic>> signUp(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  // API: Login
  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Save the token after login
      await saveToken(data['token']);
      return data['token'];
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // API: Fetch Profile
  Future<Map<String, dynamic>> fetchProfile() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch profile: ${response.body}');
    }
  }

  // Save Token to Secure Storage
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  // Get Token from Secure Storage
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Clear Token from Secure Storage
  Future<void> clearToken() async {
    await _storage.delete(key: 'token');
  }
}

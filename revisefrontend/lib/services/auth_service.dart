import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final _storage = FlutterSecureStorage();
  final String baseUrl = 'http://localhost:5000/user';
  final String contentUrl = 'http://localhost:5000/content';

  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'token', value: data['token']);
      return true;
    } else {
      print('Registration failed: ${response.body}');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'token', value: data['token']);
      return true;
    } else {
      print('Login failed: ${response.body}');
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'token');
    if (token == null) return false;
    // Optionally, you can validate the token with a request to your backend
    final response = await http.get(
      Uri.parse('$baseUrl/validate-token'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  }

  Future<List<dynamic>> getTextContent() async {
  final token = await _storage.read(key: 'token');
  if (token == null) {
    print('No token found');
    return [];
  }
  
  final response = await http.get(
    Uri.parse(contentUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Failed to load content: ${response.body}');
    return [];
  }
}

  Future<bool> addTextContent(String title, String body) async {
    final token = await _storage.read(key: 'token');
    final response = await http.post(
      Uri.parse(contentUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'body': body,
      }),
    );

    return response.statusCode == 201;
  }

  Future<bool> updateTextContent(String id, String title, String body) async {
    final token = await _storage.read(key: 'token');
    final response = await http.put(
      Uri.parse('$contentUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'body': body,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteTextContent(String id) async {
    final token = await _storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse('$contentUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}

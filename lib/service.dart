import 'dart:convert';

import 'package:http/http.dart' as http;

class Service {
  static const baseURL = "http://localhost:1337";

  String? _token;
  set token(String? val) {
    _token = val;
  }

  Future<Map<String, dynamic>> get(String path) async {
    final uri = Uri.parse(baseURL + path);
    final headers = <String, String>{};
    if (_token != null) {
      headers['Authorization'] = "Bearer $_token";
    }
    final result = await http.get(uri, headers: headers);
    if (result.statusCode >= 400) throw result.body;
    return jsonDecode(result.body);
  }

  Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> data) async {
    final uri = Uri.parse(baseURL + path);
    final headers = <String, String>{};
    if (_token != null) {
      headers['Authorization'] = "Bearer $_token";
    }
    final result = await http.post(uri, headers: headers, body: data);
    if (result.statusCode >= 400) throw result.body;
    return jsonDecode(result.body);
  }
}

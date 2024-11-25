import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String parseServerUrl = 'https://parseapi.back4app.com';
  static const String applicationId = '0Vm3pNphvVBZvvr9aW1gtIsENJN1KxD6PfqC2WWB';
  static const String restApiKey = '235DtdXOtK2WppkSOAjkk4sdJbsIlYSOikNA8iFk';
  static const String clientKey = 'xG1k4ebCYpY0afagNPw3HQdXuQYG8xJVa2jlDGo7';

  Future<Map<String, dynamic>> signUp(String username, String password, String email, String firstName, String lastName) async {
    final response = await http.post(
      Uri.parse('$parseServerUrl/users'),
      headers: <String, String>{
        'X-Parse-Application-Id': applicationId,
        'X-Parse-REST-API-Key': restApiKey,
        'X-Parse-Client-Key': clientKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'password': password,
        'email': email,
        'firstName':firstName,
        'lastName':lastName
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.get(
      Uri.parse('$parseServerUrl/login?username=$username&password=$password'),
      headers: <String, String>{
        'X-Parse-Application-Id': applicationId,
        'X-Parse-REST-API-Key': restApiKey,
        'X-Parse-Client-Key': clientKey,
      },
    );
    return jsonDecode(response.body);
  }
}

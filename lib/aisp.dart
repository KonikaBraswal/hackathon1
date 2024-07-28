import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

Future<void> retrieveAccessToken() async {
  final String configPath = 'lib/aispconfig.json';
  final String sandboxPath = 'lib/aispsandbox.json';

  // Load configuration files
  final configData = await _loadJsonFile(configPath);
  final sandboxData = await _loadJsonFile(sandboxPath);

  final String baseUrl = configData['baseUrl'];
  final String tokenEndpoint = sandboxData['tokenEndpoint'];
  final String clientId = configData['clientId'];
  final String clientSecret = configData['clientSecret'];
  final String grantType = sandboxData['grant_type'];

  final url = Uri.parse('$baseUrl/$tokenEndpoint');
  final headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  final body = {
    'grant_type': grantType,
    'client_id': clientId,
    'client_secret': clientSecret,
    'scope': 'accounts',
  };

  // Convert the body to URL encoded format
  final encodedBody = body.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');

  print('Request URL: $url');
  print('Request Headers: $headers');
  print('Request Body: $encodedBody');

  try {
    final response = await http.post(url, headers: headers, body: encodedBody);

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // Handle the access token response here
      print('Access Token: ${responseData['access_token']}');
    } else {
      print('Failed to retrieve access token: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while retrieving access token: $e');
  }
}

Future<Map<String, dynamic>> _loadJsonFile(String path) async {
  final data = await File(path).readAsString();
  return jsonDecode(data);
}

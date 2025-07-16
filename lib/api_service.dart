import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'my_path_model.dart';
import 'path_detail_model.dart';

class ApiService {
  static String get _baseUrl {
    // Point back to the secure HTTPS endpoints
    if (Platform.isAndroid) {
      // For a physical device, use your computer's local IP.
      // For the emulator, use 10.0.2.2.
      return 'https://10.0.2.2:7251/api'; 
    } else {
      return 'https://localhost:7251/api';
    }
  }

  // Restored the IOClient helper to handle self-signed certificates
  IOClient _createIOClient() {
    final client = HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    return IOClient(client);
  }

  Future<List<MyPath>> fetchMyPaths() async {
    try {
      final ioClient = _createIOClient();
      final response = await ioClient.get(Uri.parse('$_baseUrl/paths')).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => MyPath.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load paths. Status code: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      throw Exception('Failed to load paths: $e');
    }
  }

  Future<LearningPathDetail> fetchPathDetails(int pathId) async {
    try {
      final ioClient = _createIOClient();
      final response = await ioClient.get(Uri.parse('$_baseUrl/paths/$pathId'));
      if (response.statusCode == 200) {
        return LearningPathDetail.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load path details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load path details: $e');
    }
  }
  
  Future<PathItemDetail> togglePathItemCompletion(int itemId) async {
    try {
      final ioClient = _createIOClient();
      final response = await ioClient.patch(
        Uri.parse('$_baseUrl/paths/items/$itemId/toggle-completion'),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return PathItemDetail.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update item. Status code: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('The request timed out.');
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  Future<ResourceDetail> toggleResourceCompletion(int resourceId) async {
    try {
      final ioClient = _createIOClient();
      final response = await ioClient.patch(
        Uri.parse('$_baseUrl/paths/resources/$resourceId/toggle-completion'),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return ResourceDetail.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update resource. Status code: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('The request timed out.');
    } catch (e) {
      throw Exception('Failed to update resource: $e');
    }
  }

  Future<LearningPathDetail> createLearningPath(String prompt) async {
    try {
      final ioClient = _createIOClient();
      final response = await ioClient.post(
        Uri.parse('$_baseUrl/paths'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'prompt': prompt}),
      ).timeout(const Duration(seconds: 120));

      if (response.statusCode == 201) {
        return LearningPathDetail.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create path. Status code: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('The request timed out. Please try again.');
    } catch (e) {
      throw Exception('Failed to create path: $e');
    }
  }
}

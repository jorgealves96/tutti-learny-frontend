import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import '../models/my_path_model.dart';
import '../models/path_detail_model.dart';
import 'auth_service.dart';
import '../models/profile_stats_model.dart';
import '../models/path_suggestion_model.dart';
import 'package:flutter/foundation.dart';
import '../models/subscription_status_model.dart';

class ApiService {
  static String get _baseUrl {
    // Use local URLs ONLY when in debug mode
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'https://10.0.2.2:7251/api'; // local API
        // return 'https://tutti-learni-api-215912661867.europe-west1.run.app/api'; // deployed API
      } else {
        return 'https://10.0.2.2:7251/api';
      }
    }

    // For all other modes (release, profile), use the deployed cloud URL.
    return 'https://tutti-learni-api-215912661867.europe-west1.run.app/api';
  }

  IOClient _createIOClient() {
    final client = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    return IOClient(client);
  }

  // Updated helper method to get the Firebase ID token
  Future<Map<String, String>> _getHeaders() async {
    final idToken = await AuthService.getIdToken();
    if (idToken == null) {
      throw Exception('Not authenticated');
    }
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $idToken',
    };
  }

  // New method to sync the user profile with the backend
  Future<void> syncUser() async {
    try {
      final ioClient = _createIOClient();
      final headers = await _getHeaders();
      final response = await ioClient.post(
        Uri.parse('$_baseUrl/users/sync'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to sync user. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to sync user: $e');
    }
  }

  Future<List<MyPath>> fetchMyPaths() async {
    try {
      final ioClient = _createIOClient();
      final headers = await _getHeaders();
      final response = await ioClient
          .get(
            Uri.parse('$_baseUrl/paths'),
            headers: headers, // Add headers here
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => MyPath.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to load paths. Status code: ${response.statusCode}',
        );
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
      final headers = await _getHeaders();
      final response = await ioClient.get(
        Uri.parse('$_baseUrl/paths/$pathId'),
        headers: headers, // Add headers here
      );
      if (response.statusCode == 200) {
        return LearningPathDetail.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to load path details. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load path details: $e');
    }
  }

  Future<PathItemDetail> togglePathItemCompletion(int itemId) async {
    try {
      final ioClient = _createIOClient();
      final headers = await _getHeaders();
      final response = await ioClient
          .patch(
            Uri.parse('$_baseUrl/paths/items/$itemId/toggle-completion'),
            headers: headers, // Add headers here
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        return PathItemDetail.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to update item. Status code: ${response.statusCode}',
        );
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
      final headers = await _getHeaders();
      final response = await ioClient
          .patch(
            Uri.parse(
              '$_baseUrl/paths/resources/$resourceId/toggle-completion',
            ),
            headers: headers, // Add headers here
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        return ResourceDetail.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to update resource. Status code: ${response.statusCode}',
        );
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
      final headers = await _getHeaders();
      final response = await ioClient
          .post(
            Uri.parse('$_baseUrl/paths/generate'),
            headers: headers,
            body: jsonEncode({'prompt': prompt}),
          )
          .timeout(const Duration(seconds: 120));

      if (response.statusCode == 201) {
        return LearningPathDetail.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400 || response.statusCode == 429) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'An error occurred.');
      } else {
        throw Exception(
          'Failed to create path. Status code: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('The request timed out. Please try again.');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePath(int pathId) async {
    try {
      final ioClient = _createIOClient();
      final headers = await _getHeaders();
      final response = await ioClient
          .delete(
            Uri.parse('$_baseUrl/paths/$pathId'),
            headers: headers, // Add headers here
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 204) {
        throw Exception(
          'Failed to delete path. Status code: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('The request timed out.');
    } catch (e) {
      throw Exception('Failed to delete path: $e');
    }
  }

  Future<ProfileStats> fetchProfileStats() async {
    try {
      final ioClient = _createIOClient();
      final headers = await _getHeaders();
      final response = await ioClient.get(
        Uri.parse('$_baseUrl/profile/stats'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return ProfileStats.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to load profile stats. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load profile stats: $e');
    }
  }

  Future<void> updateUserName(String newName) async {
    try {
      final ioClient = _createIOClient();
      final headers = await _getHeaders();
      final response = await ioClient.patch(
        Uri.parse('$_baseUrl/users/name'),
        headers: headers,
        body: jsonEncode({'newName': newName}),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to update name. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to update name: $e');
    }
  }

  Future<List<PathSuggestion>> fetchSuggestions(String prompt) async {
    try {
      final ioClient = _createIOClient();
      final headers = await _getHeaders();
      final response = await ioClient
          .post(
            Uri.parse('$_baseUrl/paths/suggestions'),
            headers: headers,
            body: jsonEncode({'prompt': prompt}),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body
            .map((dynamic item) => PathSuggestion.fromJson(item))
            .toList();
      } else {
        throw Exception(
          'Failed to load suggestions. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load suggestions: $e');
    }
  }

  Future<LearningPathDetail> assignPath(int templateId) async {
    try {
      final ioClient = _createIOClient();
      final headers = await _getHeaders();
      final response = await ioClient
          .post(
            Uri.parse('$_baseUrl/paths/templates/$templateId/assign'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 201) {
        // 201 Created
        return LearningPathDetail.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to assign path. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to assign path: $e');
    }
  }

  Future<List<PathItemDetail>> extendLearningPath(int userPathId) async {
    try {
      final ioClient = _createIOClient();
      final headers = await _getHeaders();
      final response = await ioClient
          .post(
            Uri.parse('$_baseUrl/paths/$userPathId/extend'),
            headers: headers,
          )
          .timeout(
            const Duration(seconds: 90),
          ); // A 1.5-minute timeout is reasonable

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body
            .map((dynamic item) => PathItemDetail.fromJson(item))
            .toList();
      } else if (response.statusCode == 429 || response.statusCode == 404) {
        // Handle usage limits (429) or path not found (404)
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'An error occurred.');
      } else {
        throw Exception(
          'Failed to extend path. Status code: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('The request to extend the path timed out.');
    } catch (e) {
      // Rethrow the exception to preserve the clean error message
      rethrow;
    }
  }

  // In services/api_service.dart
  Future<SubscriptionStatus> fetchSubscriptionStatus() async {
    try {
      final ioClient = _createIOClient();
      final headers = await _getHeaders();

      final response = await ioClient
          .get(
            Uri.parse('$_baseUrl/users/me/subscription-status'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return SubscriptionStatus.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        // If user is not found, it's a new account. Return default free status.
        return SubscriptionStatus.freeTier();
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(
          errorBody['message'] ?? 'Failed to load subscription status',
        );
      }
    } on TimeoutException {
      throw Exception('The request for subscription status timed out.');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    final ioClient = _createIOClient();
    final headers = await _getHeaders();
    final response = await ioClient.delete(
      Uri.parse('$_baseUrl/users/me'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete account.');
    }
  }

  Future<void> updateSubscription(int tier, bool isYearly) async {
    final ioClient = _createIOClient();
    final headers = await _getHeaders();
    final response = await ioClient.post(
      Uri.parse('$_baseUrl/subscriptions/update'),
      headers: headers,
      body: jsonEncode({'tier': tier, 'isYearly': isYearly}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update subscription.');
    }
  }

  Future<void> ratePath(int pathTemplateId, int rating) async {
    final ioClient = _createIOClient();
    final headers = await _getHeaders();
    final response = await ioClient.post(
      Uri.parse('$_baseUrl/paths/$pathTemplateId/rate'),
      headers: headers,
      body: jsonEncode({'Rating': rating}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit rating.');
    }
  }
}

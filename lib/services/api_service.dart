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
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/path_report_model.dart';
import '../models/quiz_model.dart';
import '../models/quiz_history_model.dart';
import '../models/user_answer_model.dart';
import '../models/quiz_review_model.dart';

class ApiService {
  static String get _baseUrl {
    // Use local URLs ONLY when in debug modeW
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'https://10.0.2.2:7251/api'; // local API
        //return 'https://tutti-learni-api-215912661867.europe-west1.run.app/api'; // deployed API
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
      } else {
        String errorMessage;
        try {
          final body = jsonDecode(response.body);
          errorMessage =
              body['message'] ??
              'An unknown error occurred. Status code: ${response.statusCode}';
        } catch (_) {
          // If the response body isn't valid JSON, use a generic error.
          errorMessage =
              'Failed to create path. Status code: ${response.statusCode}';
        }
        throw Exception(errorMessage);
      }
    } on TimeoutException {
      throw Exception('The request timed out. Please try again.');
    } catch (e) {
      // Re-throw the exception to pass it to the UI.
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
      } else if (response.statusCode == 429) {
        final body = jsonDecode(response.body);
        final errorMessage = body['message'] ?? 'Usage limit reached.';
        throw Exception(errorMessage);
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

  Future<void> updateFcmToken(String token) async {
    try {
      final ioClient = _createIOClient();
      final headers = await _getHeaders();
      await ioClient.post(
        Uri.parse('$_baseUrl/users/me/fcm-token'),
        headers: headers,
        body: jsonEncode({'fcmToken': token}),
      );
    } catch (e) {
      // It's okay to fail silently here, as it can be retried on the next login
      print("Failed to update FCM token: $e");
    }
  }

  Future<void> updateNotificationPreference(bool isEnabled) async {
    final ioClient = _createIOClient();
    final headers = await _getHeaders();
    final response = await ioClient.post(
      Uri.parse('$_baseUrl/users/me/notification-preference'),
      headers: headers,
      body: jsonEncode({'isEnabled': isEnabled}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update notification preference.');
    }
  }

  Future<void> submitPathReport(
    int pathTemplateId,
    ReportType reportType,
    String? description,
  ) async {
    final ioClient = _createIOClient();
    final headers = await _getHeaders();
    final response = await ioClient.post(
      Uri.parse('$_baseUrl/reports'),
      headers: headers,
      body: jsonEncode({
        'pathTemplateId': pathTemplateId,
        'reportType': reportType.index, // Send the enum's integer value
        'description': description,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit report.');
    }
  }

  Future<void> postLoginSetup() async {
    try {
      // First, sync the user to create/update their record
      await syncUser();

      // NOW, get the FCM token and send it to the backend
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await updateFcmToken(fcmToken);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error during post-login setup: $e");
      }
    }
  }

  Future<PathReport?> fetchPathReport(int pathTemplateId) async {
    try {
      final ioClient = _createIOClient();
      final headers = await _getHeaders();
      final response = await ioClient.get(
        Uri.parse('$_baseUrl/reports/status/$pathTemplateId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return PathReport.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch report status.');
      }
    } catch (e) {
      print("Error fetching path report: $e");
      rethrow;
    }
  }

  Future<void> acknowledgeReport(int pathTemplateId) async {
    try {
      final ioClient = _createIOClient();
      final headers = await _getHeaders();
      final response = await ioClient.post(
        Uri.parse('$_baseUrl/reports/$pathTemplateId/acknowledge'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to acknowledge report.');
      }
    } catch (e) {
      print("Error acknowledging report: $e");
      rethrow;
    }
  }

  Future<List<QuizResultSummary>> fetchQuizHistory(int pathTemplateId) async {
    final ioClient = _createIOClient();
    final headers = await _getHeaders();
    final response = await ioClient.get(
      Uri.parse('$_baseUrl/quizzes/history/$pathTemplateId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body
          .map((dynamic item) => QuizResultSummary.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load quiz history.');
    }
  }

  Future<Quiz> generateQuiz(int pathTemplateId) async {
    final ioClient = _createIOClient();
    final headers = await _getHeaders();
    final response = await ioClient.post(
      Uri.parse('$_baseUrl/quizzes/generate/$pathTemplateId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Quiz.fromJson(jsonDecode(response.body));
    } else {
      final body = jsonDecode(response.body);
      final errorMessage = body['message'] ?? 'Failed to generate quiz.';
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, int>> submitQuizResult(
    int quizId,
    List<UserAnswer> answers, {
    bool isFinalSubmission = true, // Default to true
  }) async {
    final ioClient = _createIOClient();
    final headers = await _getHeaders();
    // Append the query parameter to the URL
    final url =
        '$_baseUrl/quizzes/$quizId/submit?isFinalSubmission=$isFinalSubmission';

    final response = await ioClient.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({'answers': answers.map((a) => a.toJson()).toList()}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return {
        'score': body['score'],
        'total': body['totalQuestions'],
        'quizResultId': body['quizResultId'],
      };
    } else {
      throw Exception('Failed to submit quiz result.');
    }
  }

  Future<QuizReview> fetchQuizResultDetails(int quizResultId) async {
    final ioClient = _createIOClient();
    final headers = await _getHeaders();
    final response = await ioClient.get(
      Uri.parse('$_baseUrl/quizzes/results/$quizResultId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return QuizReview.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load quiz details.');
    }
  }

  Future<Quiz> fetchQuizDetails(int quizResultId) async {
    final ioClient = _createIOClient();
    final headers = await _getHeaders();
    final response = await ioClient.get(
      Uri.parse('$_baseUrl/quizzes/$quizResultId/details'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Quiz.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch quiz details.');
    }
  }

  Future<Quiz> resumeQuiz(int quizResultId) async {
    final ioClient = _createIOClient();
    final headers = await _getHeaders();
    final response = await ioClient.get(
      Uri.parse('$_baseUrl/quizzes/$quizResultId/resume'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Quiz.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to resume quiz.');
    }
  }
}

enum ReportType { InaccurateContent, BrokenLinks, InappropriateContent, Other }

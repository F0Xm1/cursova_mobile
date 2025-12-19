import 'package:cours_work/data/models/poll.dart';
import 'package:cours_work/data/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PollsService {
  final Dio _dio = ApiClient.dio;

  Future<Poll?> getPoll(int pollId) async {
    try {
      final Response<Map<String, dynamic>> res =
          await _dio.get<Map<String, dynamic>>(
        '/polls/$pollId',
        options: Options(
          headers: {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'},
        ),
      );

      if (res.data == null) return null;
      return Poll.fromJson(res.data!);
    } catch (e) {
      debugPrint('❌ getPoll error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> votePoll({
    required int pollId,
    required String selectedOption,
  }) async {
    try {
      final Response<Map<String, dynamic>> res =
          await _dio.post<Map<String, dynamic>>(
        '/polls/$pollId/vote',
        data: {
          'selected_option': selectedOption,
        },
      );

      return res.data ?? {};
    } catch (e) {
      debugPrint('❌ votePoll error: $e');
      rethrow;
    }
  }
}


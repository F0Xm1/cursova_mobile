import 'package:cours_work/data/models/subscription.dart';
import 'package:cours_work/data/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SubscriptionService {
  final Dio _dio = ApiClient.dio;

  Future<Subscription> buySubscription(String type) async {
    try {
      final Response<Map<String, dynamic>> res =
          await _dio.post<Map<String, dynamic>>(
        '/subscription/buy',
        data: {
          'type': type,
        },
      );

      if (res.data == null) {
        throw Exception('Failed to buy subscription');
      }

      return Subscription.fromJson(res.data!);
    } catch (e) {
      debugPrint('❌ buySubscription error: $e');
      rethrow;
    }
  }

  Future<Subscription?> getSubscriptionStatus() async {
    try {
      final Response<Map<String, dynamic>> res =
          await _dio.get<Map<String, dynamic>>(
        '/subscription/status',
        options: Options(
          headers: {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'},
        ),
      );

      if (res.data == null) return null;
      return Subscription.fromJson(res.data!);
    } catch (e) {
      debugPrint('❌ getSubscriptionStatus error: $e');
      return null;
    }
  }
}


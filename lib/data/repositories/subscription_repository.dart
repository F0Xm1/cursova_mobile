import 'package:cours_work/data/models/subscription.dart';
import 'package:cours_work/data/services/subscription_service.dart';
import 'package:flutter/material.dart';

class SubscriptionRepository {
  final SubscriptionService _service = SubscriptionService();

  Future<Subscription> buySubscription(String type) async {
    try {
      return await _service.buySubscription(type);
    } catch (e) {
      debugPrint('❌ buySubscription error: $e');
      rethrow;
    }
  }

  Future<Subscription?> getSubscriptionStatus() async {
    try {
      return await _service.getSubscriptionStatus();
    } catch (e) {
      debugPrint('❌ getSubscriptionStatus error: $e');
      return null;
    }
  }
}


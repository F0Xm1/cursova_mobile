import 'package:cours_work/data/models/poll.dart';
import 'package:cours_work/data/services/polls_service.dart';
import 'package:flutter/material.dart';

class PollsRepository {
  final PollsService _service = PollsService();

  Future<Poll?> fetchPoll(int pollId) async {
    try {
      return await _service.getPoll(pollId);
    } catch (e) {
      debugPrint('❌ fetchPoll error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> votePoll({
    required int pollId,
    required String selectedOption,
  }) async {
    try {
      return await _service.votePoll(
        pollId: pollId,
        selectedOption: selectedOption,
      );
    } catch (e) {
      debugPrint('❌ votePoll error: $e');
      rethrow;
    }
  }
}


import 'package:cours_work/core/app_colors.dart';
import 'package:cours_work/core/fonts.dart'; //
import 'package:cours_work/data/models/poll.dart';
import 'package:flutter/material.dart';

class PollWidget extends StatefulWidget {
  final Poll poll;
  final Function(String)? onVote;

  const PollWidget({
    super.key,
    required this.poll,
    this.onVote,
  });

  @override
  State<PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  String? _selectedOption;
  bool _hasVoted = false;

  void _handleVote(String option) {
    if (_hasVoted) return;

    setState(() {
      _selectedOption = option;
      _hasVoted = true;
    });

    widget.onVote?.call(option);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.poll.question,
            style: AppFonts.merriweather(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 20),

          ...widget.poll.options.map((option) {
            final isSelected = _selectedOption == option;
            final voteCount = widget.poll.results[option] ?? 0;
            final totalVotes = widget.poll.results.values.fold(0, (a, b) => a + b);
            final percentage = totalVotes > 0 ? (voteCount / totalVotes * 100) : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: _hasVoted ? null : () => _handleVote(option),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.white.withOpacity(0.1),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option,
                          style: AppFonts.lato(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      if (_hasVoted)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: AppFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
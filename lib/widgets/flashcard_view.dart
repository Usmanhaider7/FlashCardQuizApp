import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../utils/app_colors.dart';

/// Displays the current flashcard's question, and the answer once revealed.
/// Uses a subtle scale + fade transition to feel like a card "flip"
/// without needing a full 3D transform.
class FlashcardView extends StatelessWidget {
  final FlashcardModel card;
  final bool showAnswer;
  final VoidCallback onToggleAnswer;

  const FlashcardView({
    super.key,
    required this.card,
    required this.showAnswer,
    required this.onToggleAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 320),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: showAnswer ? AppColors.cardBack : AppColors.cardFront,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              card.category,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Column(
              key: ValueKey(showAnswer),
              children: [
                Text(
                  showAnswer ? 'ANSWER' : 'QUESTION',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  showAnswer ? card.answer : card.question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: onToggleAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  showAnswer ? Colors.white : AppColors.primary,
              foregroundColor:
                  showAnswer ? AppColors.primary : Colors.white,
              side: showAnswer
                  ? const BorderSide(color: AppColors.primary)
                  : BorderSide.none,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(showAnswer ? 'Hide Answer' : 'Show Answer'),
          ),
        ],
      ),
    );
  }
}

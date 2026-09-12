import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/flashcard_model.dart';
import '../services/hive_service.dart';

class FlashcardProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  int _currentIndex = 0;
  bool _showAnswer = false;

  List<FlashcardModel> get allCards {
    final list = HiveService.flashcardsBox.values.toList();
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  int get currentIndex => _currentIndex;
  bool get showAnswer => _showAnswer;
  int get totalCards => allCards.length;

  FlashcardModel? get currentCard {
    final cards = allCards;
    if (cards.isEmpty) return null;
    if (_currentIndex >= cards.length) _currentIndex = cards.length - 1;
    if (_currentIndex < 0) _currentIndex = 0;
    return cards[_currentIndex];
  }

  bool get hasNext => _currentIndex < totalCards - 1;
  bool get hasPrevious => _currentIndex > 0;

  void next() {
    if (hasNext) {
      _currentIndex++;
      _showAnswer = false;
      notifyListeners();
    }
  }

  void previous() {
    if (hasPrevious) {
      _currentIndex--;
      _showAnswer = false;
      notifyListeners();
    }
  }

  void toggleAnswer() {
    _showAnswer = !_showAnswer;
    notifyListeners();
  }

  void resetFlip() {
    _showAnswer = false;
    notifyListeners();
  }

  Future<void> addCard({
    required String question,
    required String answer,
    String category = 'General',
  }) async {
    final card = FlashcardModel(
      id: _uuid.v4(),
      question: question,
      answer: answer,
      category: category,
      createdAt: DateTime.now(),
    );
    await HiveService.flashcardsBox.put(card.id, card);

    // Jump to the newly added card so the user sees it right away.
    _currentIndex = allCards.length - 1;
    _showAnswer = false;
    notifyListeners();
  }

  Future<void> updateCard(
    String id, {
    required String question,
    required String answer,
    required String category,
  }) async {
    final card = HiveService.flashcardsBox.get(id);
    if (card == null) return;
    card.question = question;
    card.answer = answer;
    card.category = category;
    await card.save();
    notifyListeners();
  }

  Future<void> deleteCard(String id) async {
    await HiveService.flashcardsBox.delete(id);
    // Keep the current index in range for whatever cards remain.
    final remaining = allCards.length;
    if (_currentIndex >= remaining) {
      _currentIndex = remaining > 0 ? remaining - 1 : 0;
    }
    _showAnswer = false;
    notifyListeners();
  }

  void jumpTo(int index) {
    if (index >= 0 && index < totalCards) {
      _currentIndex = index;
      _showAnswer = false;
      notifyListeners();
    }
  }
}

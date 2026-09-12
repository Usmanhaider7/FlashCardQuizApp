import 'package:hive_flutter/hive_flutter.dart';
import '../models/flashcard_model.dart';

/// Handles Hive setup. Call [HiveService.init] once before runApp().
class HiveService {
  static const String flashcardsBoxName = 'flashcards';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(FlashcardModelAdapter());
    await Hive.openBox<FlashcardModel>(flashcardsBoxName);
  }

  static Box<FlashcardModel> get flashcardsBox =>
      Hive.box<FlashcardModel>(flashcardsBoxName);
}

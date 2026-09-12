import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'models/flashcard_model.dart';
import 'providers/flashcard_provider.dart';
import 'screens/home_screen.dart';
import 'services/hive_service.dart';
import 'utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await _seedSampleCardsIfEmpty();
  runApp(const FlashcardQuizApp());
}

/// Adds a couple of sample flashcards on first launch only, so the app
/// isn't empty the very first time it's opened. Safe to remove or edit.
Future<void> _seedSampleCardsIfEmpty() async {
  final box = HiveService.flashcardsBox;
  if (box.isNotEmpty) return;

  const uuid = Uuid();
  const samples = [
    ('What is the capital of France?', 'Paris', 'Geography'),
    ('What does CPU stand for?', 'Central Processing Unit', 'Computer Science'),
    ('What is 7 x 8?', '56', 'Math'),
  ];

  for (final (question, answer, category) in samples) {
    final card = FlashcardModel(
      id: uuid.v4(),
      question: question,
      answer: answer,
      category: category,
      createdAt: DateTime.now(),
    );
    await box.put(card.id, card);
  }
}

class FlashcardQuizApp extends StatelessWidget {
  const FlashcardQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlashcardProvider()),
      ],
      child: MaterialApp(
        title: 'Flashcard Quiz',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          brightness: Brightness.light,
          fontFamily: 'Roboto',
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.success,
            surface: Colors.white,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

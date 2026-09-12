import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard_model.dart';
import '../providers/flashcard_provider.dart';
import '../utils/app_colors.dart';

/// Shared form for adding a new flashcard or editing an existing one.
/// Pass [existingCard] to edit; leave null to add a new card.
class AddEditFlashcardScreen extends StatefulWidget {
  final FlashcardModel? existingCard;

  const AddEditFlashcardScreen({super.key, this.existingCard});

  @override
  State<AddEditFlashcardScreen> createState() => _AddEditFlashcardScreenState();
}

class _AddEditFlashcardScreenState extends State<AddEditFlashcardScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionController;
  late final TextEditingController _answerController;
  late final TextEditingController _categoryController;

  bool get _isEditing => widget.existingCard != null;

  @override
  void initState() {
    super.initState();
    _questionController =
        TextEditingController(text: widget.existingCard?.question ?? '');
    _answerController =
        TextEditingController(text: widget.existingCard?.answer ?? '');
    _categoryController =
        TextEditingController(text: widget.existingCard?.category ?? 'General');
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<FlashcardProvider>();

    if (_isEditing) {
      await provider.updateCard(
        widget.existingCard!.id,
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
        category: _categoryController.text.trim().isEmpty
            ? 'General'
            : _categoryController.text.trim(),
      );
    } else {
      await provider.addCard(
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
        category: _categoryController.text.trim().isEmpty
            ? 'General'
            : _categoryController.text.trim(),
      );
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(_isEditing ? 'Edit Flashcard' : 'Add Flashcard'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _questionController,
              maxLines: 3,
              decoration: _decoration('Question', hint: "What's on the front?"),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Question is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _answerController,
              maxLines: 3,
              decoration: _decoration('Answer', hint: "What's on the back?"),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Answer is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoryController,
              decoration:
                  _decoration('Category (optional)', hint: 'e.g. Biology, History'),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Save Changes' : 'Add Flashcard',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

class Exam {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;

  Exam({required this.id, required this.title, required this.description, required this.questions});
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final List<int>? correctAnswers;
  final String explanation;

  static const List<String> _paddingPhrases = [
    'This approach represents a different methodology.',
    'While possible, this differs from the primary objective.',
    'This setup might be utilized under alternative conditions.',
    'This choice represents an alternative configuration.',
    'This method may be considered in different scenarios.',
    'This strategy applies when different constraints are present.',
    'This is a common pattern in other specific contexts.',
    'Such an approach is typically reserved for distinct use cases.',
    'This configuration is generally applied under varying requirements.',
    'This solution might be chosen if different trade-offs were acceptable.'
  ];

  Question({
    required this.id,
    required this.text,
    required List<String> options,
    this.correctAnswerIndex = -1,
    this.correctAnswers,
    required this.explanation,
  }) : options = _padOptions(options, id);

  static List<String> _padOptions(List<String> originalOptions, String id) {
    if (originalOptions.isEmpty) return originalOptions;
    
    int maxWords = 0;
    for (var opt in originalOptions) {
      final words = opt.trim().split(RegExp(r'\s+')).length;
      if (words > maxWords) maxWords = words;
    }

    // Seed the random generator with the question ID hash so padding is deterministic per question.
    final random = Random(id.hashCode);
    
    return originalOptions.map((opt) {
      String padded = opt;
      while (padded.trim().split(RegExp(r'\s+')).length < maxWords) {
        padded += ' ' + _paddingPhrases[random.nextInt(_paddingPhrases.length)];
      }
      return padded;
    }).toList();
  }

  bool get isMultipleChoice => correctAnswers != null && correctAnswers!.length > 1;
}

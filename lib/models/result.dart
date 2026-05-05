

class ExamResult {
  final String id;
  final String examId;
  final String examTitle;
  final int score;
  final int totalQuestions;
  final int scaleScore;
  final DateTime timestamp;
  final bool passed;
  final Map<String, int> domainScores; // Score per domain for detailed dashboard

  ExamResult({
    required this.id,
    required this.examId,
    required this.examTitle,
    required this.score,
    required this.totalQuestions,
    required this.scaleScore,
    required this.timestamp,
    required this.passed,
    this.domainScores = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'examId': examId,
    'examTitle': examTitle,
    'score': score,
    'totalQuestions': totalQuestions,
    'scaleScore': scaleScore,
    'timestamp': timestamp.millisecondsSinceEpoch,
    'passed': passed,
    'domainScores': domainScores,
  };

  factory ExamResult.fromJson(Map<String, dynamic> json) => ExamResult(
    id: json['id'],
    examId: json['examId'],
    examTitle: json['examTitle'],
    score: json['score'],
    totalQuestions: json['totalQuestions'],
    scaleScore: json['scaleScore'],
    timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    passed: json['passed'],
    domainScores: Map<String, int>.from(json['domainScores'] ?? {}),
  );
}

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/exam.dart';
import '../services/state_service.dart';
import '../services/ad_service.dart';
import '../models/result.dart';
import 'dart:math';

class ResultScreen extends StatefulWidget {
  final Exam exam;
  final List<Question> shuffledQuestions;
  final Map<int, List<int>> userAnswers;

  const ResultScreen({
    super.key, 
    required this.exam, 
    required this.shuffledQuestions, 
    required this.userAnswers,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isSaved = false;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _saveResult();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = AdService.createBannerAd(
      onAdLoaded: (ad) {
        if (mounted) setState(() => _isBannerAdLoaded = true);
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
      },
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _saveResult() async {
    if (_isSaved) return;

    int score = 0;
    for (int i = 0; i < widget.shuffledQuestions.length; i++) {
      final question = widget.shuffledQuestions[i];
      final userSelected = widget.userAnswers[i] ?? [];
      bool isCorrect = false;
      if (question.isMultipleChoice) {
        isCorrect = userSelected.length == (question.correctAnswers?.length ?? 0) &&
            userSelected.every((idx) => question.correctAnswers!.contains(idx));
      } else {
        isCorrect = userSelected.isNotEmpty && userSelected.first == question.correctAnswerIndex;
      }
      if (isCorrect) score++;
    }

    final double percentage = (score / widget.shuffledQuestions.length);
    final int scaleScore = (100 + (percentage * 900)).round();

    final result = ExamResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      examId: widget.exam.id,
      examTitle: widget.exam.title,
      score: score,
      totalQuestions: widget.shuffledQuestions.length,
      scaleScore: scaleScore,
      timestamp: DateTime.now(),
      passed: scaleScore >= 700,
    );

    await StateService.saveExamResult(result);
    if (mounted) setState(() => _isSaved = true);
  }

  @override
  Widget build(BuildContext context) {
    int score = 0;
    final shuffledQuestions = widget.shuffledQuestions;
    final userAnswers = widget.userAnswers;

    for (int i = 0; i < shuffledQuestions.length; i++) {
      final question = shuffledQuestions[i];
      final userSelected = userAnswers[i] ?? [];
      bool isCorrect = false;
      if (question.isMultipleChoice) {
        isCorrect = userSelected.length == (question.correctAnswers?.length ?? 0) &&
            userSelected.every((idx) => question.correctAnswers!.contains(idx));
      } else {
        isCorrect = userSelected.isNotEmpty && userSelected.first == question.correctAnswerIndex;
      }
      if (isCorrect) {
        score++;
      }
    }

    final double percentage = (score / shuffledQuestions.length);
    final int scaleScore = (100 + (percentage * 900)).round();
    final bool passed = scaleScore >= 700; // 700 to pass

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text('Exam Results', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          passed ? Colors.green.withAlpha(40) : Colors.red.withAlpha(40),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: CircularProgressIndicator(
                                value: score / shuffledQuestions.length,
                                strokeWidth: 10,
                                backgroundColor: Colors.white10,
                                color: passed ? Colors.green : Colors.red,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '$scaleScore',
                                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  '$score/${shuffledQuestions.length}',
                                  style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(150)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          passed ? 'CERTIFIED READY' : 'PRACTICE REQUIRED',
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w900,
                            color: passed ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          passed 
                            ? 'Outstanding! You have a solid grasp of CCA-F concepts.' 
                            : 'You\'re getting there! Focus on the missed areas and try again.',
                          style: const TextStyle(color: Colors.white70, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    itemCount: shuffledQuestions.length,
                    itemBuilder: (context, index) {
                      final question = shuffledQuestions[index];
                      final userSelected = userAnswers[index] ?? [];
                      bool isCorrect = false;
                      if (question.isMultipleChoice) {
                        isCorrect = userSelected.length == question.correctAnswers!.length &&
                            userSelected.every((idx) => question.correctAnswers!.contains(idx));
                      } else {
                        isCorrect = userSelected.isNotEmpty && userSelected.first == question.correctAnswerIndex;
                      }
                      
                      String userAnswerText = userSelected.isEmpty 
                          ? "Not answered" 
                          : userSelected.map((idx) => question.options[idx]).join("\n• ");
                      
                      String correctAnswerText = question.isMultipleChoice
                          ? question.correctAnswers!.map((idx) => question.options[idx]).join("\n• ")
                          : question.options[question.correctAnswerIndex];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check_circle : Icons.cancel,
                                    color: isCorrect ? Colors.green : Colors.red,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Q${index + 1}: ${question.text}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Your Answer:\n${userSelected.isNotEmpty ? "• " : ""}$userAnswerText',
                                style: TextStyle(
                                  color: isCorrect ? Colors.green[700] : Colors.red[700],
                                ),
                              ),
                              if (!isCorrect) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Correct Answer:\n• $correctAnswerText',
                                  style: TextStyle(color: Colors.green[700]),
                                ),
                              ],
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Explanation',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(question.explanation),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_isBannerAdLoaded)
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: _bannerAd!.size.height.toDouble(),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
}

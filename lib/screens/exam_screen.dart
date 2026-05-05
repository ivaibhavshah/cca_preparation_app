import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/exam.dart';
import '../services/state_service.dart';
import '../services/ad_service.dart';
import 'result_screen.dart';

class ExamScreen extends StatefulWidget {
  final Exam exam;
  final bool isPracticeMode;
  final int initialIndex;
  final Map<int, List<int>> initialAnswers;
  final int? randomSeed;

  const ExamScreen({
    super.key, 
    required this.exam, 
    this.isPracticeMode = false,
    this.initialIndex = 0,
    this.initialAnswers = const {},
    this.randomSeed,
    this.questionLimit,
    this.initialFlagged = const {},
  });

  final int? questionLimit;
  final Set<int> initialFlagged;

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late int _currentIndex;
  late final Map<int, List<int>> _selectedAnswers;
  final Map<int, bool> _submittedQuestions = {};
  final Map<int, List<int>> _shuffledOptions = {};
  final Set<int> _flaggedQuestions = {};

  
  late int _randomSeed;
  late List<Question> _shuffledQuestions;
  
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _randomSeed = widget.randomSeed ?? DateTime.now().millisecondsSinceEpoch;
    _currentIndex = widget.initialIndex;
    _selectedAnswers = Map<int, List<int>>.from(widget.initialAnswers);
    
    // Shuffle questions
    _shuffledQuestions = List.from(widget.exam.questions);
    _shuffledQuestions.shuffle(Random(_randomSeed));
    
    // Apply limit if specified
    if (widget.questionLimit != null && widget.questionLimit! < _shuffledQuestions.length) {
      _shuffledQuestions = _shuffledQuestions.sublist(0, widget.questionLimit);
    }
    
    _flaggedQuestions.addAll(widget.initialFlagged);
    
    // Shuffle options
    for (int i = 0; i < _shuffledQuestions.length; i++) {
      final question = _shuffledQuestions[i];
      final indices = List<int>.generate(question.options.length, (index) => index);
      indices.shuffle(Random(_randomSeed + question.id.hashCode));
      _shuffledOptions[i] = indices;
    }

    // In practice mode, mark already answered questions as submitted
    if (widget.isPracticeMode) {
      for (var key in _selectedAnswers.keys) {
        if (_selectedAnswers[key]!.isNotEmpty) {
          _submittedQuestions[key] = true;
        }
      }
    }

    _loadBannerAd();
    _loadInterstitialAd();
  }

  void _loadBannerAd() {
    debugPrint('AdService: Attempting to load Banner Ad...');
    _bannerAd = AdService.createBannerAd(
      onAdLoaded: (ad) {
        debugPrint('AdService: Banner Ad loaded successfully.');
        setState(() {
          _isBannerAdLoaded = true;
        });
      },
      onAdFailedToLoad: (ad, error) {
        // Detailed error logging
        debugPrint('AdService: BannerAd failed to load: ${error.message}');
        debugPrint('AdService: Error Code: ${error.code}');
        debugPrint('AdService: Domain: ${error.domain}');
        ad.dispose();
      },
    );
    _bannerAd!.load();
  }

  void _loadInterstitialAd() {
    AdService.loadInterstitialAd(
      onAdLoaded: (ad) {
        _interstitialAd = ad;
        _isInterstitialAdLoaded = true;
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _navigateToResults();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _navigateToResults();
          },
        );
      },
      onAdFailedToLoad: (error) {
        debugPrint('AdService: InterstitialAd failed to load: ${error.message}');
        _isInterstitialAdLoaded = false;
      },
    );
  }

  void _navigateToResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          exam: widget.exam,
          shuffledQuestions: _shuffledQuestions,
          userAnswers: _selectedAnswers,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _saveCurrentState() {
    StateService.saveExamState(
      widget.exam.id, 
      _currentIndex, 
      _selectedAnswers, 
      seed: _randomSeed,
      flagged: _flaggedQuestions,
    );
  }

  void _toggleFlag() {
    setState(() {
      if (_flaggedQuestions.contains(_currentIndex)) {
        _flaggedQuestions.remove(_currentIndex);
      } else {
        _flaggedQuestions.add(_currentIndex);
      }
    });
    _saveCurrentState();
  }

  void _showNavigationGrid() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Question Navigator',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _shuffledQuestions.length,
                  itemBuilder: (context, index) {
                    bool isAnswered = _selectedAnswers.containsKey(index);
                    bool isFlagged = _flaggedQuestions.contains(index);
                    bool isCurrent = _currentIndex == index;

                    return InkWell(
                      onTap: () {
                        setState(() => _currentIndex = index);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCurrent 
                              ? Theme.of(context).colorScheme.primary 
                              : isFlagged 
                                  ? Colors.orange.withAlpha(50)
                                  : isAnswered 
                                      ? Colors.green.withAlpha(50)
                                      : Colors.white.withAlpha(10),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCurrent 
                                ? Colors.white 
                                : isFlagged 
                                    ? Colors.orange 
                                    : isAnswered 
                                        ? Colors.green 
                                        : Colors.white24,
                            width: isCurrent ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCurrent ? Colors.white : Colors.white70,
                                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              if (isFlagged)
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Icon(Icons.flag, size: 10, color: Colors.orange),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatusLegend(color: Colors.green, label: 'Answered'),
                  _StatusLegend(color: Colors.orange, label: 'Flagged'),
                  _StatusLegend(color: Colors.white24, label: 'Pending'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  void _nextQuestion() {
    if (_currentIndex < _shuffledQuestions.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _saveCurrentState();
    } else {
      _showSubmissionDialog();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _saveCurrentState();
    }
  }

  void _showSubmissionDialog() {
    int unanswered = _shuffledQuestions.length - _selectedAnswers.length;
    String contentText = unanswered > 0 
        ? 'You have $unanswered unanswered question(s). Are you sure you want to submit your answers?'
        : 'Are you sure you want to submit your answers?';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Exam?'),
        content: Text(contentText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Review'),
          ),
          FilledButton(
            onPressed: () async {
              await StateService.clearExamState(widget.exam.id);
              if (mounted) {
                Navigator.pop(context); // Close dialog
                
                if (_isInterstitialAdLoaded && _interstitialAd != null) {
                  _interstitialAd!.show();
                } else {
                  _navigateToResults();
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _shuffledQuestions[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.exam.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(
              'Question ${_currentIndex + 1} of ${_shuffledQuestions.length}',
              style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(150)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _flaggedQuestions.contains(_currentIndex) ? Icons.flag : Icons.flag_outlined,
              color: _flaggedQuestions.contains(_currentIndex) ? Colors.orange : Colors.white,
            ),
            tooltip: 'Flag Question',
            onPressed: _toggleFlag,
          ),
          IconButton(
            icon: const Icon(Icons.grid_view_rounded, size: 20),
            tooltip: 'Question Navigator',
            onPressed: _showNavigationGrid,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 20),
            tooltip: 'Exit & Save',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _shuffledQuestions.length,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Question ${_currentIndex + 1}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double screenWidth = MediaQuery.of(context).size.width;
                        bool isMediumDevice = screenWidth < 800;
                        return Text(
                          question.text,
                          style: isMediumDevice 
                              ? Theme.of(context).textTheme.titleLarge?.copyWith(height: 1.3)
                              : Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1.3),
                        );
                      }
                    ),
                    const SizedBox(height: 32),
                    ...List.generate(question.options.length, (displayIndex) {
                      final originalIndex = _shuffledOptions[_currentIndex]![displayIndex];
                      final isSubmitted = widget.isPracticeMode && (_submittedQuestions[_currentIndex] ?? false);
                      final selectedIndices = _selectedAnswers[_currentIndex] ?? [];
                      final isSelected = selectedIndices.contains(originalIndex);
                      final isCorrect = question.isMultipleChoice 
                          ? question.correctAnswers!.contains(originalIndex)
                          : originalIndex == question.correctAnswerIndex;
                      
                      Color borderColor = Theme.of(context).dividerColor;
                      Color? bgColor;
                      IconData iconData = question.isMultipleChoice ? Icons.check_box_outline_blank : Icons.radio_button_unchecked;
                      Color iconColor = Colors.grey;

                      if (isSubmitted) {
                        if (isCorrect) {
                          borderColor = Colors.green;
                          bgColor = Colors.green.withAlpha(50);
                          iconData = question.isMultipleChoice ? Icons.check_box : Icons.check_circle;
                          iconColor = Colors.green;
                        } else if (isSelected) {
                          borderColor = Colors.red;
                          bgColor = Colors.red.withAlpha(50);
                          iconData = question.isMultipleChoice ? Icons.disabled_by_default : Icons.cancel;
                          iconColor = Colors.red;
                        } else if (question.isMultipleChoice && isSelected) {
                          iconData = Icons.check_box;
                        }
                      } else {
                        if (isSelected) {
                          borderColor = Theme.of(context).colorScheme.primary;
                          bgColor = Theme.of(context).colorScheme.primaryContainer.withAlpha(50);
                          iconData = question.isMultipleChoice ? Icons.check_box : Icons.check_circle;
                          iconColor = Theme.of(context).colorScheme.primary;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: InkWell(
                          onTap: () {
                            if (isSubmitted) return; // Locked

                            setState(() {
                              if (question.isMultipleChoice) {
                                final currentSelected = List<int>.from(_selectedAnswers[_currentIndex] ?? []);
                                if (currentSelected.contains(originalIndex)) {
                                  currentSelected.remove(originalIndex);
                                } else {
                                  currentSelected.add(originalIndex);
                                }
                                _selectedAnswers[_currentIndex] = currentSelected;
                              } else {
                                _selectedAnswers[_currentIndex] = [originalIndex];
                                if (widget.isPracticeMode) {
                                  _submittedQuestions[_currentIndex] = true;
                                }
                              }
                            });
                            _saveCurrentState();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: borderColor,
                                width: isSelected || (isSubmitted && isCorrect) ? 2.0 : 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: bgColor,
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  iconData,
                                  color: iconColor,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      double screenWidth = MediaQuery.of(context).size.width;
                                      bool isMediumDevice = screenWidth < 800;
                                      return Text(
                                        question.options[originalIndex],
                                        style: isMediumDevice 
                                          ? Theme.of(context).textTheme.bodyMedium 
                                          : Theme.of(context).textTheme.bodyLarge,
                                      );
                                    }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    if (widget.isPracticeMode && question.isMultipleChoice && !(_submittedQuestions[_currentIndex] ?? false))
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              _submittedQuestions[_currentIndex] = true;
                            });
                          },
                          child: const Text('Check Answer'),
                        ),
                      ),
                    if (widget.isPracticeMode && (_submittedQuestions[_currentIndex] ?? false))
                      Builder(builder: (context) {
                        final selected = _selectedAnswers[_currentIndex] ?? [];
                        bool isFullyCorrect = false;
                        if (question.isMultipleChoice) {
                          isFullyCorrect = selected.length == question.correctAnswers!.length &&
                              selected.every((element) => question.correctAnswers!.contains(element));
                        } else {
                          isFullyCorrect = selected.isNotEmpty && selected.first == question.correctAnswerIndex;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Card(
                            color: isFullyCorrect ? Colors.green.withAlpha(30) : Colors.red.withAlpha(30),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        isFullyCorrect ? Icons.check_circle : Icons.cancel,
                                        color: isFullyCorrect ? Colors.green : Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isFullyCorrect ? 'Correct!' : 'Incorrect',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: isFullyCorrect ? Colors.green[800] : Colors.red[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Explanation:',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    question.explanation,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
            if (_isBannerAdLoaded)
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: _bannerAd!.size.height.toDouble(),
                margin: const EdgeInsets.only(bottom: 8),
                child: AdWidget(ad: _bannerAd!),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: _currentIndex > 0 ? _previousQuestion : null,
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Previous',
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _nextQuestion,
                    icon: Icon(_currentIndex < _shuffledQuestions.length - 1 
                        ? (_selectedAnswers.containsKey(_currentIndex) ? Icons.arrow_forward : Icons.skip_next) 
                        : Icons.check),
                    label: Text(_currentIndex < _shuffledQuestions.length - 1 
                        ? (_selectedAnswers.containsKey(_currentIndex) ? 'Next' : 'Skip') 
                        : 'Submit'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _StatusLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _StatusLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withAlpha(50),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: color, width: 1),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}

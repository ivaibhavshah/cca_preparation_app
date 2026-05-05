import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/exam.dart';
import '../data/mock_data.dart';
import '../data/mock_tests.dart';
import '../data/pdf_mock_test.dart';
import '../services/state_service.dart';
import 'exam_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Exam? _inProgressExam;
  Map<String, dynamic>? _inProgressState;
  bool _inProgressIsPractice = false;
  DateTime? _examDate;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _loadUserSettings();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadUserSettings() async {
    final name = await StateService.getUserName();
    final date = await StateService.getExamDate();
    final onboardingShown = await StateService.isOnboardingShown();
    
    if (mounted) {
      setState(() {
        _userName = name;
        _examDate = date;
      });
      
      // If name isn't set and onboarding hasn't been shown, trigger it
      if (name == null && !onboardingShown) {
        // Delay slightly to allow the app to settle and animations to finish
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _showOnboardingDialog();
        });
      }
    }

    await StateService.updateLastAppVisit();
  }

  Future<void> _openSettingsDialog() async {
    DateTime? selectedDate = _examDate;
    final nameController = TextEditingController(text: _userName);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF221F1C),
            surfaceTintColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28), side: BorderSide(color: Colors.white.withAlpha(20))),
            title: const Text('Preparation Settings', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    hintText: 'Enter your name for reminders',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 30)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                    );
                    if (picked != null && context.mounted) {
                      setDialogState(() => selectedDate = picked);
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.white70),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Exam Date', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              Text(
                                selectedDate != null 
                                    ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
                                    : 'Target Date Not Set',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (selectedDate != null)
                          IconButton(
                            icon: const Icon(Icons.close, size: 20, color: Colors.white70),
                            onPressed: () => setDialogState(() => selectedDate = null),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          )
                        else
                          const Icon(Icons.edit, size: 18, color: Colors.white38),
                      ],
                    ),
                  ),
                ),

              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  await StateService.setUserName(name);
                  if (selectedDate != null) {
                    await StateService.setExamDate(selectedDate!);
                  } else {
                    await StateService.clearExamDate();
                  }
                  
                  if (mounted) {
                    setState(() {
                      _userName = name;
                      _examDate = selectedDate;
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save & Update'),
              ),
            ],
          );
        }
      ),
    );
  }

  Future<void> _showOnboardingDialog() async {
    DateTime? selectedDate;
    final nameController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false, // Force them to interact
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return PopScope(
            canPop: false, // Prevent back button dismissal
            child: AlertDialog(
              backgroundColor: const Color(0xFF221F1C),
              surfaceTintColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28), 
                side: BorderSide(color: Colors.white.withAlpha(20))
              ),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome! 👋', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26)),
                  SizedBox(height: 8),
                  Text('Let\'s personalize your preparation journey.', 
                    style: TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.normal)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                      hintText: 'Enter your name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                      );
                      if (picked != null && context.mounted) {
                        setDialogState(() => selectedDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month, color: Colors.white70),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Exam Date', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                Text(
                                  selectedDate != null 
                                      ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
                                      : 'Target Date Not Set',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.edit, size: 18, color: Colors.white38),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You can change these later in settings.',
                    style: TextStyle(fontSize: 11, color: Colors.white38),
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    await StateService.setUserName(name);
                    if (selectedDate != null) {
                      await StateService.setExamDate(selectedDate!);
                    }
                    await StateService.setOnboardingShown(true);
                    
                    if (mounted) {
                      setState(() {
                        _userName = name;
                        _examDate = selectedDate;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Center(child: Text('Get Started')),
                ),
              ],
            ),
          );
        }
      ),
    );
  }



  Future<void> _loadProgress() async {
    final allExams = [...mockExams, ...mockTests, ...pdfMockExams];
    Exam? latestExam;
    Map<String, dynamic>? latestState;
    int maxTimestamp = -1;

    for (final exam in allExams) {
      final state = await StateService.loadExamState(exam.id);
      if (state != null) {
        final timestamp = state['lastAccessed'] as int? ?? 0;
        if (timestamp > maxTimestamp) {
          maxTimestamp = timestamp;
          latestExam = exam;
          latestState = state;
        }
      }
    }

    if (mounted) {
      setState(() {
        _inProgressExam = latestExam;
        _inProgressState = latestState;
        if (latestExam != null) {
          _inProgressIsPractice = mockExams.contains(latestExam);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          // Background color and blobs for glassmorphism
          Container(
            decoration: const BoxDecoration(color: Color(0xFF121212)),
          ),
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
              ),
            ),
          ),
          // Backdrop filter to blur the blobs across the whole screen smoothly
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
              child: Container(color: Colors.transparent),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('assets/images/app_icon.jpg', height: 32, width: 32),
              ),
              const SizedBox(width: 14),
              const Text('CCA-F Prep', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              tooltip: 'Settings & Exam Date',
              onPressed: _openSettingsDialog,
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E1E1E), Color(0xFF2D1812)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            tabs: const [
              Tab(text: 'Dashboard', icon: Icon(Icons.dashboard_rounded)),
              Tab(text: 'Module Questions', icon: Icon(Icons.school_rounded)),
              Tab(text: 'Full Mock Tests', icon: Icon(Icons.timer_outlined)),
            ],
          ),
        ),
        body: Column(
          children: [
            if (_examDate != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                child: Center(
                  child: Text(
                    _examDate!.difference(DateTime.now()).inDays >= 0
                        ? '${_examDate!.difference(DateTime.now()).inDays} days left until exam!'
                        : 'Exam date has passed.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (_inProgressExam != null && _inProgressState != null)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.play_circle_fill, color: Theme.of(context).colorScheme.primary, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Continue Preparation',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _inProgressExam!.title,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExamScreen(
                              exam: _inProgressExam!,
                              isPracticeMode: _inProgressIsPractice,
                              initialIndex: _inProgressState!['currentIndex'] as int,
                              initialAnswers: _inProgressState!['selectedAnswers'] as Map<int, List<int>>,
                              randomSeed: _inProgressState!['randomSeed'] as int?,
                              initialFlagged: _inProgressState!['flagged'] as Set<int>? ?? {},
                            ),
                          ),
                        ).then((_) => _loadProgress());
                      },
                      child: const Text('Resume'),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: TabBarView(
                children: [
                  const DashboardScreen(),
                  _ExamList(
                    exams: mockExams, 
                    isPracticeMode: true,
                    onReturn: _loadProgress,
                  ),
                  _ExamList(
                    exams: [...mockTests, ...pdfMockExams], 
                    isPracticeMode: false,
                    onReturn: _loadProgress,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor.withAlpha(80),
                  ),
                ),
                color: Theme.of(context).colorScheme.surface,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Developed by ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => launchUrl(
                      Uri.parse(dotenv.get('DEVELOPER_WEBSITE', fallback: 'https://ivaibhavshah.vercel.app/')),
                      mode: LaunchMode.externalApplication,
                    ),
                    child: Text(
                      'Vaibhav Shah',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.primary.withAlpha(120),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
        ],
      ),
    );
  }
}

class _ExamList extends StatelessWidget {
  final List<Exam> exams;
  final bool isPracticeMode;
  final VoidCallback onReturn;

  const _ExamList({
    required this.exams, 
    this.isPracticeMode = false,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withValues(alpha: 0.04),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              highlightColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              onTap: () async {
                final savedState = await StateService.loadExamState(exam.id);
                if (savedState != null && context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Resume Exam?'),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      content: const Text('You have an unfinished attempt. Do you want to resume where you left off or start a new exam?'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context); // close dialog
                            await StateService.clearExamState(exam.id);
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExamScreen(exam: exam, isPracticeMode: isPracticeMode),
                                ),
                              ).then((_) => onReturn());
                            }
                          },
                          child: const Text('Start New'),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context); // close dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExamScreen(
                                  exam: exam, 
                                  isPracticeMode: isPracticeMode,
                                  initialIndex: savedState['currentIndex'] as int,
                                  initialAnswers: savedState['selectedAnswers'] as Map<int, List<int>>,
                                  randomSeed: savedState['randomSeed'] as int?,
                                  initialFlagged: savedState['flagged'] as Set<int>? ?? {},
                                ),
                              ),
                            ).then((_) => onReturn());
                          },
                          child: const Text('Resume'),
                        ),
                      ],
                    ),
                  );
                } else if (context.mounted) {
                  _showSessionConfigDialog(context, exam, isPracticeMode);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            exam.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      exam.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.library_books_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            '${exam.questions.length} Questions',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
                ),
              ),
            ),
          );
        },
    );
  }

  void _showSessionConfigDialog(BuildContext context, Exam exam, bool isPracticeMode) {
    int selectedCount = exam.questions.length < 10 ? exam.questions.length : 10;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: Text(
              isPracticeMode ? 'Practice Session' : 'Mock Exam',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose question count for ${exam.title}:',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  children: ([10, 20, 50, exam.questions.length]
                          .where((c) => c <= exam.questions.length)
                          .toSet()
                          .toList()..sort())
                      .map((count) {
                    bool isSelected = selectedCount == count;
                    return ChoiceChip(
                      label: Text(count == exam.questions.length ? 'All ($count)' : '$count'),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setDialogState(() => selectedCount = count);
                      },
                      selectedColor: Theme.of(context).colorScheme.primary.withAlpha(50),
                      labelStyle: TextStyle(
                        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamScreen(
                        exam: exam, 
                        isPracticeMode: isPracticeMode,
                        questionLimit: selectedCount,
                      ),
                    ),
                  ).then((_) => onReturn());
                },
                child: const Text('Start'),
              ),
            ],
          );
        }
      ),
    );
  }
}

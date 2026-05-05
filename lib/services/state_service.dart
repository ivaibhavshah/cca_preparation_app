import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/result.dart';

class StateService {
  static const String _keyPrefix = 'exam_state_';

  // Save the progress of an exam (index and answers)
  static Future<void> saveExamState(String examId, int currentIndex, Map<int, List<int>> selectedAnswers, {int? seed, Set<int> flagged = const {}}) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Map<int, List<int>> needs to be converted to Map<String, List<int>> for JSON encoding
    final stringKeyAnswers = selectedAnswers.map((key, value) => MapEntry(key.toString(), value));
    
    final stateData = {
      'currentIndex': currentIndex,
      'selectedAnswers': stringKeyAnswers,
      'lastAccessed': DateTime.now().millisecondsSinceEpoch,
      'flagged': flagged.toList(),
      if (seed != null) 'randomSeed': seed,
    };
    
    await prefs.setString('$_keyPrefix$examId', jsonEncode(stateData));
  }

  // Load the progress of an exam
  static Future<Map<String, dynamic>?> loadExamState(String examId) async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('$_keyPrefix$examId');
    if (dataString != null) {
      try {
        final decodedData = jsonDecode(dataString) as Map<String, dynamic>;
        
        // Convert Map<String, dynamic> back to Map<int, List<int>> for answers
        final Map<int, List<int>> typedAnswers = {};
        final rawAnswers = decodedData['selectedAnswers'] as Map<String, dynamic>? ?? {};
        rawAnswers.forEach((key, value) {
          if (value is List) {
            typedAnswers[int.parse(key)] = List<int>.from(value);
          } else if (value is int) {
            typedAnswers[int.parse(key)] = [value]; // legacy fallback
          }
        });
        
        return {
          'currentIndex': decodedData['currentIndex'] as int,
          'selectedAnswers': typedAnswers,
          'lastAccessed': decodedData['lastAccessed'] as int? ?? 0,
          'randomSeed': decodedData['randomSeed'] as int?,
          'flagged': Set<int>.from(decodedData['flagged'] as List? ?? []),
        };
      } catch (e) {
        // If there's an error parsing the state, return null
        return null;
      }
    }
    return null;
  }
  
  // Clear the state after submission
  static Future<void> clearExamState(String examId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_keyPrefix$examId');
  }
  
  // Check if an exam has a saved state (returns the entire map of states to avoid multiple async calls)
  static Future<Map<String, bool>> getAllSavedStates(List<String> examIds) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, bool> states = {};
    for (String id in examIds) {
      states[id] = prefs.containsKey('$_keyPrefix$id');
    }
    return states;
  }

  // --- App Global Settings ---

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  static Future<DateTime?> getExamDate() async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt('exam_date');
    if (millis != null) {
      return DateTime.fromMillisecondsSinceEpoch(millis);
    }
    return null;
  }

  static Future<void> setExamDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('exam_date', date.millisecondsSinceEpoch);
  }

  static Future<void> clearExamDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('exam_date');
  }

  static Future<int?> getLastAppVisit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('last_app_visit');
  }

  static Future<void> updateLastAppVisit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_app_visit', DateTime.now().millisecondsSinceEpoch);
  }

  static Future<bool> isOnboardingShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_shown') ?? false;
  }

  static Future<void> setOnboardingShown(bool shown) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_shown', shown);
  }

  // --- Results History & Dashboard ---

  static Future<void> saveExamResult(ExamResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final results = await getResultsHistory();
    results.insert(0, result); // Newest first
    
    // Limit history to 50 for performance
    if (results.length > 50) results.removeLast();
    
    final jsonList = results.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList('exam_history', jsonList);
    
    // Update domain mastery
    await _updateDomainMastery(result);
  }

  static Future<List<ExamResult>> getResultsHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('exam_history') ?? [];
    return jsonList.map((s) => ExamResult.fromJson(jsonDecode(s))).toList();
  }

  static Future<void> _updateDomainMastery(ExamResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final masteryString = prefs.getString('domain_mastery');
    Map<String, double> mastery = {};
    
    if (masteryString != null) {
      mastery = Map<String, double>.from(jsonDecode(masteryString));
    }
    
    // Basic logic: update mastery for this domain
    final domainId = result.examId; 
    double currentVal = mastery[domainId] ?? 0.0;
    double newVal = result.score / result.totalQuestions;
    
    // Weighted update
    mastery[domainId] = (currentVal * 0.7) + (newVal * 0.3);
    
    await prefs.setString('domain_mastery', jsonEncode(mastery));
  }

  static Future<Map<String, double>> getDomainMastery() async {
    final prefs = await SharedPreferences.getInstance();
    final masteryString = prefs.getString('domain_mastery');
    if (masteryString != null) {
      final Map<String, dynamic> decoded = jsonDecode(masteryString);
      return decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
    }
    return {};
  }
}

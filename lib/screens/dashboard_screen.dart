import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/state_service.dart';
import '../models/result.dart';
import 'dart:ui' as ui;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<ExamResult> _history = [];
  Map<String, double> _mastery = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final history = await StateService.getResultsHistory();
    final mastery = await StateService.getDomainMastery();
    if (mounted) {
      setState(() {
        _history = history;
        _mastery = mastery;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 32),
            _buildQuickStats(),
            const SizedBox(height: 32),
            const Text(
              'Domain Mastery',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            _buildRadarChart(),
            const SizedBox(height: 32),
            const Text(
              'Performance Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            _buildLineChart(),
            const SizedBox(height: 32),
            _buildRecentActivity(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(40),
          child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anonymous Explorer',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Progress saved locally',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final avgScore = _history.isEmpty 
        ? 0 
        : (_history.map((e) => e.scaleScore).reduce((a, b) => a + b) / _history.length).round();
    
    return Row(
      children: [
        _StatCard(
          title: 'Avg. Score',
          value: '$avgScore',
          subtitle: 'of 1000',
          icon: Icons.analytics_outlined,
          color: Colors.blue,
        ),
        const SizedBox(width: 16),
        _StatCard(
          title: 'Tests Taken',
          value: '${_history.length}',
          subtitle: 'sessions',
          icon: Icons.history_toggle_off,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildRadarChart() {
    final domains = [
      'exam_domain_1',
      'exam_domain_2',
      'exam_domain_3',
      'exam_domain_4',
      'exam_domain_5'
    ];
    
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.circle,
          ticksTextStyle: const TextStyle(color: Colors.transparent),
          gridBorderData: const BorderSide(color: Colors.white10),
          radarBorderData: const BorderSide(color: Colors.transparent),
          tickCount: 4,
          dataSets: [
            RadarDataSet(
              fillColor: Theme.of(context).colorScheme.primary.withAlpha(80),
              borderColor: Theme.of(context).colorScheme.primary,
              entryRadius: 3,
              dataEntries: domains.map((d) => RadarEntry(value: (_mastery[d] ?? 0.0) * 100)).toList(),
            ),
          ],
          getTitle: (index, angle) {
            final titles = ['Arch', 'Workflows', 'Prompt', 'Tools', 'Context'];
            return RadarChartTitle(text: titles[index], angle: angle);
          },
          titleTextStyle: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    if (_history.isEmpty) {
      return Container(
        height: 150,
        alignment: Alignment.center,
        child: const Text('Take tests to see trend', style: TextStyle(color: Colors.white38)),
      );
    }

    final data = _history.reversed.toList();
    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(16, 24, 24, 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value.scaleScore.toDouble());
              }).toList(),
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.primary.withAlpha(20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    if (_history.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        ..._history.take(5).map((result) => _buildActivityItem(result)).toList(),
      ],
    );
  }

  Widget _buildActivityItem(ExamResult result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (result.passed ? Colors.green : Colors.red).withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              result.passed ? Icons.check : Icons.close,
              color: result.passed ? Colors.green : Colors.red,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.examTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${result.timestamp.day}/${result.timestamp.month} • ${result.scaleScore} pts',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}

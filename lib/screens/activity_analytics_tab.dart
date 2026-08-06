import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityAnalyticsTab extends StatefulWidget {
  const ActivityAnalyticsTab({super.key});

  @override
  State<ActivityAnalyticsTab> createState() => _ActivityAnalyticsTabState();
}

class _ActivityAnalyticsTabState extends State<ActivityAnalyticsTab> {
  final Color _accent = const Color(0xFFFF5722);
  final Color _cardBg = const Color(0xFF1F1F22);

  // Month navigation state
  int _selectedYear = 2026;
  int _selectedMonth = 7; // July

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  void _prevMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear--;
      } else {
        _selectedMonth--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else {
        _selectedMonth++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title
          Text(
            'Activity Analytics',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),

          // Summary Metrics Grid
          _buildSummaryGrid(),
          const SizedBox(height: 24),

          // Section 1: Activity Calendar & Sidebar Stats
          _buildCalendarSection(),
          const SizedBox(height: 24),

          // Section 2: Personal Goals
          _buildPersonalGoalsSection(),
          const SizedBox(height: 24),

          // Section 3: Activity Breakdown
          _buildBreakdownSection(),
          const SizedBox(height: 24),

          // Section 4: Trends (Bar Chart & Donut Chart)
          _buildTrendsSection(),
          const SizedBox(height: 24),

          // Section 5: Intensity Heatmap
          _buildIntensityHeatmap(),
          const SizedBox(height: 24),

          // Section 6: Personal Records
          _buildPersonalRecordsGrid(),
          const SizedBox(height: 24),

          // Section 7: AI Fitness Insights
          _buildAIInsights(),
          const SizedBox(height: 24),

          // Section 8: Locked Premium Overlay
          _buildLockedAdvancedAnalytics(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSummaryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _buildSummaryCard('Activities', '18', ''),
        _buildSummaryCard('Active Time', '12h 40m', ''),
        _buildSummaryCard('Calories', '5,200', ' kcal'),
        _buildSummaryCard('Distance', '85', ' miles'),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: GoogleFonts.hankenGrotesk(
                color: _accent,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              children: [
                TextSpan(text: value),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: unit,
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      color: Colors.white60,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Column(
      children: [
        // July Calendar Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardBg.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_months[_selectedMonth - 1]} $_selectedYear',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _prevMonth,
                        child: const Icon(Icons.chevron_left, color: Colors.white70),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: _nextMonth,
                        child: const Icon(Icons.chevron_right, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Day initials
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                    .map((day) => Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: GoogleFonts.hankenGrotesk(
                                color: Colors.white38,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 10),
              // Grid for days
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: 1.0,
                ),
                itemCount: 35, // 5 weeks placeholder
                itemBuilder: (context, index) {
                  // Mock calendar for July 2026 (July 1 is Wednesday, so 2 placeholders)
                  final int dayNumber = index - 1;
                  if (dayNumber <= 0 || dayNumber > 31) {
                    return const SizedBox.shrink();
                  }

                  // Active days mock icons:
                  // Day 1: Run
                  // Day 3: Workout
                  // Day 6: Run
                  // Day 8: Cycle
                  // Day 10: Workout
                  // Day 12: Run
                  // Day 15: Cycle
                  // Day 17: Run
                  // Day 20: Workout
                  // Day 22: Cycle
                  // Day 24: Run
                  // Day 27: Workout
                  // Day 29: Cycle
                  // Day 31: Run
                  IconData? actIcon;
                  if (dayNumber == 1 || dayNumber == 6 || dayNumber == 12 || dayNumber == 17 || dayNumber == 24 || dayNumber == 31) {
                    actIcon = Icons.directions_run_rounded;
                  } else if (dayNumber == 3 || dayNumber == 10 || dayNumber == 20 || dayNumber == 27) {
                    actIcon = Icons.fitness_center_rounded;
                  } else if (dayNumber == 8 || dayNumber == 15 || dayNumber == 22 || dayNumber == 29) {
                    actIcon = Icons.pedal_bike_rounded;
                  }

                  final bool isActive = actIcon != null;

                  return Container(
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF1B1B1E).withValues(alpha: 0.8)
                          : const Color(0xFF353438).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive ? _accent.withValues(alpha: 0.2) : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNumber',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(height: 2),
                          Icon(
                            actIcon,
                            color: _accent,
                            size: 13,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Sidebar Stats Grid
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: _cardBg.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CURRENT STREAK',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '12',
                      style: GoogleFonts.anybody(
                        color: _accent,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Days in a row',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _cardBg.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ACTIVE DAYS',
                              style: GoogleFonts.hankenGrotesk(
                                color: Colors.white38,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '18/31',
                              style: GoogleFonts.hankenGrotesk(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 38,
                              height: 38,
                              child: CircularProgressIndicator(
                                value: 18 / 31,
                                strokeWidth: 3.5,
                                backgroundColor: const Color(0xFF353438),
                                valueColor: AlwaysStoppedAnimation<Color>(_accent),
                              ),
                            ),
                            Text(
                              '58%',
                              style: GoogleFonts.hankenGrotesk(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _cardBg.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GOAL COMPLETION',
                              style: GoogleFonts.hankenGrotesk(
                                color: Colors.white38,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '82%',
                              style: GoogleFonts.hankenGrotesk(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.military_tech_rounded,
                          color: _accent,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Goals',
          style: GoogleFonts.hankenGrotesk(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildGoalCard(Icons.directions_run_rounded, 'Weekly Runs', '2 / 3 Sessions', 2 / 3),
              const SizedBox(width: 12),
              _buildGoalCard(Icons.fitness_center_rounded, 'Strength Training', '4 / 4 Complete', 1.0),
              const SizedBox(width: 12),
              _buildGoalCard(Icons.pedal_bike_rounded, 'Cycling Target', '32 / 50 mi', 32 / 50),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(IconData icon, String title, String progressText, double progress) {
    final bool isCompleted = progress >= 1.0;
    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted ? _accent.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: _accent, size: 18),
              Text(
                progressText,
                style: GoogleFonts.hankenGrotesk(
                  color: isCompleted ? _accent : Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFF353438),
              valueColor: AlwaysStoppedAnimation<Color>(_accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Breakdown',
          style: GoogleFonts.hankenGrotesk(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _buildBreakdownCard(Icons.directions_run, 'Running', '8 Sessions', '32.4 miles', '4h 12m'),
            const SizedBox(height: 10),
            _buildBreakdownCard(Icons.pedal_bike, 'Cycling', '6 Sessions', '52.6 miles', '5h 48m'),
            const SizedBox(height: 10),
            _buildBreakdownCard(Icons.fitness_center, 'Strength', '4 Sessions', '12,400 lbs total', '2h 40m'),
          ],
        ),
      ],
    );
  }

  Widget _buildBreakdownCard(IconData icon, String title, String countText, String distText, String timeText) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: _accent, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      countText,
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      distText,
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      timeText,
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Trends',
          style: GoogleFonts.hankenGrotesk(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Bar Chart (Activity Frequency)
            Expanded(
              child: Container(
                height: 180,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _cardBg.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACTIVITY FREQUENCY',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white38,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 110,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFrequencyBar(0.4),
                          _buildFrequencyBar(0.6),
                          _buildFrequencyBar(0.3),
                          _buildFrequencyBar(0.8),
                          _buildFrequencyBar(0.5),
                          _buildFrequencyBar(1.0),
                          _buildFrequencyBar(0.85),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Donut Chart (Activity Distribution)
            Expanded(
              child: Container(
                height: 180,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _cardBg.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DISTRIBUTION',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white38,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: 0.85,
                              strokeWidth: 10,
                              backgroundColor: const Color(0xFF2C2C30),
                              valueColor: AlwaysStoppedAnimation<Color>(_accent),
                            ),
                          ),
                          Text(
                            '85%',
                            style: GoogleFonts.anybody(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildLegendItem(const Color(0xFFFF5722), 'Run'),
                        _buildLegendItem(const Color(0xFFFFB5A0), 'Cycle'),
                        _buildLegendItem(const Color(0xFFC8C5CB), 'Rest'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFrequencyBar(double heightFactor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: FractionallySizedBox(
          heightFactor: heightFactor,
          child: Container(
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: heightFactor),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.hankenGrotesk(
            color: Colors.white54,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _buildIntensityHeatmap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Intensity Heatmap',
          style: GoogleFonts.hankenGrotesk(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardBg.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 32, // 32 weeks simulation
                  itemBuilder: (context, weekIdx) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (dayIdx) {
                          // Shaded cells simulating intensity
                          // Determine mock intensity based on coordinates
                          final int hash = (weekIdx * 7 + dayIdx) % 11;
                          Color cellColor = const Color(0xFF353438).withValues(alpha: 0.3);
                          if (hash == 1 || hash == 5) {
                            cellColor = _accent.withValues(alpha: 0.2);
                          } else if (hash == 3 || hash == 8) {
                            cellColor = _accent.withValues(alpha: 0.4);
                          } else if (hash == 6) {
                            cellColor = _accent.withValues(alpha: 0.7);
                          } else if (hash == 10) {
                            cellColor = _accent;
                          }

                          return Container(
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                              color: cellColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Less Intense',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white38,
                      fontSize: 10,
                    ),
                  ),
                  Row(
                    children: [
                      _buildHeatmapLegendCell(const Color(0xFF353438).withValues(alpha: 0.3)),
                      const SizedBox(width: 4),
                      _buildHeatmapLegendCell(_accent.withValues(alpha: 0.2)),
                      const SizedBox(width: 4),
                      _buildHeatmapLegendCell(_accent.withValues(alpha: 0.4)),
                      const SizedBox(width: 4),
                      _buildHeatmapLegendCell(_accent.withValues(alpha: 0.7)),
                      const SizedBox(width: 4),
                      _buildHeatmapLegendCell(_accent),
                    ],
                  ),
                  Text(
                    'More Intense',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white38,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeatmapLegendCell(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildPersonalRecordsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Records',
          style: GoogleFonts.hankenGrotesk(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            _buildRecordCard('Longest', '2h 45m', 'Mountain Hike'),
            _buildRecordCard('Best Week', '6 Days', 'Streak Record'),
            _buildRecordCard('Calories', '940 kcal', 'HIIT Session'),
            _buildRecordCard('Consistent', 'Running', 'Top Activity'),
          ],
        ),
      ],
    );
  }

  Widget _buildRecordCard(String label, String value, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: Container(
                color: _accent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 12, bottom: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white54,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.anybody(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white38,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInsights() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: _accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'AI Fitness Insights',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _buildInsightBullet('Your consistency in Running has improved by 15% compared to last month. Keep up the 6:00 AM momentum.'),
              const SizedBox(height: 12),
              _buildInsightBullet('High-intensity cycles on Tuesdays are correlating with a 10% faster recovery rate later in the week.'),
              const SizedBox(height: 12),
              _buildInsightBullet('Performance peak detected: You are most efficient between 18°C and 22°C. Plan outdoor sessions accordingly.'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: _accent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLockedAdvancedAnalytics() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          // Background preview cards with mock graphs
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: _cardBg.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TRAINING LOAD',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white38,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Optimal',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildMockBar(35, _accent),
                              _buildMockBar(55, _accent),
                              _buildMockBar(45, Colors.white24),
                              _buildMockBar(80, _accent),
                              _buildMockBar(65, _accent),
                              _buildMockBar(95, _accent),
                              _buildMockBar(50, Colors.white24),
                              _buildMockBar(75, _accent),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: _cardBg.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RECOVERY SCORE',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white38,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '84% Good',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: CircularProgressIndicator(
                                  value: 0.84,
                                  strokeWidth: 8,
                                  backgroundColor: Colors.white10,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _accent.withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                              Text(
                                '84%',
                                style: GoogleFonts.anybody(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                color: Colors.white.withValues(alpha: 0.18),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      color: _accent,
                      size: 36,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Unlock Advanced Insights',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get Training Load, Recovery Score, and VO2 Max projections with Fitrybe Premium.',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          elevation: 4,
                        ),
                        child: Text(
                          'Upgrade to Premium',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockBar(double height, Color color) {
    return Container(
      width: 8,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

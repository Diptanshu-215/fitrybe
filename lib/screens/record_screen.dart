import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RecordScreen extends StatefulWidget {
  static const routeName = '/RecordScreen';
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> with TickerProviderStateMixin {
  final Color _accent = const Color(0xFFFF5722);
  final Color _cardBg = const Color(0xFF1E1E22);
  final Color _bg = const Color(0xFF0F0F12);

  // Selection states
  String _selectedActivityName = 'Running';
  IconData _selectedActivityIcon = Icons.directions_run_rounded;

  // Goals: 0: Open, 1: Distance, 2: Duration, 3: Calories
  int _selectedGoalIndex = 1;

  // Dynamic values
  double _distanceValue = 5.0;
  int _durationValue = 45;
  int _caloriesValue = 500;
  double _rulerScrollOffset = 0.0;

  // Active units
  String _distanceUnit = 'KM';
  String _durationUnit = 'MIN';
  String _caloriesUnit = 'KCAL';

  // GPS Blinker animation
  late AnimationController _gpsBlinkController;

  // Start activity simulation countdown state
  bool _isStarting = false;
  String _startButtonText = 'START ACTIVITY';
  IconData _startButtonIcon = Icons.play_arrow_rounded;

  @override
  void initState() {
    super.initState();
    _gpsBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gpsBlinkController.dispose();
    super.dispose();
  }

  void _triggerStartActivity() {
    if (_isStarting) return;
    HapticFeedback.heavyImpact();
    setState(() {
      _isStarting = true;
      _startButtonText = 'SYNCING...';
      _startButtonIcon = Icons.sync_rounded;
    });

    int countdown = 3;
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (countdown > 0) {
        setState(() {
          _startButtonText = '$countdown...';
        });
        countdown--;
      } else if (countdown == 0) {
        setState(() {
          _startButtonText = 'GO!';
          _startButtonIcon = Icons.bolt_rounded;
        });
        countdown--;
      } else {
        timer.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: _accent,
            content: Text(
              'Activity started! Track your goals in real-time.',
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        Navigator.pop(context);
      }
    });
  }

  // Show Bottom Sheet Modal for Activity Selection
  void _showActivityPickerSheet() {
    HapticFeedback.mediumImpact();
    final TextEditingController searchController = TextEditingController();
    List<Map<String, dynamic>> allOptions = [
      // Recent
      {'name': 'Running', 'icon': Icons.directions_run_rounded, 'type': 'recent'},
      {'name': 'Cycling', 'icon': Icons.pedal_bike_rounded, 'type': 'recent'},

      // Distance-Based Activities
      {'name': 'Walking', 'icon': Icons.directions_walk_rounded, 'type': 'distance'},
      {'name': 'Running', 'icon': Icons.directions_run_rounded, 'type': 'distance'},
      {'name': 'Hiking', 'icon': Icons.hiking_rounded, 'type': 'distance'},
      {'name': 'Cycling', 'icon': Icons.pedal_bike_rounded, 'type': 'distance'},
      {'name': 'Roller Skating', 'icon': Icons.roller_skating_rounded, 'type': 'distance'},
      {'name': 'Skateboarding', 'icon': Icons.skateboarding_rounded, 'type': 'distance'},
      {'name': 'Wheelchair Activity', 'icon': Icons.accessible_rounded, 'type': 'distance'},
      {'name': 'Dog Walking', 'icon': Icons.pets_rounded, 'type': 'distance'},
      {'name': 'Open Water Swimming', 'icon': Icons.pool_rounded, 'type': 'distance'},
      {'name': 'Kayaking', 'icon': Icons.kayaking_rounded, 'type': 'distance'},
      {'name': 'Canoeing', 'icon': Icons.rowing_rounded, 'type': 'distance'},
      {'name': 'Paddleboarding', 'icon': Icons.surfing_rounded, 'type': 'distance'},
      {'name': 'Skiing', 'icon': Icons.downhill_skiing_rounded, 'type': 'distance'},
      {'name': 'Snowboarding', 'icon': Icons.snowboarding_rounded, 'type': 'distance'},
      {'name': 'Trail Running', 'icon': Icons.terrain_rounded, 'type': 'distance'},
      {'name': 'Nature Walk', 'icon': Icons.park_rounded, 'type': 'distance'},
      {'name': 'Commute Walk', 'icon': Icons.directions_walk_rounded, 'type': 'distance'},
      {'name': 'Commute Ride', 'icon': Icons.pedal_bike_rounded, 'type': 'distance'},

      // Location-Based Activities
      {'name': 'Gym Workout', 'icon': Icons.fitness_center_rounded, 'type': 'location'},
      {'name': 'Football/Soccer', 'icon': Icons.sports_soccer_rounded, 'type': 'location'},
      {'name': 'Basketball', 'icon': Icons.sports_basketball_rounded, 'type': 'location'},
      {'name': 'Volleyball', 'icon': Icons.sports_volleyball_rounded, 'type': 'location'},
      {'name': 'Tennis', 'icon': Icons.sports_tennis_rounded, 'type': 'location'},
      {'name': 'Badminton', 'icon': Icons.sports_tennis_rounded, 'type': 'location'},
      {'name': 'Cricket', 'icon': Icons.sports_cricket_rounded, 'type': 'location'},
      {'name': 'Rugby', 'icon': Icons.sports_rugby_rounded, 'type': 'location'},
      {'name': 'Boxing', 'icon': Icons.sports_mma_rounded, 'type': 'location'},
      {'name': 'Martial Arts', 'icon': Icons.sports_martial_arts_rounded, 'type': 'location'},
      {'name': 'Yoga (Outdoor)', 'icon': Icons.self_improvement_rounded, 'type': 'location'},
      {'name': 'Calisthenics (Park)', 'icon': Icons.sports_gymnastics_rounded, 'type': 'location'},
      {'name': 'Rock Climbing', 'icon': Icons.hiking_rounded, 'type': 'location'},
      {'name': 'Golf', 'icon': Icons.sports_golf_rounded, 'type': 'location'},
      {'name': 'Disc Golf', 'icon': Icons.sports_golf_rounded, 'type': 'location'},
      {'name': 'Frisbee', 'icon': Icons.album_rounded, 'type': 'location'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final String query = searchController.text.toLowerCase();
            final filteredOptions = allOptions.where((opt) {
              return (opt['name'] as String).toLowerCase().contains(query);
            }).toList();

            final recentOpts = filteredOptions.where((opt) => opt['type'] == 'recent').toList();
            final distanceOpts = filteredOptions.where((opt) => opt['type'] == 'distance').toList();
            final locationOpts = filteredOptions.where((opt) => opt['type'] == 'location').toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B1E),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Modal handle
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Activity',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2C2C30),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white70, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Input
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white38, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 14),
                            onChanged: (val) {
                              setModalState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: 'Search activities...',
                              hintStyle: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 14),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Scrollable Lists
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // Recent
                        if (recentOpts.isNotEmpty) ...[
                          _buildSectionHeader('RECENT', null),
                          ...recentOpts.map((opt) => _buildRecentRow(opt)),
                          const SizedBox(height: 20),
                        ],
                        // Distance-Based
                        if (distanceOpts.isNotEmpty) ...[
                          _buildSectionHeader(
                            'Distance-Based Activities (GPS Required)',
                            'These involve moving from one place to another, so GPS tracks distance, pace, speed, and route.',
                          ),
                          ...distanceOpts.map((opt) => _buildOptionRow(opt)),
                          const SizedBox(height: 20),
                        ],
                        // Location-Based
                        if (locationOpts.isNotEmpty) ...[
                          _buildSectionHeader(
                            'Location-Based Activities (GPS Used for Presence)',
                            'These don’t rely on distance as much. GPS is mainly used to verify that the user is at a location or participating there.',
                          ),
                          ...locationOpts.map((opt) => _buildOptionRow(opt)),
                        ],
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, String? description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white38,
                fontSize: 10.5,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentRow(Map<String, dynamic> opt) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.history_rounded, color: Color(0xFFFF5722), size: 20),
      title: Text(
        opt['name'] as String,
        style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedActivityName = opt['name'] as String;
          _selectedActivityIcon = opt['icon'] as IconData;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildOptionRow(Map<String, dynamic> opt) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(opt['icon'] as IconData, color: _accent, size: 22),
      title: Text(
        opt['name'] as String,
        style: GoogleFonts.hankenGrotesk(
          color: Colors.white,
          fontSize: 14.5,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 20),
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedActivityName = opt['name'] as String;
          _selectedActivityIcon = opt['icon'] as IconData;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF131316),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              'Record Activity',
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Activity Selector Card
            _buildSectionTitleText('Select Activity'),
            const SizedBox(height: 10),
            _buildActivitySelectorCard(),
            const SizedBox(height: 24),

            // Section 2: Goal Selection Section
            _buildSectionTitleText('Set Your Goal'),
            const SizedBox(height: 10),
            _buildGoalGrid(),
            const SizedBox(height: 24),

            // Section 3: Interactive Numeric Input Area
            if (_selectedGoalIndex != 0) ...[
              _buildTargetInputArea(),
              const SizedBox(height: 24),
            ],

            const SizedBox(height: 120), // Spacer for sticky button
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        color: _bg.withValues(alpha: 0.95),
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _triggerStartActivity,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isStarting && _startButtonIcon == Icons.sync_rounded)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.5,
                    ),
                  )
                else
                  Icon(_startButtonIcon, size: 22),
                const SizedBox(width: 8),
                Text(
                  _startButtonText,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitleText(String text) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.hankenGrotesk(
        color: Colors.white38,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildActivitySelectorCard() {
    return GestureDetector(
      onTap: _showActivityPickerSheet,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_selectedActivityIcon, color: _accent, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACTIVITY',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white38,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _selectedActivityName,
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildGoalItem(0, Icons.all_inclusive_rounded, 'Open Activity', 'No specific target'),
        _buildGoalItem(1, Icons.straighten_rounded, 'Distance', 'Targeted route length'),
        _buildGoalItem(2, Icons.timer_rounded, 'Duration', 'Specific time window'),
        _buildGoalItem(3, Icons.local_fire_department_rounded, 'Calories', 'Energy burn goal'),
      ],
    );
  }

  Widget _buildGoalItem(int index, IconData icon, String title, String subtitle) {
    final bool isSelected = index == _selectedGoalIndex;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedGoalIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2A2A2D) : _cardBg.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _accent.withValues(alpha: 0.5) : Colors.transparent,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _accent, size: 20),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white,
                fontSize: 13,
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
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetInputArea() {
    String unit = '';
    String displayVal = '';
    List<String> presets = [];

    if (_selectedGoalIndex == 1) {
      unit = _distanceUnit;
      displayVal = _distanceValue.toStringAsFixed(2);
      presets = ['3 $unit', '5 $unit', '10 $unit', '21 $unit'];
    } else if (_selectedGoalIndex == 2) {
      unit = _durationUnit;
      displayVal = '$_durationValue';
      presets = ['15 $unit', '30 $unit', '45 $unit', '60 $unit'];
    } else if (_selectedGoalIndex == 3) {
      unit = _caloriesUnit;
      displayVal = '$_caloriesValue';
      presets = ['100 $unit', '300 $unit', '500 $unit', '700 $unit'];
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        children: [
          // Target display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                displayVal,
                style: GoogleFonts.anybody(
                  color: Colors.white,
                  fontSize: 54,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _showUnitPickerBottomSheet,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unit,
                      style: GoogleFonts.hankenGrotesk(
                        color: _accent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white38, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Visual Ruler Slider Simulation
          _buildRulerSlider(),
          const SizedBox(height: 16),

          // Presets Horizontal Row
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: presets.length,
              itemBuilder: (context, index) {
                final preset = presets[index];
                // Check if currently matching active preset
                bool isCurrentPreset = false;
                if (_selectedGoalIndex == 1) {
                  final double val = double.parse(preset.split(' ')[0]);
                  isCurrentPreset = val == _distanceValue;
                } else {
                  final int val = int.parse(preset.split(' ')[0]);
                  isCurrentPreset = val == (_selectedGoalIndex == 2 ? _durationValue : _caloriesValue);
                }

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      if (_selectedGoalIndex == 1) {
                        _distanceValue = double.parse(preset.split(' ')[0]);
                      } else if (_selectedGoalIndex == 2) {
                        _durationValue = int.parse(preset.split(' ')[0]);
                      } else {
                        _caloriesValue = int.parse(preset.split(' ')[0]);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isCurrentPreset ? const Color(0xFF2A2A2D) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isCurrentPreset ? _accent.withValues(alpha: 0.5) : Colors.white10,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      preset,
                      style: GoogleFonts.hankenGrotesk(
                        color: isCurrentPreset ? Colors.white : Colors.white54,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRulerSlider() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        HapticFeedback.selectionClick();
        setState(() {
          _rulerScrollOffset += details.primaryDelta!;
          
          // Adjust goal values based on movement direction (swiping left increases value)
          if (_selectedGoalIndex == 1) {
            _distanceValue = (_distanceValue - details.primaryDelta! * 0.02).clamp(1.0, 50.0);
          } else if (_selectedGoalIndex == 2) {
            final double step = _durationUnit == 'HR' ? 0.02 : 0.25;
            final int minVal = _durationUnit == 'HR' ? 1 : 5;
            final int maxVal = _durationUnit == 'HR' ? 10 : 600;
            _durationValue = (_durationValue - details.primaryDelta! * step).round().clamp(minVal, maxVal);
          } else if (_selectedGoalIndex == 3) {
            final double step = _caloriesUnit == 'CAL' ? 200.0 : 2.0;
            final int minVal = _caloriesUnit == 'CAL' ? 500 : 50;
            final int maxVal = _caloriesUnit == 'CAL' ? 100000 : 2000;
            _caloriesValue = (_caloriesValue - details.primaryDelta! * step).round().clamp(minVal, maxVal);
          }
        });
      },
      child: Container(
        height: 48,
        width: double.infinity,
        color: Colors.transparent, // Required for hit-testing empty areas
        child: CustomPaint(
          painter: RulerPainter(
            scrollOffset: _rulerScrollOffset,
            tickColor: Colors.white24,
            indicatorColor: _accent,
          ),
        ),
      ),
    );
  }

  void _showUnitPickerBottomSheet() {
    HapticFeedback.mediumImpact();
    List<String> options = [];
    String currentUnit = '';
    
    if (_selectedGoalIndex == 1) {
      options = ['KM', 'MI'];
      currentUnit = _distanceUnit;
    } else if (_selectedGoalIndex == 2) {
      options = ['MIN', 'HR'];
      currentUnit = _durationUnit;
    } else if (_selectedGoalIndex == 3) {
      options = ['KCAL', 'CAL'];
      currentUnit = _caloriesUnit;
    } else {
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1B1B1E),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Unit',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              ...options.map((opt) {
                final bool isSelected = opt == currentUnit;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    opt == 'KM' ? 'Kilometers (KM)' :
                    opt == 'MI' ? 'Miles (MI)' :
                    opt == 'MIN' ? 'Minutes (MIN)' :
                    opt == 'HR' ? 'Hours (HR)' :
                    opt == 'KCAL' ? 'Kilocalories (KCAL)' : 'Calories (CAL)',
                    style: GoogleFonts.hankenGrotesk(
                      color: isSelected ? _accent : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14.5,
                    ),
                  ),
                  trailing: isSelected ? Icon(Icons.check_rounded, color: _accent) : null,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      if (_selectedGoalIndex == 1) {
                        if (_distanceUnit != opt) {
                          _distanceUnit = opt;
                          if (opt == 'MI') {
                            _distanceValue = (_distanceValue * 0.621371).clamp(1.0, 50.0);
                          } else {
                            _distanceValue = (_distanceValue / 0.621371).clamp(1.0, 50.0);
                          }
                        }
                      } else if (_selectedGoalIndex == 2) {
                        if (_durationUnit != opt) {
                          _durationUnit = opt;
                          if (opt == 'HR') {
                            _durationValue = (_durationValue / 60.0).round().clamp(1, 10);
                          } else {
                            _durationValue = (_durationValue * 60).clamp(5, 600);
                          }
                        }
                      } else if (_selectedGoalIndex == 3) {
                        if (_caloriesUnit != opt) {
                          _caloriesUnit = opt;
                          if (opt == 'CAL') {
                            _caloriesValue = (_caloriesValue * 1000).clamp(500, 100000);
                          } else {
                            _caloriesValue = (_caloriesValue / 1000).round().clamp(50, 2000);
                          }
                        }
                      }
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class RulerPainter extends CustomPainter {
  final double scrollOffset;
  final Color tickColor;
  final Color indicatorColor;

  RulerPainter({
    required this.scrollOffset,
    required this.tickColor,
    required this.indicatorColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = tickColor
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final double midX = size.width / 2;
    final double tickSpacing = 12.0;
    final int numTicks = (size.width / tickSpacing).ceil() + 4;
    final double shift = scrollOffset % tickSpacing;

    canvas.clipRect(Offset.zero & size);

    for (int i = -numTicks ~/ 2; i <= numTicks ~/ 2; i++) {
      final double x = midX + i * tickSpacing + shift;
      if (x < 0 || x > size.width) continue;

      final int logicalIndex = (i - (scrollOffset / tickSpacing).round());
      final bool isMajor = logicalIndex % 5 == 0;

      final double tickHeight = isMajor ? 24.0 : 12.0;
      final double yStart = size.height - tickHeight;

      canvas.drawLine(
        Offset(x, yStart),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw central pointer
    final Paint indicatorPaint = Paint()
      ..color = indicatorColor
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(midX, size.height - 34.0),
      Offset(midX, size.height),
      indicatorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RulerPainter oldDelegate) {
    return oldDelegate.scrollOffset != scrollOffset ||
        oldDelegate.tickColor != tickColor ||
        oldDelegate.indicatorColor != indicatorColor;
  }
}


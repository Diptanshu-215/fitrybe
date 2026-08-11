import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/post_store.dart';

class CliqueLiveActivityScreen extends StatefulWidget {
  static const routeName = '/CliqueLiveActivityScreen';
  final bool isUpcoming;
  final String scheduledTime;
  final String activityName;
  final String activityType;
  final IconData? activityIcon;
  final String goalType;
  final double goalValue;
  final String goalUnit;

  const CliqueLiveActivityScreen({
    super.key,
    this.isUpcoming = false,
    this.scheduledTime = 'Today, 7:30 PM',
    this.activityName = 'Morning Trail Run',
    this.activityType = 'Running',
    this.activityIcon,
    this.goalType = 'Distance',
    this.goalValue = 5.0,
    this.goalUnit = 'km',
  });

  @override
  State<CliqueLiveActivityScreen> createState() =>
      _CliqueLiveActivityScreenState();
}

class _CliqueLiveActivityScreenState extends State<CliqueLiveActivityScreen>
    with TickerProviderStateMixin {
  final Color _accent = const Color(0xFFFF5722);
  final Color _cardBg = const Color(0xFF1F1F22);
  final Color _surfaceHigh = const Color(0xFF2A2A2D);
  final Color _bg = const Color(0xFF0F0F12);

  // Activity config
  String _selectedActivityName = 'Morning Trail Run';
  String _selectedActivityType = 'Running';
  IconData _selectedActivityIcon = Icons.directions_run_rounded;

  // Goal config
  String _goalType = 'Distance';
  double _goalValue = 5.0;
  String _goalUnit = 'km';

  // Animation controllers
  late AnimationController _pulseController;

  // Active tracking state
  bool _isUpcoming = false;
  String _scheduledTime = 'Today, 7:30 PM';
  bool _isStarting = false;
  String _startButtonText = 'START ACTIVITY';
  bool _isRecording = false;
  bool _isPaused = false;
  Timer? _stopwatchTimer;
  int _elapsedSeconds = 0;
  double _activeDistance = 0.0;
  int _activeCalories = 0;
  int _activeHeartRate = 142;
  final bool _currentUserIsAdmin = true;
  bool _isSheetMinimized = false;

  // Leaderboard filter
  String _selectedMetricFilter = 'DISTANCE';

  // Squad participants for Leaderboard & Lobby
  final List<Map<String, dynamic>> _squadMembers = [
    {
      'id': '1',
      'name': 'Alex (You)',
      'isAdmin': true,
      'isYou': true,
      'distance': 0.0,
      'pace': "5'30\"",
      'calories': 0,
      'heartRate': 142,
      'isReady': true,
      'status': 'ON ROUTE',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAhuan_9XDiLjk_DLAjsoiXsObZdg1XuOCm058HttWKateqbt9N7G0pbaUteIwR1gRhEah1bvRME8DuvjYOYwCPGDerNdxvcdgM846c1TD3-rehVMAJYVULf4HxyhRlP_Z_-1HWHv_2waIrSsAmbU46yU8rIpxxWndxcPyf6iBvjGgHGhHg3uNmwnHa9eu6FY93UiHqis-Hu0xkS5nW6AHd_CGiSqxFzFH0ZqXMUF0XRxFYH-8dPwIQ',
    },
    {
      'id': '2',
      'name': 'Sam',
      'isAdmin': false,
      'isYou': false,
      'distance': 5.12,
      'pace': "5'15\"",
      'calories': 310,
      'heartRate': 156,
      'isReady': true,
      'status': 'LEADING',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB_Tea3Dd8fZEwZwVBX6nlcLDGnZQEavh5VH22dcwrj5GtBWQjd4eVjGiiN78-seFzH33qRU4M9Ua5tdVkCRucCPndKPmTbpXp1ZvlwZXzJBH2xEDDOXhrp7qxBO2O7C0RFUyKE5VSSmoqiBQsHNyYokCS1JNfUiCUMcddTCknNmjinzT21tgWB56sIj9-3YKag19ufFUolU9CCJN1dnIDTJytZ3Nl6xyQDYyTWeX-hCs860KeZi054',
    },
    {
      'id': '3',
      'name': 'Jordan',
      'isAdmin': false,
      'isYou': false,
      'distance': 4.85,
      'pace': "5'45\"",
      'calories': 285,
      'heartRate': 148,
      'isReady': false,
      'status': 'SPRINTING',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuClOU2R-5Ojc_Q8zmrm27jSg2B_MK73_iyrnEWjkPIsCf9qhmtXPnyLfJIgWg4QjehQnjQD_ey2vrAYvcDQjDpdZtBo7fhsKX6KIK6T54EuCuBzn4B-0rQsT-hLewZC1uE2KUa8rmyffTjtzcDsJe-RQ2OqyDf_KIr5lC0cnqE8uta4flrGT_pLqS37tHdWbiHTNP_685LyRsiVscEMwN7mrQQOfvJSTZpbNpLVWYRYUwwZ9WV3gpKb',
    },
    {
      'id': '4',
      'name': 'David Kim',
      'isAdmin': false,
      'isYou': false,
      'distance': 4.20,
      'pace': "6'05\"",
      'calories': 260,
      'heartRate': 138,
      'isReady': true,
      'status': 'STEADY',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA6WB0sfMAaFfo5F_dwIad6ZGs7ulSBob3FMmrDmhtOJzchQRO1kQ477arp3E_zqR1e2HRU4O9zPR6NulCUQptJRJL0L1KYYDH5oPi92uqu8QsqUw-8xM09asGESGFKFyWIvWKw1Nl41cSnNhPABCmfjR6-XsgdajoAlsmMS8XGD13wiRcs-ayK0jhokb9QShfCCCYpwxgnKyz27HxCLrn5LXsL65kly2HvBKh8-o7-1dMd4-7UWF2HIklx4QomICGvKy6NbcwPmwo',
    },
    {
      'id': '5',
      'name': 'Maya Patel',
      'isAdmin': false,
      'isYou': false,
      'distance': 3.90,
      'pace': "6'20\"",
      'calories': 240,
      'heartRate': 135,
      'isReady': true,
      'status': 'CRUISING',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDAP1fzvajosGDCVTnUyqq4353TwT5L9hbdzIAbfVjL23jJvqwjbbg9OEdJD3tgrwrmFKd9QBHpnh_P_TAreUaxMF87aHQGluoDMjKAIMNydXCSFOz7NoDC-C0qQ0PAQytcLv3yf-_Ht2YrCPaoIeHWLOjIWHct32nVuTRlVDle0tfc8u70qmwS3nvQ6yfc3tpX2A_w0nrzZOlzqFt3ArMcMGIp3JUD66upNfTKxZBZ-Dwvs3Mtpy1CCuj2LRYp3YM6QZk5MMqMx2A',
    },
  ];

  @override
  void initState() {
    super.initState();
    _isUpcoming = widget.isUpcoming;
    _scheduledTime = widget.scheduledTime;
    _selectedActivityName = widget.activityName;
    _selectedActivityType = widget.activityType;
    if (widget.activityIcon != null) {
      _selectedActivityIcon = widget.activityIcon!;
    }
    _goalType = widget.goalType;
    _goalValue = widget.goalValue;
    _goalUnit = widget.goalUnit;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _stopwatchTimer?.cancel();
    super.dispose();
  }

  void _triggerStartActivity() {
    if (_isStarting) return;
    HapticFeedback.heavyImpact();
    setState(() {
      _isStarting = true;
      _startButtonText = 'SYNCING SQUAD...';
    });
    int countdown = 3;
    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (countdown > 0) {
        setState(() {
          _startButtonText = '$countdown...';
        });
        countdown--;
      } else {
        timer.cancel();
        setState(() {
          _isStarting = false;
          _isRecording = true;
          _isPaused = false;
        });
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _stopwatchTimer?.cancel();
    _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (!_isPaused) {
        setState(() {
          _elapsedSeconds++;
          _activeDistance += 0.0032;
          _activeCalories = (_elapsedSeconds * 0.165).toInt();
          final rand = Random();
          _activeHeartRate = 140 + rand.nextInt(10);

          // Update user's squad member record
          final you = _squadMembers.firstWhere(
            (m) => m['isYou'] == true,
            orElse: () => _squadMembers[0],
          );
          you['distance'] = _activeDistance;
          you['calories'] = _activeCalories;
          you['heartRate'] = _activeHeartRate;
          you['pace'] = _getPaceString();

          // Smoothly advance other squad members for live dynamic competition feel
          for (var member in _squadMembers) {
            if (member['isYou'] != true) {
              final double inc = 0.0025 + (rand.nextDouble() * 0.0012);
              member['distance'] = (member['distance'] as double) + inc;
              member['calories'] =
                  ((member['distance'] as double) * 60).toInt();
            }
          }

          // Dynamic sort based on chosen metric
          _sortSquadMembers();
        });
      }
    });
  }

  void _sortSquadMembers() {
    if (_selectedMetricFilter == 'DISTANCE') {
      _squadMembers.sort((a, b) => (b['distance'] as double)
          .compareTo(a['distance'] as double));
    } else if (_selectedMetricFilter == 'CALORIES') {
      _squadMembers.sort((a, b) =>
          (b['calories'] as int).compareTo(a['calories'] as int));
    }
  }

  void _togglePause() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _finishAndSaveActivity() {
    HapticFeedback.heavyImpact();
    _stopwatchTimer?.cancel();
    final formattedTime = _formatElapsedTime(_elapsedSeconds);
    final statsString =
        "Distance: ${_activeDistance.toStringAsFixed(2)} KM, Duration: $formattedTime, Calories: $_activeCalories KCAL.";
    PostStore.instance.addPost(
      UserPost(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        caption:
            "Just completed a $_selectedActivityType ($_selectedActivityName) workout with my Clique! $statsString",
        type: "Activity",
        audience: "Everyone",
        locationTag: "San Francisco, CA",
        imagePaths: [],
        createdAt: DateTime.now(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _accent,
        content: Text(
          '$_selectedActivityName activity saved successfully!',
          style: GoogleFonts.hankenGrotesk(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    Navigator.pop(context);
  }

  String _formatElapsedTime(int seconds) {
    final int m = seconds ~/ 60;
    final int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _getPaceString() {
    if (_activeDistance < 0.01) return "5'30\"";
    final double totalMinutes = (_elapsedSeconds / 60.0);
    final double minutesPerKm = totalMinutes / _activeDistance;
    final int minPart = minutesPerKm.toInt();
    final int secPart = ((minutesPerKm - minPart) * 60).toInt();
    return "$minPart'${secPart.toString().padLeft(2, '0')}\"";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header Bar ───────────────────────────────────────────────
            _buildTopHeader(),

            // ── Main Content Area: Live Leaderboard + Controls ─────────────
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        _isRecording ? 260 : 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Goal Completion Card
                          _buildGoalCompletionCard(),
                          const SizedBox(height: 20),

                          if (_isRecording) ...[
                            // Leaderboard Title & Filter Row
                            _buildLeaderboardHeader(),
                            const SizedBox(height: 16),

                            // Full Rankings List
                            _buildRankingsList(),
                          ] else ...[
                            // Lobby Controls rendered directly on screen
                            _buildLobbyMainContent(),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // ── Active Recording Metrics Modal (Only when live) ────
                  if (_isRecording)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _buildActiveMetricsSheet(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Top Header Widget ───────────────────────────────────────────────────
  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedActivityName,
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(_selectedActivityIcon, color: _accent, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        _selectedActivityType.toUpperCase(),
                        style: GoogleFonts.hankenGrotesk(
                          color: _accent,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              // Live/Recording badge
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) => Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _isRecording ? Colors.redAccent : Colors.orange,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isRecording
                                    ? Colors.redAccent
                                    : Colors.orange)
                                .withValues(
                              alpha: _pulseController.value * 0.8,
                            ),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isRecording ? 'LIVE' : 'LOBBY',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Goal Completion Card ──────────────────────────────────────────────────
  Widget _buildGoalCompletionCard() {
    double currentVal = _activeDistance;
    if (_goalType == 'Duration') {
      currentVal = _elapsedSeconds / 60.0;
    } else if (_goalType == 'Calories') {
      currentVal = _activeCalories.toDouble();
    }

    final double goalVal = _goalValue > 0 ? _goalValue : 5.0;
    final double progress = (currentVal / goalVal).clamp(0.0, 1.0);
    final int percent = (progress * 100).toInt();

    String currentStr = currentVal.toStringAsFixed(2);
    String targetStr = goalVal.toStringAsFixed(2);
    if (_goalType == 'Duration' ||
        _goalType == 'Calories' ||
        _goalType == 'Steps') {
      currentStr = currentVal.toInt().toString();
      targetStr = goalVal.toInt().toString();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2E).withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _accent.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _accent.withValues(alpha: 0.08),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Goal Title & Target Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _accent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _goalType == 'Duration'
                              ? Icons.timer_rounded
                              : _goalType == 'Calories'
                                  ? Icons.local_fire_department_rounded
                                  : Icons.flag_rounded,
                          color: _accent,
                          size: 17,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$_goalType Goal'.toUpperCase(),
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _accent.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'TARGET: $targetStr $_goalUnit',
                      style: GoogleFonts.hankenGrotesk(
                        color: _accent,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Row 2: Progress Numbers & Percentage
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$currentStr ',
                          style: GoogleFonts.anybody(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: '/ $targetStr $_goalUnit',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white38,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: GoogleFonts.anybody(
                      color: progress >= 1.0 ? Colors.greenAccent : _accent,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Row 3: Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 10,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        color: const Color(0xFF2A2A2D),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFF5722),
                                Color(0xFFFF8A65),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Row 4: Status text
              Text(
                progress >= 1.0
                    ? '0 $_goalUnit remaining'
                    : '${((1.0 - progress) * goalVal).toStringAsFixed(1)} $_goalUnit remaining',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Leaderboard Header & Metric Filters ─────────────────────────────────
  Widget _buildLeaderboardHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clique Leaderboard',
          style: GoogleFonts.hankenGrotesk(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        // Filter pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildFilterChip('DISTANCE', Icons.straighten_rounded),
              const SizedBox(width: 8),
              _buildFilterChip('CALORIES', Icons.local_fire_department_rounded),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final bool isSelected = _selectedMetricFilter == label;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedMetricFilter = label;
          _sortSquadMembers();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? _accent
              : const Color(0xFF1E1E22).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? _accent
                : Colors.white.withValues(alpha: 0.08),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.35),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white54,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.hankenGrotesk(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Full Rankings List ───────────────────────────────────────────────────
  Widget _buildRankingsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ALL PARTICIPANTS',
          style: GoogleFonts.hankenGrotesk(
            color: Colors.white38,
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _squadMembers.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final member = _squadMembers[index];
            return _buildRankTile(member, index + 1);
          },
        ),
      ],
    );
  }

  Widget _buildRankTile(Map<String, dynamic> member, int rank) {
    final bool isYou = member['isYou'] as bool? ?? false;
    final String name = member['name'] as String;
    final double dist = (member['distance'] as num).toDouble();
    final int calories = member['calories'] as int? ?? 0;

    final String metricText = _selectedMetricFilter == 'CALORIES'
        ? '$calories kcal'
        : '${dist.toStringAsFixed(2)} km';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isYou
            ? _accent.withValues(alpha: 0.12)
            : _cardBg.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isYou
              ? _accent.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.04),
          width: isYou ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // Plain Grey Rank Number
          SizedBox(
            width: 24,
            child: Text(
              '$rank',
              style: GoogleFonts.anybody(
                color: Colors.white54,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Avatar
          ClipOval(
            child: Image.network(
              member['avatar'] as String,
              width: 38,
              height: 38,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Details (Name + YOU badge)
          Expanded(
            child: Row(
              children: [
                Text(
                  name,
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isYou) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'YOU',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Primary metric value (Distance or Calories)
          Text(
            metricText,
            style: GoogleFonts.anybody(
              color: isYou ? _accent : Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Lobby Main Content (Rendered directly on screen) ────────────────────
  Widget _buildLobbyMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Squad Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.group_rounded, color: _accent, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Squad',
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${_squadMembers.length}/8)',
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white38,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            if (_currentUserIsAdmin)
              GestureDetector(
                onTap: _showInviteSheet,
                child: Row(
                  children: [
                    Icon(
                      Icons.person_add_rounded,
                      color: _accent,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Invite',
                      style: GoogleFonts.hankenGrotesk(
                        color: _accent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Squad list
        ..._squadMembers.map(
              (m) => SlidableSquadTile(
                key: ValueKey(m['id']),
                member: m,
                onRemove: () {
                  setState(() {
                    _squadMembers
                        .removeWhere((item) => item['id'] == m['id']);
                  });
                },
              ),
            ),

        const SizedBox(height: 24),

        // Start button for Admin vs Ready button for Participant
        if (_currentUserIsAdmin)
          if (_isUpcoming)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _showScheduledOptionsModal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2A2D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                  side: BorderSide(color: _accent.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.schedule_rounded, color: _accent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'SCHEDULED FOR $_scheduledTime',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _triggerStartActivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  _startButtonText,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            )
        else ...[
          Builder(
            builder: (context) {
              final userMember = _squadMembers.firstWhere(
                (m) => m['isYou'] == true,
                orElse: () => _squadMembers[0],
              );
              final bool isUserReady = userMember['isReady'] as bool;
              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    setState(() {
                      userMember['isReady'] = !isUserReady;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isUserReady
                        ? Colors.redAccent
                        : Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isUserReady
                            ? Icons.cancel_outlined
                            : Icons.check_circle_outline_rounded,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isUserReady ? 'CANCEL READY' : 'I\'M READY',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  // ─── Active Recording Metrics Sheet ──────────────────────────────────────
  Widget _buildActiveMetricsSheet() {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 100) {
          HapticFeedback.lightImpact();
          setState(() {
            _isSheetMinimized = true;
          });
        } else if (details.primaryVelocity! < -100) {
          HapticFeedback.lightImpact();
          setState(() {
            _isSheetMinimized = false;
          });
        }
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            decoration: BoxDecoration(
              color: const Color(0xFF141417).withValues(alpha: 0.45),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border(
                top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.18), width: 1.2),
                left: BorderSide(
                    color: Colors.white.withValues(alpha: 0.18), width: 1.2),
                right: BorderSide(
                    color: Colors.white.withValues(alpha: 0.18), width: 1.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(
              20,
              _isSheetMinimized ? 2 : 12,
              20,
              MediaQuery.of(context).padding.bottom +
                  (_isSheetMinimized ? 4 : 16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Drag Handle Pill
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _isSheetMinimized = !_isSheetMinimized;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: _isSheetMinimized ? 2 : 4),
                    color: Colors.transparent,
                    child: Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: _isSheetMinimized ? 0 : 8),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 320),
                  firstCurve: Curves.easeInOut,
                  secondCurve: Curves.easeInOut,
                  sizeCurve: Curves.easeInOutCubic,
                  crossFadeState: _isSheetMinimized
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Primary Metrics Grid (Distance & Duration)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'YOUR DISTANCE',
                                  style: GoogleFonts.hankenGrotesk(
                                    color: Colors.white38,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      _activeDistance.toStringAsFixed(2),
                                      style: GoogleFonts.anybody(
                                        color: Colors.white,
                                        fontSize: 44,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'km',
                                      style: GoogleFonts.hankenGrotesk(
                                        color: Colors.white38,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(width: 1, height: 48, color: Colors.white12),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'DURATION',
                                  style: GoogleFonts.hankenGrotesk(
                                    color: Colors.white38,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatElapsedTime(_elapsedSeconds),
                                  style: GoogleFonts.anybody(
                                    color: Colors.white,
                                    fontSize: 44,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Secondary Metrics Bento Grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildBentoCard(
                              'AVG PACE',
                              _getPaceString(),
                              '/km',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildBentoCard(
                              'CALORIES',
                              '$_activeCalories',
                              'kcal',
                              hasAccentBorder: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildBentoCard(
                              'AVG BPM',
                              '$_activeHeartRate',
                              'bpm',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Main Action Control Button
                      if (!_isPaused)
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _togglePause,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _accent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: const StadiumBorder(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.pause_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'PAUSE',
                                  style: GoogleFonts.hankenGrotesk(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _togglePause,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: Text(
                                    'RESUME',
                                    style: GoogleFonts.hankenGrotesk(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _finishAndSaveActivity,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _accent,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: Text(
                                    'FINISH & SAVE',
                                    style: GoogleFonts.hankenGrotesk(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  secondChild: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'DISTANCE',
                                  style: GoogleFonts.hankenGrotesk(
                                    color: Colors.white38,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      _activeDistance.toStringAsFixed(2),
                                      style: GoogleFonts.anybody(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      'km',
                                      style: GoogleFonts.hankenGrotesk(
                                        color: Colors.white38,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'TIME',
                                  style: GoogleFonts.hankenGrotesk(
                                    color: Colors.white38,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Text(
                                  _formatElapsedTime(_elapsedSeconds),
                                  style: GoogleFonts.anybody(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: GestureDetector(
                            onTap: _togglePause,
                            child: Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: _accent,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _accent.withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isPaused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBentoCard(
    String label,
    String value,
    String unit, {
    bool hasAccentBorder = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: _surfaceHigh,
        borderRadius: BorderRadius.circular(20),
        border: hasAccentBorder
            ? const Border(
                bottom: BorderSide(color: Color(0xFFFF5722), width: 3),
              )
            : Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: GoogleFonts.hankenGrotesk(
                color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }

  // ─── Interactive Helper Sheets ────────────────────────────────────────────
  void _showInviteSheet() {
    HapticFeedback.mediumImpact();
    final List<Map<String, String>> availableFriends = [
      {
        'name': 'David Kim',
        'subtitle': '@davidk • Swimmer',
        'avatar':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA6WB0sfMAaFfo5F_dwIad6ZGs7ulSBob3FMmrDmhtOJzchQRO1kQ477arp3E_zqR1e2HRU4O9zPR6NulCUQptJRJL0L1KYYDH5oPi92uqu8QsqUw-8xM09asGESGFKFyWIvWKw1Nl41cSnNhPABCmfjR6-XsgdajoAlsmMS8XGD13wiRcs-ayK0jhokb9QShfCCCYpwxgnKyz27HxCLrn5LXsL65kly2HvBKh8-o7-1dMd4-7UWF2HIklx4QomICGvKy6NbcwPmwo',
      },
      {
        'name': 'Maya Patel',
        'subtitle': '@mayap • Yoga Enthusiast',
        'avatar':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDAP1fzvajosGDCVTnUyqq4353TwT5L9hbdzIAbfVjL23jJvqwjbbg9OEdJD3tgrwrmFKd9QBHpnh_P_TAreUaxMF87aHQGluoDMjKAIMNydXCSFOz7NoDC-C0qQ0PAQytcLv3yf-_Ht2YrCPaoIeHWLOjIWHct32nVuTRlVDle0tfc8u70qmwS3nvQ6yfc3tpX2A_w0nrzZOlzqFt3ArMcMGIp3JUD66upNfTKxZBZ-Dwvs3Mtpy1CCuj2LRYp3YM6QZk5MMqMx2A',
      },
      {
        'name': 'Chris Vance',
        'subtitle': '@chris.v • Crossfit',
        'avatar':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBWx5umQiyz5zTsO2R59sz6-ZJBoCs_nZs85WNJFvHFAXTu2QdPMQAnLFwnsOjJEqaKcAdcpv9qPq6NQlJV7p3SyDX5EIVrn0bEU9-AP4_8x_xEUVHdOiDAP3wLWp-IHQa66Tlzzu2-LDvsB2lxqL53shYINDqc8cVbqVZ_A5LMSmdfU-nToulwi9Fj81mCD9UTzqkJlubLx5AcUiLKC8JqNPOE2QnZ7YAtQXOmHziYWkiMpbPMGmnYNiBMEoC970DEuzYd659rK9k',
      },
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2E).withValues(alpha: 0.60),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(
                  top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.18), width: 1.2),
                  left: BorderSide(
                      color: Colors.white.withValues(alpha: 0.18), width: 1.2),
                  right: BorderSide(
                      color: Colors.white.withValues(alpha: 0.18), width: 1.2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Invite to Squad',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...availableFriends.map((f) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipOval(
                        child: Image.network(
                          f['avatar']!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        f['name']!,
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        f['subtitle']!,
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _squadMembers.add({
                              'id': DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              'name': f['name']!,
                              'isAdmin': false,
                              'isYou': false,
                              'distance': 0.0,
                              'pace': "5'45\"",
                              'calories': 0,
                              'heartRate': 140,
                              'isReady': true,
                              'status': 'ON ROUTE',
                              'avatar': f['avatar']!,
                            });
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'Invite',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showScheduledOptionsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2E).withValues(alpha: 0.60),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(
                  top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.18), width: 1.2),
                  left: BorderSide(
                      color: Colors.white.withValues(alpha: 0.18), width: 1.2),
                  right: BorderSide(
                      color: Colors.white.withValues(alpha: 0.18), width: 1.2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _accent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.schedule_rounded,
                            color: _accent, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Scheduled Activity',
                              style: GoogleFonts.hankenGrotesk(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Scheduled for $_scheduledTime',
                              style: GoogleFonts.hankenGrotesk(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _isUpcoming = false;
                        });
                        _triggerStartActivity();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        'START NOW EARLY',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        'KEEP SCHEDULED',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Slidable Squad Participant Tile Widget ──────────────────────────────────
class SlidableSquadTile extends StatefulWidget {
  final Map<String, dynamic> member;
  final VoidCallback onRemove;
  const SlidableSquadTile({
    super.key,
    required this.member,
    required this.onRemove,
  });

  @override
  State<SlidableSquadTile> createState() => _SlidableSquadTileState();
}

class _SlidableSquadTileState extends State<SlidableSquadTile> {
  double _dragOffset = 0.0;
  static const double _actionWidth = 84.0;

  @override
  Widget build(BuildContext context) {
    final bool isReady = widget.member['isReady'] as bool;
    final bool isAdmin = widget.member['isAdmin'] as bool? ?? false;
    final String name = widget.member['name'] as String;
    if (isAdmin) {
      return _buildTileContent(
        name,
        isReady,
        isAdmin,
        margin: const EdgeInsets.only(bottom: 10),
      );
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  widget.onRemove();
                },
                child: Container(
                  width: _actionWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.delete_outline_rounded,
                          color: Colors.white, size: 22),
                      const SizedBox(height: 2),
                      Text(
                        'Remove',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _dragOffset += details.delta.dx;
                if (_dragOffset < -_actionWidth) _dragOffset = -_actionWidth;
                if (_dragOffset > 0) _dragOffset = 0;
              });
            },
            onHorizontalDragEnd: (details) {
              setState(() {
                if (_dragOffset < -(_actionWidth / 2)) {
                  _dragOffset = -_actionWidth;
                } else {
                  _dragOffset = 0.0;
                }
              });
            },
            child: Transform.translate(
              offset: Offset(_dragOffset, 0),
              child: _buildTileContent(
                name,
                isReady,
                isAdmin,
                margin: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTileContent(
    String name,
    bool isReady,
    bool isAdmin, {
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isAdmin ? const Color(0xFF2A2A2D) : const Color(0xFF1F1F22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAdmin
              ? const Color(0xFFFF5722).withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  widget.member['avatar'] as String,
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isAdmin) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFFF5722).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xFFFF5722)
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            'ADMIN',
                            style: GoogleFonts.hankenGrotesk(
                              color: const Color(0xFFFF5722),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Pace: ${widget.member['pace']}',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isReady
                  ? Colors.green.withValues(alpha: 0.15)
                  : Colors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isReady
                    ? Colors.green.withValues(alpha: 0.4)
                    : Colors.orange.withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              isReady ? 'READY' : 'NOT READY',
              style: GoogleFonts.hankenGrotesk(
                color: isReady ? Colors.greenAccent : Colors.orangeAccent,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

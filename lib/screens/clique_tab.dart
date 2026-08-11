import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'clique_live_activity_screen.dart';

class CliqueTab extends StatefulWidget {
  final ValueChanged<int>? onSubTabChanged;
  const CliqueTab({super.key, this.onSubTabChanged});

  @override
  State<CliqueTab> createState() => _CliqueTabState();
}

class _CliqueTabState extends State<CliqueTab>
    with TickerProviderStateMixin {
  final Color _accent = const Color(0xFFFF5722);
  final Color _cardBg = const Color(0xFF1E1E22);

  int _activeSegmentTab = 0; // 0: Activity, 1: Challenges, 2: Synergy
  final String _selectedCategory = 'All';

  final Set<String> _joinedUpcomingIds = {};

  final List<Map<String, dynamic>> _liveActivities = [
    {
      'id': 'live_1',
      'title': 'Morning Trail Run ☀️',
      'clique': 'Daily Cardio Crew',
      'category': 'Running',
      'type': 'Running',
      'icon': Icons.directions_run_rounded,
      'progress': 0.72,
      'progressText': '3.6 / 5.0 KM',
      'participantsCount': 4,
      'maxParticipants': 5,
    },
    {
      'id': 'live_2',
      'title': 'Sunset Speed Cycling 🚴',
      'clique': 'Bay Area Cyclists',
      'category': 'Cycling',
      'type': 'Cycling',
      'icon': Icons.directions_bike_rounded,
      'progress': 0.45,
      'progressText': '11.2 / 25.0 KM',
      'participantsCount': 6,
      'maxParticipants': 8,
    },
  ];

  final List<Map<String, dynamic>> _upcomingActivities = [
    {
      'id': 'up_1',
      'title': 'Evening Walk',
      'category': 'Walking',
      'type': 'Walking',
      'icon': Icons.directions_walk_rounded,
      'dateDay': '19',
      'dateMonth': 'OCT',
      'time': '7:00 PM',
      'target': '10k Steps Target',
      'participantsCount': 5,
      'maxParticipants': 8,
    },
    {
      'id': 'up_2',
      'title': 'Weekend 50K Bike Ride',
      'category': 'Cycling',
      'type': 'Cycling',
      'icon': Icons.directions_bike_rounded,
      'dateDay': '22',
      'dateMonth': 'OCT',
      'time': '6:30 AM',
      'target': '50.0 KM Distance',
      'participantsCount': 7,
      'maxParticipants': 12,
    },
    {
      'id': 'up_3',
      'title': 'Sunrise Lake Swim',
      'category': 'Swimming',
      'type': 'Swimming',
      'icon': Icons.pool_rounded,
      'dateDay': '24',
      'dateMonth': 'OCT',
      'time': '8:00 AM',
      'target': '2.0 KM Laps',
      'participantsCount': 3,
      'maxParticipants': 6,
    },
  ];

  late AnimationController _liveBlinkController;

  // Synergy Orbit States
  double _orbitRotation = math.pi / 2; // Start with first member at bottom center
  Map<String, dynamic>? _selectedOrbitMember;
  late AnimationController _orbitFloatController;

  final List<Map<String, dynamic>> _orbitMembers = [
    {
      'id': 1,
      'name': 'Alex',
      'synergy': '88%',
      'streak': '5d',
      'dist': '120k',
      'time': '15h',
      'activities': '24',
      'fav': 'Trail Running',
      'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXupnMbL7ZDy_tRGVMEC1kpOvCgABrgviZkefNrNTx1k9I3H2UqRESPETj4d_xOKaCGFpbAh6kgfIzJV_5tvj9Y8Zji5qRG3PYKUrX0xs_h1nsfbpq44IIVQ2NJD4M8y4znvLPn7lfHirD7jwSLv0UhPmqj5GKzptgONnf5Ky04hsm-9yNnEI5T9B9dl6nhZNdiq0SB7jWKKd4XKSrq0C5I-mWdTuVeytelYr_p8_Ecr1KwFJwlOu_c',
    },
    {
      'id': 2,
      'name': 'Elena',
      'synergy': '72%',
      'streak': '3d',
      'dist': '45k',
      'time': '8h',
      'activities': '12',
      'fav': 'Yoga',
      'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDCQQabYLTohBmurAKr1RUN2IAmRiPuGsqFmInWzHEf__Aq8Lrup0DEecMWshiQqtOB1HAs-8fkX6PyMCEda_L3qGqU0Hd3pZ6C2Y99UPYmQjEvRzMX1Ola5UWClM-T51g-lXpPghN0dwlp7dEba8xTJJu76POnA9jCcIucHyiHs382ck93N92xzFSCg5Ed3_FxMZ4LfiX1hUbWrKGISFRwSRvCzC5BrI0mY3Ul_Hg9WbhgXrTKTFZULhLCg3sEkwFHYGol8j0dPoc',
    },
    {
      'id': 3,
      'name': 'Marcus',
      'synergy': '94%',
      'streak': '12d',
      'dist': '240k',
      'time': '28h',
      'activities': '48',
      'fav': 'Cycling',
      'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBgjRSNIhjmFhRP_8S3tuvi1UgLC68VGmAkh42cOH9VQliTiy7tCc6SthMMHXDQA4u5KVBjJbgUpMGDWngdIa0napfGh8KuaI2R7Vg5APFj_FuEPtSycFIZ0S48-A0mTSDF9pEM1B68-1eG3zJonxwSmwvmtIGw9-09xvJbXE20Bc3pv4KvyqQJNn1emw8tMbAY9KUjxJD_Lmjaw4Duenm3KPou27843mgzy-OF2cdC5p_ej4RvuGJAVUmHusIFbL2nb5sunZYAAqE',
    },
    {
      'id': 4,
      'name': 'Sarah',
      'synergy': '82%',
      'streak': '8d',
      'dist': '90k',
      'time': '12h',
      'activities': '18',
      'fav': 'Swimming',
      'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDKbEFetka61Uzn8RD44STxX3QwAz_xcaaMZ-qzvnunUmBoges-xYFwWQTFpXij18kynNXL1kCjJ7eHZrLBexMEquhDjbpT30ThWjuWEdlZaW_ByrqJdvwg18EsATBXBVms3RCoQVOkpH9PeZiVTAQVE1iGclOOB2OwI8EIuMCCTrdCrl7qcAnsjMphuMjE9MqHlVIp1wCbJOr1ql0Bsee3LkdKqgpT6d9PbFZUGm8ojitxqhE6k0tOEM1_5PnJwz9-xYmUS1H2faU',
    },
    {
      'id': 5,
      'name': 'Dave',
      'synergy': '79%',
      'streak': '4d',
      'dist': '65k',
      'time': '9h',
      'activities': '15',
      'fav': 'Weightlifting',
      'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBWx5umQiyz5zTsO2R59sz6-ZJBoCs_nZs85WNJFvHFAXTu2QdPMQAnLFwnsOjJEqaKcAdcpv9qPq6NQlJV7p3SyDX5EIVrn0bEU9-AP4_8x_xEUVHdOiDAP3wLWp-IHQa66Tlzzu2-LDvsB2lxqL53shYINDqc8cVbqVZ_A5LMSmdfU-nToulwi9Fj81mCD9UTzqkJlubLx5AcUiLKC8JqNPOE2QnZ7YAtQXOmHziYWkiMpbPMGmnYNiBMEoC970DEuzYd659rK9k',
    },
  ];

  @override
  void initState() {
    super.initState();
    _liveBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _orbitFloatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _liveBlinkController.dispose();
    _orbitFloatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _activeSegmentTab == 2 ? Colors.black : Colors.transparent,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sub-Tab Selector (Flat under-line style)
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildSegmentItem(0, 'Activity')),
                      Expanded(child: _buildSegmentItem(1, 'Challenges')),
                      Expanded(child: _buildSegmentItem(2, 'Synergy')),
                    ],
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ],
              ),
            ),

            // Conditional Content
            _activeSegmentTab == 0
                ? _buildActivityTab()
                : _activeSegmentTab == 1
                    ? _buildChallengesTab()
                    : _buildSynergyTabSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentItem(int index, String label) {
    final bool isActive = _activeSegmentTab == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _activeSegmentTab = index;
        });
        widget.onSubTabChanged?.call(index);
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? _accent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.hankenGrotesk(
            color: isActive ? _accent : Colors.white38,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // --- ACTIVITY TAB ---
  Widget _buildActivityTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clique Activity',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Move together. Stay motivated.',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white38,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Render No Activity State directly
          if (_liveActivities.isEmpty && _upcomingActivities.isEmpty)
            _buildEmptyActivityState()
          else ...[
            if (_getFilteredLiveActivities().isNotEmpty) ...[
              // Live Activities Section
              Text(
                'LIVE NOW',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white38,
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              // Render filtered Live Activities
              ..._getFilteredLiveActivities().map((act) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildLiveActivityCardDynamic(act),
                  )),
            ],
            if (_getFilteredUpcomingActivities().isNotEmpty) ...[
              // Upcoming Section
              Text(
                'UPCOMING',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white38,
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              // Render filtered Upcoming Activities
              ..._getFilteredUpcomingActivities().map((act) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildUpcomingActivityCardDynamic(act),
                  )),
            ],
          ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredLiveActivities() {
    if (_selectedCategory == 'All') return _liveActivities;
    return _liveActivities
        .where((a) => a['category'] == _selectedCategory)
        .toList();
  }

  List<Map<String, dynamic>> _getFilteredUpcomingActivities() {
    if (_selectedCategory == 'All') return _upcomingActivities;
    return _upcomingActivities
        .where((a) => a['category'] == _selectedCategory)
        .toList();
  }

  Widget _buildEmptyActivityState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glowing Icon Badge
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: _accent.withValues(alpha: 0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: _accent.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(
              Icons.directions_run_rounded,
              color: _accent,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'No Clique Activities Yet',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Join a group workout with your friends or schedule your first Clique activity to track live together.',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white54,
              fontSize: 13.5,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

        ],
      ),
    );
  }

  Widget _buildLiveActivityCardDynamic(Map<String, dynamic> act) {
    final String title = act['title'] as String;
    final String clique = act['clique'] as String;
    final String actType = act['type'] as String? ?? 'Running';
    final IconData icon = act['icon'] as IconData;
    final double progress = (act['progress'] as num).toDouble();
    final String progressText = act['progressText'] as String;
    final int pCount = act['participantsCount'] as int;
    final int maxP = act['maxParticipants'] as int;

    return Container(
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Live indicator header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _accent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    FadeTransition(
                      opacity: _liveBlinkController,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE NOW',
                      style: GoogleFonts.hankenGrotesk(
                        color: _accent,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Active Session',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white38,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Title Row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: _accent, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      clique,
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toInt()}% Goal Met',
                style: GoogleFonts.hankenGrotesk(
                  color: _accent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                progressText,
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white54,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(_accent),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildStackedAvatar(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuD8hDKxj4-r6R8f8AdaM3EVji_zeIwgSPFO5cPsoOQdNnP2WMtFn16ghzR2EV6BKxYC90N4Sce9VEb6Y6a7Noeqmgxx6Am9aDdSbwLwp6V74i0Vp_NC2R9wRxWYrDEXj0Y6SvchlV2xp_8UHLq8c1OCDhk6a5bK8s9bNiprCklvCQ20HpPN5Tvgee3pQP9V-fk8hxq1CmeJxvGcXy3xZSfWO5hMiAjrtJ8ZvPFGqPf-IapnbkrQYWw5eJ-MdhIpI6ToFK-8sTj6hRA'),
                  const SizedBox(width: 4),
                  _buildStackedAvatar(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuB-kK8DqGrsg2wgRF85wfvfo2roceLvv9THYdX7crrxp1AbPklw21sOX74b65g2KizCw9AkkgKJr95f4Ev1U2IXq3EXYuBCA1yd0E4RvpwW0QKxmUOTEwFgUYFb1VQK1vtuEmghq0wd5FAvXb-pnosFKa-TyuojSRalMGTz8wVBgBmDj76b1taOqJcKlSB2XRIpSz42oy5itv9an0NzwNm-CNbyDk2DQVCtFQV8RdP5TbtmJbzost5vs8-5LQxLUNRW89xvRqmNAWI'),
                ],
              ),
              Text(
                '$pCount/$maxP Participants',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CliqueLiveActivityScreen(
                      activityName: title,
                      activityType: actType,
                      activityIcon: icon,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Open Live Session',
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStackedAvatar(String url) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF1E1E22), width: 1.5),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildUpcomingActivityCardDynamic(Map<String, dynamic> act) {
    final String id = act['id'] as String;
    final String title = act['title'] as String;
    final String actType = act['type'] as String? ?? 'Walking';
    final IconData icon = act['icon'] as IconData;
    final String dateDay = act['dateDay'] as String;
    final String dateMonth = act['dateMonth'] as String;
    final String time = act['time'] as String;
    final int pCount = act['participantsCount'] as int;
    final bool isJoined = _joinedUpcomingIds.contains(id);
    final int displayPCount = isJoined ? pCount + 1 : pCount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isJoined ? _accent.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.03),
        ),
      ),
      child: Row(
        children: [
          // Date badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dateDay,
                  style: GoogleFonts.anybody(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  dateMonth,
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white38,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.schedule, color: Colors.white38, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white54,
                        fontSize: 11.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• $displayPCount joined',
                      style: GoogleFonts.hankenGrotesk(
                        color: isJoined ? Colors.greenAccent : Colors.white38,
                        fontSize: 11.5,
                        fontWeight: isJoined ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // View Lobby / Join CTA
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CliqueLiveActivityScreen(
                    isUpcoming: true,
                    scheduledTime: '$dateMonth $dateDay, $time',
                    activityName: title,
                    activityType: actType,
                    activityIcon: icon,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isJoined ? _accent.withValues(alpha: 0.2) : const Color(0xFF2A2A2D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isJoined ? _accent : Colors.transparent,
                ),
              ),
              child: Text(
                isJoined ? 'LOBBY ✓' : 'LOBBY',
                style: GoogleFonts.hankenGrotesk(
                  color: isJoined ? _accent : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- CHALLENGES TAB ---
  Widget _buildChallengesTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Challenges',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Compete. Complete. Achieve.',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white38,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 20),

          // Featured Card Banner
          _buildFeaturedChallengeBanner(),
          const SizedBox(height: 20),

          // Active Section
          Text(
            'ACTIVE',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white38,
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),

          // Weekend Warrior Card
          _buildActiveChallengeCard(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFeaturedChallengeBanner() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBxdHh6fP0l0pbtPDTac7da62bR5eiiOPAuqtwPq8-Scp6zmz7NUM2H_NF_VlUduH0Culz17A_AQ5W-62YHz__jLl2AUanMfkGB-E94ZxkgBiNXQ0hd0ujnn1pVQYkcpcR1QE57AQNaCqZb5OVD8I30ToY5Mrgogy2B0Ig611Yys-CwJVHK8_EGxji_LSa2fmBaz0X7RHu00V0mSObISBPjKNJF6B7RWQMqF0ymuIcB2_WZV8yzLkq-krq5urFqHNvTPrhMsnOjqZw',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black26, Color(0xCC0F0F12)],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Count Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'FEATURED',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.group_rounded,
                      color: Colors.white54,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '2450 Joined',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white70,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              '30 Day Running Challenge 🏃',
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),

            // Mini stats grid
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PROGRESS',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white38,
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.anybody(
                              color: _accent,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                            ),
                            children: [
                              const TextSpan(text: '32 / 50 '),
                              TextSpan(
                                text: 'KM',
                                style: GoogleFonts.hankenGrotesk(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOUR RANK',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white38,
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '#24',
                          style: GoogleFonts.anybody(
                            color: _accent,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveChallengeCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Rank Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekend Warrior ⚔️',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_walk_rounded,
                        color: Colors.white38,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '20,000 Steps',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white38,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '3 Days Left',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'CURRENT RANK',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white38,
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '#102',
                    style: GoogleFonts.anybody(
                      color: _accent,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress line
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.45,
              minHeight: 5,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(
                _accent.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Continue CTA
          SizedBox(
            height: 44,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: _accent,
                    content: Text(
                      'Opening Weekend Warrior dashboard...',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: _accent,
                side: BorderSide(color: _accent.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Continue',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSynergyTabSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Synergy Orbit',
            style: GoogleFonts.anybody(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Explore your closest connections.',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white38,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 32),

          // Orbit Visualization Container
          _buildOrbitView(),
          const SizedBox(height: 24),

          // Slide-up Details Container
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstCurve: Curves.easeInOut,
            secondCurve: Curves.easeInOut,
            crossFadeState: _selectedOrbitMember != null
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(height: 0),
            secondChild: _buildSelectedMemberDetailsSheet(),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildOrbitView() {
    const double orbitSize = 280.0;
    const double radius = 100.0;
    const double centerOffset = orbitSize / 2;

    // Calculate coordinates for connection line
    Offset? lineStart;
    Offset? lineEnd;
    if (_selectedOrbitMember != null) {
      final index = _orbitMembers.indexWhere((m) => m['id'] == _selectedOrbitMember!['id']);
      if (index != -1) {
        final double baseAngle = (index / _orbitMembers.length) * 2 * math.pi;
        final double angle = baseAngle + _orbitRotation;
        lineStart = const Offset(centerOffset, centerOffset);
        lineEnd = Offset(
          centerOffset + radius * math.cos(angle),
          centerOffset + radius * math.sin(angle),
        );
      }
    }

    return Center(
      child: Container(
        width: orbitSize,
        height: orbitSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
        ),
        child: GestureDetector(
          onPanUpdate: (details) {
            if (_selectedOrbitMember == null) {
              setState(() {
                _orbitRotation += details.delta.dx * 0.007;
              });
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Floating gradient 1
              AnimatedBuilder(
                animation: _orbitFloatController,
                builder: (context, child) {
                  final double floatVal = _orbitFloatController.value;
                  return Positioned(
                    left: centerOffset - 120 + 20 * math.sin(floatVal * 2 * math.pi),
                    top: centerOffset - 120 + 20 * math.cos(floatVal * 2 * math.pi),
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            _accent.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Floating gradient 2
              AnimatedBuilder(
                animation: _orbitFloatController,
                builder: (context, child) {
                  final double floatVal = _orbitFloatController.value;
                  return Positioned(
                    left: centerOffset - 100 - 25 * math.cos(floatVal * 2 * math.pi),
                    top: centerOffset - 100 - 25 * math.sin(floatVal * 2 * math.pi),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFFF9800).withValues(alpha: 0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Rotating Line Connection (Custom Painter)
              if (lineStart != null && lineEnd != null)
                Positioned.fill(
                  child: CustomPaint(
                    painter: OrbitLinePainter(
                      start: lineStart,
                      end: lineEnd,
                      color: _accent,
                    ),
                  ),
                ),

              // Orbit rim dashed border helper
              Positioned(
                left: centerOffset - radius,
                top: centerOffset - radius,
                child: Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.04),
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),

              // Center User Avatar (wrapped in AnimatedBuilder for float)
              AnimatedBuilder(
                animation: _orbitFloatController,
                builder: (context, child) {
                  final double floatVal = _orbitFloatController.value;
                  final double yOffset = floatVal * -4.0;
                  return Positioned(
                    left: centerOffset - 32,
                    top: centerOffset - 32 + yOffset,
                    child: child!,
                  );
                },
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _accent, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withValues(alpha: 0.25),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuByqReTPoPaqgAoIGx5u7rtuMwXJgIGXBB_-tKwSu1hAOaFlZpNn1b9K0eaZKQBim5F1jY9-ZA3oycSmvuwdqXmtrlvnJSzi4PTRsGa8NI-c-W27mqOrL3PXiWF6noRE4HMHeuWFTHZzqw9Hm5NlZXXXZDEAJuf1WW9Ob3LT4_oEQrTno7uUu5kk6Pt5SWCdDZ4B7NlGVZhIAJnN4OufENxsprStF0wCRDAfIw1YA6Q1J4cHLCNqby_5MwswfBa5iPlMoWCtSr7pxQ',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              // Orbiting Members (wrapped in AnimatedBuilder for wavy phase-shifted floating)
              ...List.generate(_orbitMembers.length, (index) {
                final member = _orbitMembers[index];
                final double baseAngle = (index / _orbitMembers.length) * 2 * math.pi;
                final double angle = baseAngle + _orbitRotation;

                final isSelected = _selectedOrbitMember != null && _selectedOrbitMember!['id'] == member['id'];
                final isAnySelected = _selectedOrbitMember != null;

                // Position math
                final double x = centerOffset + radius * math.cos(angle) - 24;
                final double y = centerOffset + radius * math.sin(angle) - 24;

                return AnimatedBuilder(
                  animation: _orbitFloatController,
                  builder: (context, child) {
                    final double floatVal = _orbitFloatController.value;
                    // Introduce a phase shift so avatars float asynchronously/wavy
                    final double phaseAngle = baseAngle;
                    final double yOffset = math.sin(floatVal * 2 * math.pi + phaseAngle) * -4.0;
                    return Positioned(
                      left: x,
                      top: y + yOffset,
                      child: child!,
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        if (_selectedOrbitMember != null && _selectedOrbitMember!['id'] == member['id']) {
                          _selectedOrbitMember = null;
                        } else {
                          _selectedOrbitMember = member;
                          // Rotate orbit to bring this clicked member to the front (bottom center = 90 deg / math.pi/2)
                          _orbitRotation = (math.pi / 2) - baseAngle;
                        }
                      });
                    },
                    child: AnimatedOpacity(
                      opacity: isSelected ? 1.0 : (isAnySelected ? 0.35 : 1.0),
                      duration: const Duration(milliseconds: 300),
                      child: AnimatedScale(
                        scale: isSelected ? 1.25 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? _accent : Colors.white10,
                              width: isSelected ? 2 : 1.5,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(member['avatar'] as String),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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
  }

  Widget _buildSelectedMemberDetailsSheet() {
    if (_selectedOrbitMember == null) return const SizedBox(height: 0);

    final member = _selectedOrbitMember!;
    final synergyNum = double.tryParse(member['synergy'].replaceAll('%', '')) ?? 80;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Progress ring
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(member['avatar'] as String),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member['name'] as String,
                        style: GoogleFonts.anybody(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'RISING DUO',
                        style: GoogleFonts.hankenGrotesk(
                          color: _accent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Synergy circular progress
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: synergyNum / 100,
                      strokeWidth: 6,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation<Color>(_accent),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        member['synergy'] as String,
                        style: GoogleFonts.anybody(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'MATCH',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white38,
                          fontSize: 6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Grid with stats
          Row(
            children: [
              Expanded(
                child: _buildSynergyStatBox('Activities', member['activities'] as String? ?? '24'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSynergyStatBox('Distance', member['dist']),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSynergyStatBox('Streak', member['streak']),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Shared Timeline
          Text(
            'SHARED ACTIVITY TIMELINE',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, idx) {
                final hasActivity = idx % 3 == 0;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Column(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasActivity ? _accent.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.03),
                          border: Border.all(
                            color: hasActivity ? _accent.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: hasActivity
                            ? Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _accent,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${30 - idx}d',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white38,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // History CTA
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: _accent,
                  content: Text(
                    'Shared activity history with ${member['name']} coming soon!',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: Text(
                'View Full History',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSynergyStatBox(String label, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161619),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: GoogleFonts.anybody(
              color: _accent,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white38,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class OrbitLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;

  OrbitLinePainter({required this.start, required this.end, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    // Gradient shader along the line
    paint.shader = ui.Gradient.linear(
      start,
      end,
      [color.withValues(alpha: 0.1), color],
    );

    canvas.drawLine(start, end, paint);

    // Glowing dot at the end
    final glowPaint = Paint()
      ..color = color
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(end, 6, glowPaint);
    
    final dotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(end, 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant OrbitLinePainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end || oldDelegate.color != color;
  }
}

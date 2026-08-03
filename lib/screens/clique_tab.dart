import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CliqueTab extends StatefulWidget {
  const CliqueTab({super.key});

  @override
  State<CliqueTab> createState() => _CliqueTabState();
}

class _CliqueTabState extends State<CliqueTab>
    with SingleTickerProviderStateMixin {
  final Color _accent = const Color(0xFFFF5722);
  final Color _cardBg = const Color(0xFF1E1E22);

  int _activeSegmentTab = 0; // 0: Activity, 1: Challenges
  int _activeCategoryIndex = 0; // 0: Running, 1: Walking, etc.
  bool _joinedLiveRun = false;

  late AnimationController _liveBlinkController;

  @override
  void initState() {
    super.initState();
    _liveBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _liveBlinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Segmented Navigation Header (Activity / Challenges)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B1E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildSegmentButton(0, 'Activity')),
                  Expanded(child: _buildSegmentButton(1, 'Challenges')),
                ],
              ),
            ),
          ),

          // Conditional Content
          _activeSegmentTab == 0 ? _buildActivityTab() : _buildChallengesTab(),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(int index, String label) {
    final bool isActive = _activeSegmentTab == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _activeSegmentTab = index;
        });
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2C2C30) : Colors.transparent,
          borderRadius: BorderRadius.circular(21),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.hankenGrotesk(
            color: isActive ? Colors.white : Colors.white38,
            fontSize: 13.5,
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
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: _accent,
                      content: Text(
                        'Create Clique Activity coming soon!',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withValues(alpha: 0.25),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Create',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Live Morning Run Card
          _buildLiveActivityCard(),
          const SizedBox(height: 24),

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

          // Evening Walk Card
          _buildUpcomingActivityCard(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildLiveActivityCard() {
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
          // Live indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
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
                'Started 12m ago',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white38,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Activity Icon & Title
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.directions_run_rounded,
                  color: _accent,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Morning Run ☀️',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Daily Cardio Crew',
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

          // Goal Met Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '72% Goal Met',
                style: GoogleFonts.hankenGrotesk(
                  color: _accent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '3.6 / 5.0 KM',
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
              value: 0.72,
              minHeight: 6,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(_accent),
            ),
          ),
          const SizedBox(height: 20),

          // Participants & Join Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Stacked user avatars
              Row(
                children: [
                  _buildStackedAvatar(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuD8hDKxj4-r6R8f8AdaM3EVji_zeIwgSPFO5cPsoOQdNnP2WMtFn16ghzR2EV6BKxYC90N4Sce9VEb6Y6a7Noeqmgxx6Am9aDdSbwLwp6V74i0Vp_NC2R9wRxWYrDEXj0Y6SvchlV2xp_8UHLq8c1OCDhk6a5bK8s9bNiprCklvCQ20HpPN5Tvgee3pQP9V-fk8hxq1CmeJxvGcXy3xZSfWO5hMiAjrtJ8ZvPFGqPf-IapnbkrQYWw5eJ-MdhIpI6ToFK-8sTj6hRA',
                  ),
                  const SizedBox(width: 4),
                  _buildStackedAvatar(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuB-kK8DqGrsg2wgRF85wfvfo2roceLvv9THYdX7crrxp1AbPklw21sOX74b65g2KizCw9AkkgKJr95f4Ev1U2IXq3EXYuBCA1yd0E4RvpwW0QKxmUOTEwFgUYFb1VQK1vtuEmghq0wd5FAvXb-pnosFKa-TyuojSRalMGTz8wVBgBmDj76b1taOqJcKlSB2XRIpSz42oy5itv9an0NzwNm-CNbyDk2DQVCtFQV8RdP5TbtmJbzost5vs8-5LQxLUNRW89xvRqmNAWI',
                  ),
                  const SizedBox(width: 4),
                  _buildStackedAvatar(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBXTVa1geTgmg-ddAxVrrOOJGkquwNpqpG9ny6VZ4764n6Fuy6Y3_BN8nmW9r905qjmaFLGrKo8LMPtc-x_edkdvwEMwM-Lt74Ary6r8lH2i1SBak_nK-VKRzFa1ZLe3rW9nVY6bwceYPdLUCpUUR5Lf85y3oHUA739fLYxb_duJEKE3Rcpu21BFqZP5gwHJTSWEnaARyNd03HjWQ2TIEq54rZSp6R2jwape6VitIcSlhnNDogAn1wwMwwcZw7W-XvhcdrsaLclYXs',
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '+1 more',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white38,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
              Text(
                '4/5 Participants',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _joinedLiveRun = !_joinedLiveRun;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: _accent,
                        content: Text(
                          _joinedLiveRun
                              ? 'Joined Morning Run successfully!'
                              : 'Left Morning Run.',
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
                      color: _joinedLiveRun ? Colors.white.withValues(alpha: 0.08) : _accent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _joinedLiveRun ? 'Leave Activity' : 'Join Activity',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: _accent,
                        content: Text(
                          'Connecting to Live Lobby...',
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
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2E2E32)),
                    ),
                    alignment: Alignment.center,
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

  Widget _buildUpcomingActivityCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Row(
        children: [
          // Date badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2D),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.02)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '19',
                  style: GoogleFonts.anybody(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'OCT',
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
                  'Evening Walk',
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: Colors.white38,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '7:00 PM',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.directions_walk_rounded,
                          color: Colors.white38,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '10k Steps Target',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // View Lobby CTA
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: _accent,
                  content: Text(
                    'Opening Evening Walk lobby...',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'View Lobby',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white,
                  fontSize: 11,
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

          // Category Chips horizontal list
          _buildCategoryChipsRow(),
          const SizedBox(height: 24),

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

  Widget _buildCategoryChipsRow() {
    final List<String> categories = [
      'Running',
      'Walking',
      'Cycling',
      'Strength',
    ];
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final String cat = categories[index];
          final bool active = index == _activeCategoryIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _activeCategoryIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: active ? _accent : _cardBg.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active
                        ? _accent.withValues(alpha: 0.5)
                        : Colors.white10,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  cat,
                  style: GoogleFonts.hankenGrotesk(
                    color: active ? Colors.white : Colors.white54,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
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
}

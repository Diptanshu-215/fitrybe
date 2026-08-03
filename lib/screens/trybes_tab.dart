import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TrybesTab extends StatefulWidget {
  final ValueChanged<int> onSubTabChanged;
  const TrybesTab({super.key, required this.onSubTabChanged});

  @override
  State<TrybesTab> createState() => _TrybesTabState();
}

class _TrybesTabState extends State<TrybesTab> {
  final Color _accent = const Color(0xFFFF5722);
  final Color _cardBg = const Color(0xFF1F1F22);

  // States
  int _activeFeedFilter = 0; // 0: Global, 1: My Trybes
  int _marcusLikesCount = 124;
  bool _marcusLiked = false;

  int _activeSubTab = 0; // 0: Trybe, 1: Friends
  String _friendSearchQuery = '';
  final TextEditingController _friendSearchController = TextEditingController();

  // Friend Request state
  bool _hasPendingRequest = true;

  // List of friends
  final List<Map<String, dynamic>> _friends = [
    {
      'name': 'Alex Mercer',
      'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAPJac6Lb0URSnKqe4BbcHLk5uXFWLHQZCaDxtPDbNcJG_WyveOuZcmItV-X1bAWs2r2SBhrToJBxv27J6iYYZTV_pAzkKXlGCBB8u3-qytLDB_DTKxbkFyndjRnIdaHGmOZDtEayjCDy3BEXN1Ad-nboUOj_gnYDNp0yUksh9RxOAisSoP4YHXG3Om6YME_BEeiTnOrBvR5x-XexZt6EEN9hfe4g-_zL6ocewUJMszV7fD_M9Ceq15L3UqR6kmDROZ2LGyKxR4BcQ',
      'status': 'Active now • Running',
      'detail': 'Hyde Park Flyers • 15.2 km this week',
      'isActive': true,
    },
    {
      'name': 'Marcus Chen',
      'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBgjRSNIhjmFhRP_8S3tuvi1UgLC68VGmAkh42cOH9VQliTiy7tCc6SthMMHXDQA4u5KVBjJbgUpMGDWngdIa0napfGh8KuaI2R7Vg5APFj_FuEPtSycFIZ0S48-A0mTSDF9pEM1B68-1eG3zJonxwSmwvmtIGw9-09xvJbXE20Bc3pv4KvyqQJNn1emw8tMbAY9KUjxJD_Lmjaw4Duenm3KPou27843mgzy-OF2cdC5p_ej4RvuGJAVUmHusIFbL2nb5sunZYAAqE',
      'status': 'Active 2h ago',
      'detail': 'Elite Runners • 12.4 km this week',
      'isActive': false,
    },
    {
      'name': 'Sarah J.',
      'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDKbEFetka61Uzn8RD44STxX3QwAz_xcaaMZ-qzvnunUmBoges-xYFwWQTFpXij18kynNXL1kCjJ7eHZrLBexMEquhDjbpT30ThWjuWEdlZaW_ByrqJdvwg18EsATBXBVms3RCoQVOkpH9PeZiVTAQVE1iGclOOB2OwI8EIuMCCTrdCrl7qcAnsjMphuMjE9MqHlVIp1wCbJOr1ql0Bsee3LkdKqgpT6d9PbFZUGm8ojitxqhE6k0tOEM1_5PnJwz9-xYmUS1H2faU',
      'status': 'Active 5h ago',
      'detail': 'Iron Addicts • 3/4 sessions',
      'isActive': false,
    },
  ];

  void _toggleMarcusLike() {
    HapticFeedback.lightImpact();
    setState(() {
      _marcusLiked = !_marcusLiked;
      if (_marcusLiked) {
        _marcusLikesCount++;
      } else {
        _marcusLikesCount--;
      }
    });
  }

  @override
  void dispose() {
    _friendSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-Tab Segmented Selector
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B1E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildSubTabButton(0, 'Trybe')),
                  Expanded(child: _buildSubTabButton(1, 'Friends')),
                ],
              ),
            ),
          ),
          _activeSubTab == 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Section 2: My Trybes Carousel
                    _buildMyTrybesSection(),
                    const SizedBox(height: 24),

                    // Section 3: Local Groups
                    _buildLocalGroupsSection(),
                    const SizedBox(height: 24),

                    // Section 4: Trybe Feed
                    _buildTrybeFeedSection(),
                    const SizedBox(height: 100), // Padding for mobile floating navigation
                  ],
                )
              : _buildFriendsTabSection(),
        ],
      ),
    );
  }

  Widget _buildMyTrybesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Trybes',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'SEE ALL',
                style: GoogleFonts.hankenGrotesk(
                  color: _accent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              // Card 1: Elite Runners
              _buildTrybeCarouselCard(
                'Elite Runners',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDegFaC4Ag757kCG6u-XWSSoEytMNfsVKTDGaGZBHQd6UtsdJChKNrtDWjc3XRP4UcT3rhD8XPQMdb6EtfCVLGT9vJhVkAW8rROvOhZqBxco1sl9-B7kfUq9Hpsc6ilJHL1woe80Qc6HgaSFdLqbL7dfm3na1Dqaa3Slr7TQZ-4HI-7Sv0VGNtY-omsZSrBLLVT6oCy4pW17ZCXuj_1rd8OvLc4YTnXPqPYKGcPZAZO45ztzq-ZnQ847Qouqq6Wfq3lsb-kofKqyXo',
                '1.2k members',
                '4 active',
              ),
              const SizedBox(width: 14),
              // Card 2: Iron Addicts
              _buildTrybeCarouselCard(
                'Iron Addicts',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCDSDs-fQVp21dBe3MMrW6Ur3EzX0PDGP838HkyHaz7Zrh7HS8hel1VfUC0D6n-Y2PLOxLvOjKKuqxwC-2x0vw6PTwS1W4kAP9M8lLzayYaK4Oj5wLDwrOahLzNKTY14RKEkaq5Ui4Xe8SmoTzwpAIuO4CgNvGptmFGnO_zKuW3orKZE7qvZU9URo8zSgpJp7zA5p6-_PGzO8zgnTdtL2dsUbU6Vyv_Hdt2T3f5yNmMJXOiJMrGZIdHgfUt73xX7QUoOr04uusTPMs',
                '842 members',
                '2 active',
              ),
              const SizedBox(width: 14),
              // Card 3: Join New Action Card
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                },
                child: Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: _cardBg.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _accent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.add, color: _accent, size: 24),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'JOIN NEW',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white70,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrybeCarouselCard(String title, String imageUrl, String members, String active) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
      },
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Stack(
            children: [
              // Photo background
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              // Dark gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
              ),
              // Card Details bottom
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
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
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.group_rounded, color: Colors.white38, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          members,
                          style: GoogleFonts.hankenGrotesk(color: Colors.white54, fontSize: 11),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.emoji_events_rounded, color: _accent, size: 13),
                        const SizedBox(width: 4),
                        Text(
                          active,
                          style: GoogleFonts.hankenGrotesk(color: Colors.white54, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocalGroupsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Local Groups',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'SEE ALL',
                style: GoogleFonts.hankenGrotesk(
                  color: _accent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Group 1: Hyde Park Flyers
          _buildLocalGroupRow(
            'Hyde Park Flyers',
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDKbEFetka61Uzn8RD44STxX3QwAz_xcaaMZ-qzvnunUmBoges-xYFwWQTFpXij18kynNXL1kCjJ7eHZrLBexMEquhDjbpT30ThWjuWEdlZaW_ByrqJdvwg18EsATBXBVms3RCoQVOkpH9PeZiVTAQVE1iGclOOB2OwI8EIuMCCTrdCrl7qcAnsjMphuMjE9MqHlVIp1wCbJOr1ql0Bsee3LkdKqgpT6d9PbFZUGm8ojitxqhE6k0tOEM1_5PnJwz9-xYmUS1H2faU',
            '0.8 miles away • 342 members',
          ),
          const SizedBox(height: 10),
          // Group 2: Thames Rowers
          _buildLocalGroupRow(
            'Thames Rowers',
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDTvexSBQGfFmpkWOMvgzqZm1aFP7XCaD_SPLcd41_vKR6WAqg0B-84WFweOFJB36nXS7ClF_esDErfq6uKiciZQjxZzNHHxV7_1F4lxE4iJG-cMz_QJVES9YU4BMZIXj1mlPSkV53vYtOFVuOVpRvGtotbcCggX7HgZtW0Y8NLrbnbrrblkpL2uNwLP4C2yi4wvTMLoZObBTO72l6YUzusCA8T3qHsAk-VKcrm2_FEU1YljfCx3_e-WkZiah1dV3MV2TvfRY7yDjQ',
            '1.2 miles away • 128 members',
          ),
        ],
      ),
    );
  }

  Widget _buildLocalGroupRow(String title, String imageUrl, String stats) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _cardBg.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 52,
                height: 52,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stats,
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: _accent, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildTrybeFeedSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // Feed Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trybe Feed',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1B1E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    _buildFeedTabButton(0, 'Global'),
                    _buildFeedTabButton(1, 'My Trybes'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Post 1: Marcus Chen
          _buildMarcusPostCard(),
          const SizedBox(height: 16),

          // Post 2: Sarah J earned badge
          _buildSarahBadgePostCard(),
        ],
      ),
    );
  }

  Widget _buildFeedTabButton(int index, String title) {
    final bool isActive = index == _activeFeedFilter;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _activeFeedFilter = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF353438) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          title,
          style: GoogleFonts.hankenGrotesk(
            color: isActive ? Colors.white : Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMarcusPostCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2E2E32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accent.withValues(alpha: 0.15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA6WB0sfMAaFfo5F_dwIad6ZGs7ulSBob3FMmrDmhtOJzchQRO1kQ477arp3E_zqR1e2HRU4O9zPR6NulCUQptJRJL0L1KYYDH5oPi92uqu8QsqUw-8xM09asGESGFKFyWIvWKw1Nl41cSnNhPABCmfjR6-XsgdajoAlsmMS8XGD13wiRcs-ayK0jhokb9QShfCCCYpwxgnKyz27HxCLrn5LXsL65kly2HvBKh8-o7-1dMd4-7UWF2HIklx4QomICGvKy6NbcwPmwo',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Marcus Chen',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Elite Runners • 2h ago',
                    style: GoogleFonts.hankenGrotesk(
                      color: _accent,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Colors.white38),
            ],
          ),
          const SizedBox(height: 12),
          // Post body text
          Text(
            "Just smashed the Morning Mist 10k Challenge! The humidity was real but the pace felt consistent. Who's next? 🏃‍♂️💨",
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white70,
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          // Post image container with float badge
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCbSCMsV9KQe-Ufcf5p7oP6YPC-9dbK582RBUf8UbE4q9YxcHM9O6mEB_MAFWpcMWg5Pvup83vzPmGSkp39tH3yZ8FNS39Qvv0I4cb5gpdZyGAxXYnkuETYcg1X5Cc3QxY6Hn-jwGNEdI2rYZ7Sf0dm0KzLb1OBIBYWfc4hOsuxSm69C5EJdo2IdGRIbiE-fSQCRI59DbxJRMIvlvW33lTl2ULjaTsDGytcyap7mAi3u07BjwoSUHEnzM8Rzn8I-DTnlZMsJbEmLvk',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _accent.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.timer_rounded, color: _accent, size: 13),
                          const SizedBox(width: 4),
                          Text(
                            '42:15 total time',
                            style: GoogleFonts.hankenGrotesk(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
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
          const SizedBox(height: 14),
          // Interaction buttons
          Row(
            children: [
              GestureDetector(
                onTap: _toggleMarcusLike,
                child: Row(
                  children: [
                    Icon(
                      _marcusLiked ? Icons.favorite : Icons.favorite_border_rounded,
                      color: _marcusLiked ? Colors.red : Colors.white38,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$_marcusLikesCount',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Row(
                children: [
                  const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white38, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '18',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              const Icon(Icons.share_outlined, color: Colors.white38, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSarahBadgePostCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2E2E32)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _accent.withValues(alpha: 0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accent.withValues(alpha: 0.15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDAP1fzvajosGDCVTnUyqq4353TwT5L9hbdzIAbfVjL23jJvqwjbbg9OEdJD3tgrwrmFKd9QBHpnh_P_TAreUaxMF87aHQGluoDMjKAIMNydXCSFOz7NoDC-C0qQ0PAQytcLv3yf-_Ht2YrCPaoIeHWLOjIWHct32nVuTRlVDle0tfc8u70qmwS3nvQ6yfc3tpX2A_w0nrzZOlzqFt3ArMcMGIp3JUD66upNfTKxZBZ-Dwvs3Mtpy1CCuj2LRYp3YM6QZk5MMqMx2A',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Sarah J. ',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'earned a badge',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white54,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Iron Addicts • 4h ago',
                    style: GoogleFonts.hankenGrotesk(
                      color: _accent,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Badge Sub-card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
            ),
            child: Row(
              children: [
                // Badge Circle Progress Ring
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: 0.8,
                        strokeWidth: 4,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation<Color>(_accent),
                      ),
                    ),
                    Icon(Icons.workspace_premium_rounded, color: _accent, size: 28),
                  ],
                ),
                const SizedBox(width: 16),
                // Badge Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '80% Century Club',
                        style: GoogleFonts.hankenGrotesk(
                          color: _accent,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Completed 80/100 heavy lifting sessions this year. Momentum is building!',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white54,
                          fontSize: 11.5,
                          height: 1.3,
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

  Widget _buildSubTabButton(int index, String label) {
    final bool isActive = _activeSubTab == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _activeSubTab = index;
        });
        widget.onSubTabChanged(index);
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
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsTabSection() {
    final filteredFriends = _friends.where((friend) {
      return (friend['name'] as String)
          .toLowerCase()
          .contains(_friendSearchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          
          // Search Pill
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: _cardBg.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: Colors.white38, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _friendSearchController,
                    onChanged: (val) {
                      setState(() {
                        _friendSearchQuery = val;
                      });
                    },
                    style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search friends...',
                      hintStyle: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (_friendSearchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _friendSearchController.clear();
                        _friendSearchQuery = '';
                      });
                    },
                    child: const Icon(Icons.close_rounded, color: Colors.white54, size: 18),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Friend Request (Pending) Section
          if (_hasPendingRequest) ...[
            _buildSectionHeader('Friend Requests'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Elena Rostova',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'wants to connect',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _hasPendingRequest = false;
                            _friends.insert(0, {
                              'name': 'Elena Rostova',
                              'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
                              'status': 'Active now',
                              'detail': 'Thames Rowers • 2.5 hours active',
                              'isActive': true,
                            });
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _accent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 16),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _hasPendingRequest = false;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2C2C30),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white70, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Active Friends Section
          _buildSectionHeader('All Friends'),
          const SizedBox(height: 12),
          if (filteredFriends.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  'No friends found matching search.',
                  style: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 13),
                ),
              ),
            )
          else
            ...filteredFriends.map((friend) => _buildFriendListRow(friend)),

          const SizedBox(height: 24),

          // Discover Friends Section
          _buildSectionHeader('Discover Athletes'),
          const SizedBox(height: 12),
          _buildDiscoverCard('David K.', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150', 'London, UK • Shared friends'),
          const SizedBox(height: 10),
          _buildDiscoverCard('Emma Watson', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150', 'New York, US • Running enthusiast'),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.hankenGrotesk(
        color: Colors.white60,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildFriendListRow(Map<String, dynamic> friend) {
    final bool isOnline = friend['isActive'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(friend['avatar'] as String),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: _cardBg, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend['name'] as String,
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  friend['status'] as String,
                  style: GoogleFonts.hankenGrotesk(
                    color: isOnline ? _accent : Colors.white38,
                    fontSize: 11.5,
                    fontWeight: isOnline ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  friend['detail'] as String,
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white54,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: _accent,
                      content: Text(
                        'Chat with ${friend['name']} coming soon!',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2C30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white70, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverCard(String name, String avatar, String subtitle) {
    bool hasAdded = false;
    return StatefulBuilder(
      builder: (context, setCardState) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _cardBg.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.02)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(avatar),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setCardState(() {
                    hasAdded = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: _accent,
                      content: Text(
                        'Request sent to $name!',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: hasAdded ? Colors.white10 : _accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasAdded ? Colors.transparent : _accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    hasAdded ? 'Sent' : 'Add',
                    style: GoogleFonts.hankenGrotesk(
                      color: hasAdded ? Colors.white38 : _accent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

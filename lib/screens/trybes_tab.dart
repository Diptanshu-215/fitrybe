import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'chat_detail_screen.dart';
import 'trybe_detail_screen.dart';

class TrybesTab extends StatefulWidget {
  final ValueChanged<int> onSubTabChanged;
  const TrybesTab({super.key, required this.onSubTabChanged});

  @override
  State<TrybesTab> createState() => _TrybesTabState();
}

class _TrybesTabState extends State<TrybesTab> with TickerProviderStateMixin {
  final Color _accent = const Color(0xFFFF5722);
  final Color _cardBg = const Color(0xFF1F1F22);

  // States
  bool _hideMarcusPost = false;
  bool _hideSarahPost = false;
  int _marcusLikesCount = 124;
  bool _marcusLiked = false;
  final List<Map<String, String>> _marcusComments = [
    {'name': 'Marcus Chen', 'text': 'Absolutely smashed it! 🔥', 'time': '1h ago'},
    {'name': 'Elena Forge', 'text': 'Morning Mist is tough, respect!', 'time': '2h ago'},
    {'name': 'David Kim', 'text': 'Those splits look clean 👏', 'time': '3h ago'},
  ];

  int _sarahLikesCount = 42;
  bool _sarahLiked = false;
  final List<Map<String, String>> _sarahComments = [
    {'name': 'Alex Rivera', 'text': '80 sessions is insane! Keep going 💪', 'time': '1h ago'},
    {'name': 'Jordan Lee', 'text': 'Century club loading... 🏋️‍♂️', 'time': '3h ago'},
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

  void _toggleSarahLike() {
    HapticFeedback.lightImpact();
    setState(() {
      _sarahLiked = !_sarahLiked;
      if (_sarahLiked) {
        _sarahLikesCount++;
      } else {
        _sarahLikesCount--;
      }
    });
  }

  int _activeSubTab = 0; // 0: Trybe, 1: Friends
  String _friendSearchQuery = '';
  final TextEditingController _friendSearchController = TextEditingController();
  String _trybeSearchQuery = '';
  final TextEditingController _trybeSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }



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



  @override
  void dispose() {
    _friendSearchController.dispose();
    _trybeSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
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
                    Expanded(child: _buildSubTabItem(0, 'Trybe')),
                    Expanded(child: _buildSubTabItem(1, 'Friends')),
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
          _activeSubTab == 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
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
                                controller: _trybeSearchController,
                                onChanged: (val) {
                                  setState(() {
                                    _trybeSearchQuery = val;
                                  });
                                },
                                style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: 'Search trybes and groups...',
                                  hintStyle: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 14),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                            if (_trybeSearchQuery.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _trybeSearchController.clear();
                                    _trybeSearchQuery = '';
                                  });
                                },
                                child: const Icon(Icons.close_rounded, color: Colors.white54, size: 18),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_trybeSearchQuery.isNotEmpty &&
                        !('Elite Runners'.toLowerCase().contains(_trybeSearchQuery.toLowerCase())) &&
                        !('Iron Addicts'.toLowerCase().contains(_trybeSearchQuery.toLowerCase())) &&
                        !('Hyde Park Flyers'.toLowerCase().contains(_trybeSearchQuery.toLowerCase())) &&
                        !('Thames Rowers'.toLowerCase().contains(_trybeSearchQuery.toLowerCase())) &&
                        !('Marcus Chen'.toLowerCase().contains(_trybeSearchQuery.toLowerCase())) &&
                        !('Sarah J'.toLowerCase().contains(_trybeSearchQuery.toLowerCase())) &&
                        !("Just smashed the Morning Mist 10k Challenge".toLowerCase().contains(_trybeSearchQuery.toLowerCase())))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Center(
                          child: Text(
                            'No trybes, groups, or posts found.',
                            style: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 13),
                          ),
                        ),
                      )
                    else ...[
                      // Section 2: My Trybes Carousel
                      _buildMyTrybesSection(),
                      const SizedBox(height: 24),

                      // Section 3: Local Groups
                      _buildLocalGroupsSection(),
                      const SizedBox(height: 24),

                      // Section 4: Trybe Feed
                      _buildTrybeFeedSection(),
                    ],
                    const SizedBox(height: 100), // Padding for mobile floating navigation
                  ],
                )
              : _buildFriendsTabSection(),
        ],
      ),
    ),
  );
}

  Widget _buildMyTrybesSection() {
    final showEliteRunners = 'Elite Runners'.toLowerCase().contains(_trybeSearchQuery.toLowerCase());
    final showIronAddicts = 'Iron Addicts'.toLowerCase().contains(_trybeSearchQuery.toLowerCase());

    if (!showEliteRunners && !showIronAddicts && _trybeSearchQuery.isNotEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'My Trybes',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
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
              if (showEliteRunners) ...[
                _buildTrybeCarouselCard(
                  'Elite Runners',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDegFaC4Ag757kCG6u-XWSSoEytMNfsVKTDGaGZBHQd6UtsdJChKNrtDWjc3XRP4UcT3rhD8XPQMdb6EtfCVLGT9vJhVkAW8rROvOhZqBxco1sl9-B7kfUq9Hpsc6ilJHL1woe80Qc6HgaSFdLqbL7dfm3na1Dqaa3Slr7TQZ-4HI-7Sv0VGNtY-omsZSrBLLVT6oCy4pW17ZCXuj_1rd8OvLc4YTnXPqPYKGcPZAZO45ztzq-ZnQ847Qouqq6Wfq3lsb-kofKqyXo',
                  '1.2k members',
                  '4 active',
                ),
                const SizedBox(width: 14),
              ],
              if (showIronAddicts) ...[
                _buildTrybeCarouselCard(
                  'Iron Addicts',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCDSDs-fQVp21dBe3MMrW6Ur3EzX0PDGP838HkyHaz7Zrh7HS8hel1VfUC0D6n-Y2PLOxLvOjKKuqxwC-2x0vw6PTwS1W4kAP9M8lLzayYaK4Oj5wLDwrOahLzNKTY14RKEkaq5Ui4Xe8SmoTzwpAIuO4CgNvGptmFGnO_zKuW3orKZE7qvZU9URo8zSgpJp7zA5p6-_PGzO8zgnTdtL2dsUbU6Vyv_Hdt2T3f5yNmMJXOiJMrGZIdHgfUt73xX7QUoOr04uusTPMs',
                  '842 members',
                  '2 active',
                ),
                const SizedBox(width: 14),
              ],
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrybeDetailScreen(
              title: title,
              imageUrl: imageUrl,
              memberCount: members,
            ),
          ),
        );
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
    final showHydePark = 'Hyde Park Flyers'.toLowerCase().contains(_trybeSearchQuery.toLowerCase());
    final showThames = 'Thames Rowers'.toLowerCase().contains(_trybeSearchQuery.toLowerCase());

    if (!showHydePark && !showThames && _trybeSearchQuery.isNotEmpty) {
      return const SizedBox.shrink();
    }

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
              GestureDetector(
                onTap: () => _showAllLocalGroupsModal(context),
                child: Text(
                  'SEE ALL',
                  style: GoogleFonts.hankenGrotesk(
                    color: _accent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (showHydePark) ...[
            _buildLocalGroupRow(
              'Hyde Park Flyers',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDKbEFetka61Uzn8RD44STxX3QwAz_xcaaMZ-qzvnunUmBoges-xYFwWQTFpXij18kynNXL1kCjJ7eHZrLBexMEquhDjbpT30ThWjuWEdlZaW_ByrqJdvwg18EsATBXBVms3RCoQVOkpH9PeZiVTAQVE1iGclOOB2OwI8EIuMCCTrdCrl7qcAnsjMphuMjE9MqHlVIp1wCbJOr1ql0Bsee3LkdKqgpT6d9PbFZUGm8ojitxqhE6k0tOEM1_5PnJwz9-xYmUS1H2faU',
              '0.8 miles away • 342 members',
            ),
            const SizedBox(height: 10),
          ],
          if (showThames) ...[
            _buildLocalGroupRow(
              'Thames Rowers',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDTvexSBQGfFmpkWOMvgzqZm1aFP7XCaD_SPLcd41_vKR6WAqg0B-84WFweOFJB36nXS7ClF_esDErfq6uKiciZQjxZzNHHxV7_1F4lxE4iJG-cMz_QJVES9YU4BMZIXj1mlPSkV53vYtOFVuOVpRvGtotbcCggX7HgZtW0Y8NLrbnbrrblkpL2uNwLP4C2yi4wvTMLoZObBTO72l6YUzusCA8T3qHsAk-VKcrm2_FEU1YljfCx3_e-WkZiah1dV3MV2TvfRY7yDjQ',
              '1.2 miles away • 128 members',
            ),
          ],
        ],
      ),
    );
  }

  void _showAllLocalGroupsModal(BuildContext context) {
    HapticFeedback.mediumImpact();
    final allGroups = [
      {
        'title': 'Hyde Park Flyers',
        'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDKbEFetka61Uzn8RD44STxX3QwAz_xcaaMZ-qzvnunUmBoges-xYFwWQTFpXij18kynNXL1kCjJ7eHZrLBexMEquhDjbpT30ThWjuWEdlZaW_ByrqJdvwg18EsATBXBVms3RCoQVOkpH9PeZiVTAQVE1iGclOOB2OwI8EIuMCCTrdCrl7qcAnsjMphuMjE9MqHlVIp1wCbJOr1ql0Bsee3LkdKqgpT6d9PbFZUGm8ojitxqhE6k0tOEM1_5PnJwz9-xYmUS1H2faU',
        'stats': '0.8 miles away • 342 members',
        'category': 'Running',
      },
      {
        'title': 'Thames Rowers',
        'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDTvexSBQGfFmpkWOMvgzqZm1aFP7XCaD_SPLcd41_vKR6WAqg0B-84WFweOFJB36nXS7ClF_esDErfq6uKiciZQjxZzNHHxV7_1F4lxE4iJG-cMz_QJVES9YU4BMZIXj1mlPSkV53vYtOFVuOVpRvGtotbcCggX7HgZtW0Y8NLrbnbrrblkpL2uNwLP4C2yi4wvTMLoZObBTO72l6YUzusCA8T3qHsAk-VKcrm2_FEU1YljfCx3_e-WkZiah1dV3MV2TvfRY7yDjQ',
        'stats': '1.2 miles away • 128 members',
        'category': 'Rowing',
      },
      {
        'title': 'Soho Calisthenics',
        'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbSCMsV9KQe-Ufcf5p7oP6YPC-9dbK582RBUf8UbE4q9YxcHM9O6mEB_MAFWpcMWg5Pvup83vzPmGSkp39tH3yZ8FNS39Qvv0I4cb5gpdZyGAxXYnkuETYcg1X5Cc3QxY6Hn-jwGNEdI2rYZ7Sf0dm0KzLb1OBIBYWfc4hOsuxSm69C5EJdo2IdGRIbiE-fSQCRI59DbxJRMIvlvW33lTl2ULjaTsDGytcyap7mAi3u07BjwoSUHEnzM8Rzn8I-DTnlZMsJbEmLvk',
        'stats': '1.8 miles away • 215 members',
        'category': 'Bodyweight',
      },
      {
        'title': 'Battersea Park Striders',
        'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA6WB0sfMAaFfo5F_dwIad6ZGs7ulSBob3FMmrDmhtOJzchQRO1kQ477arp3E_zqR1e2HRU4O9zPR6NulCUQptJRJL0L1KYYDH5oPi92uqu8QsqUw-8xM09asGESGFKFyWIvWKw1Nl41cSnNhPABCmfjR6-XsgdajoAlsmMS8XGD13wiRcs-ayK0jhokb9QShfCCCYpwxgnKyz27HxCLrn5LXsL65kly2HvBKh8-o7-1dMd4-7UWF2HIklx4QomICGvKy6NbcwPmwo',
        'stats': '2.4 miles away • 480 members',
        'category': 'Track & Field',
      },
      {
        'title': 'Shoreditch Trail Blazers',
        'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDAP1fzvajosGDCVTnUyqq4353TwT5L9hbdzIAbfVjL23jJvqwjbbg9OEdJD3tgrwrmFKd9QBHpnh_P_TAreUaxMF87aHQGluoDMjKAIMNydXCSFOz7NoDC-C0qQ0PAQytcLv3yf-_Ht2YrCPaoIeHWLOjIWHct32nVuTRlVDle0tfc8u70qmwS3nvQ6yfc3tpX2A_w0nrzZOlzqFt3ArMcMGIp3JUD66upNfTKxZBZ-Dwvs3Mtpy1CCuj2LRYp3YM6QZk5MMqMx2A',
        'stats': '3.1 miles away • 190 members',
        'category': 'Trail Running',
      },
      {
        'title': 'Camden Powerlifting Club',
        'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAHT0fSiT-tBM9-LHbHVlF65CZIgyCqn-DoDUSl05Y0gcWZ5GDqFvUrdutx26mNY5DtnE0ZpijRovfDxUuDLTu5hStbuDoEqMg95eZOlGU7rLLNjJ0EvPXvLs18QfqyMuOb-lgEkqg4Ybw2FlQVeIXwhwd8mUkP3SpCWEUMQnuUuHL2ac9TI_c2sG5wyicbvZ1rz7TuvQ74aVOFymH_WjY3EuexlU6cz0GhX0Kb_z1JbXHSiQhULIuH',
        'stats': '3.8 miles away • 510 members',
        'category': 'Strength',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalCtx) {
        String query = '';
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final filtered = allGroups.where((g) =>
                g['title']!.toLowerCase().contains(query.toLowerCase()) ||
                g['category']!.toLowerCase().contains(query.toLowerCase())).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Local Groups',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(modalCtx),
                        child: const Icon(Icons.close, color: Colors.white54, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Search box inside modal
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: Colors.white38, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (val) {
                              setModalState(() {
                                query = val;
                              });
                            },
                            style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 13.5),
                            decoration: InputDecoration(
                              hintText: 'Search local groups...',
                              hintStyle: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 13.5),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: Colors.white10, height: 1),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, idx) {
                        final grp = filtered[idx];
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(modalCtx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TrybeDetailScreen(
                                  title: grp['title']!,
                                  imageUrl: grp['imageUrl']!,
                                  memberCount: grp['stats']!,
                                  location: 'Local Group • Public',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.network(
                                      grp['imageUrl']!,
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
                                        grp['title']!,
                                        style: GoogleFonts.hankenGrotesk(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.5,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        grp['stats']!,
                                        style: GoogleFonts.hankenGrotesk(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, color: Colors.white38, size: 20),
                              ],
                            ),
                          ),
                        );
                      },
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

  Widget _buildLocalGroupRow(String title, String imageUrl, String stats) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrybeDetailScreen(
              title: title,
              imageUrl: imageUrl,
              memberCount: stats,
              location: 'Local Group • Public',
            ),
          ),
        );
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
    final showMarcus = 'Marcus Chen'.toLowerCase().contains(_trybeSearchQuery.toLowerCase()) ||
        "Just smashed the Morning Mist 10k Challenge".toLowerCase().contains(_trybeSearchQuery.toLowerCase());
    final showSarah = 'Sarah J'.toLowerCase().contains(_trybeSearchQuery.toLowerCase()) ||
        '80% Century Club'.toLowerCase().contains(_trybeSearchQuery.toLowerCase()) ||
        'Completed 80/100 heavy lifting sessions'.toLowerCase().contains(_trybeSearchQuery.toLowerCase());

    if (!showMarcus && !showSarah && _trybeSearchQuery.isNotEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feed Header
          Text(
            'Trybe Feed',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          if (!_hideMarcusPost && showMarcus) ...[
            _buildMarcusPostCard(),
            const SizedBox(height: 16),
          ],

          if (!_hideSarahPost && showSarah) ...[
            _buildSarahBadgePostCard(),
          ],
        ],
      ),
    );
  }

  void _showCommentsSheet(
      BuildContext context, String postAuthor, List<Map<String, String>> commentsList) {
    HapticFeedback.lightImpact();
    final commentCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1B1B1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Comments (${commentsList.length})',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: const Icon(Icons.close, color: Colors.white54, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white10),
                  Expanded(
                    child: commentsList.isEmpty
                        ? Center(
                            child: Text(
                              'No comments yet. Be the first to comment!',
                              style: GoogleFonts.hankenGrotesk(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: commentsList.length,
                            itemBuilder: (ctx, index) {
                              final comment = commentsList[index];
                              return _commentTile(
                                comment['name'] ?? 'User',
                                comment['text'] ?? '',
                                comment['time'] ?? 'Just now',
                              );
                            },
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.white10)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2D),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: TextField(
                              controller: commentCtrl,
                              style: GoogleFonts.hankenGrotesk(
                                  color: Colors.white, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Add a comment for $postAuthor...',
                                hintStyle: GoogleFonts.hankenGrotesk(
                                    color: Colors.white38, fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            final text = commentCtrl.text.trim();
                            if (text.isNotEmpty) {
                              HapticFeedback.mediumImpact();
                              setState(() {
                                commentsList.add({
                                  'name': 'You',
                                  'text': text,
                                  'time': 'Just now',
                                });
                              });
                              setSheetState(() {});
                              commentCtrl.clear();
                            }
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _accent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.send_rounded,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPostOptionsSheet(
      BuildContext context, String postAuthor, {required VoidCallback onHide}) {
    HapticFeedback.mediumImpact();
    bool isSaved = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B1B1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Post Options',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isSaved ? _accent : Colors.white70,
                      size: 22,
                    ),
                    title: Text(
                      isSaved ? 'Remove from Saved' : 'Save Post',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setSheetState(() {
                        isSaved = !isSaved;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isSaved
                                ? 'Post saved to your bookmarks!'
                                : 'Post removed from saved',
                            style: GoogleFonts.hankenGrotesk(
                                color: Colors.white),
                          ),
                          backgroundColor: _accent,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                      Navigator.pop(ctx);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.visibility_off_outlined,
                        color: Colors.white70, size: 22),
                    title: Text(
                      'Hide this post',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
                    subtitle: Text(
                      'See fewer posts like this',
                      style: GoogleFonts.hankenGrotesk(
                          color: Colors.white38, fontSize: 12),
                    ),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(ctx);
                      onHide();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Post hidden from your feed',
                            style: GoogleFonts.hankenGrotesk(
                                color: Colors.white),
                          ),
                          backgroundColor: _accent,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.person_remove_outlined,
                        color: Colors.white70, size: 22),
                    title: Text(
                      'Unfollow $postAuthor',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Unfollowed $postAuthor',
                            style: GoogleFonts.hankenGrotesk(
                                color: Colors.white),
                          ),
                          backgroundColor: _accent,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.flag_outlined,
                        color: Colors.red.shade400, size: 22),
                    title: Text(
                      'Report Post',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(ctx);
                      _showReportReasonDialog(context, postAuthor);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showReportReasonDialog(BuildContext context, String postAuthor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Report $postAuthor\'s Post',
          style: GoogleFonts.hankenGrotesk(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _reportOptionTile(ctx, 'Spam or Misleading'),
            _reportOptionTile(ctx, 'Inappropriate Content'),
            _reportOptionTile(ctx, 'Harassment or Bullying'),
            _reportOptionTile(ctx, 'False Information'),
          ],
        ),
      ),
    );
  }

  Widget _reportOptionTile(BuildContext ctx, String reason) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(reason,
          style: GoogleFonts.hankenGrotesk(color: Colors.white70, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: Colors.white24, size: 20),
      onTap: () {
        Navigator.pop(ctx);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Thank you for reporting. We will review this post.',
              style: GoogleFonts.hankenGrotesk(color: Colors.white),
            ),
            backgroundColor: _accent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
    );
  }

  void _sharePost(String postAuthor, String postText) {
    HapticFeedback.lightImpact();
    SharePlus.instance.share(
      ShareParams(
        text: 'Check out $postAuthor\'s post on FitRybe: "$postText"',
      ),
    );
  }

  Widget _commentTile(String name, String text, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              radius: 16,
              backgroundColor: _accent.withValues(alpha: 0.2),
              child: Icon(Icons.person_rounded, color: _accent, size: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                const SizedBox(height: 2),
                Text(text,
                    style: GoogleFonts.hankenGrotesk(
                        color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          Text(time,
              style: GoogleFonts.hankenGrotesk(
                  color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildMarcusPostCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accent.withValues(alpha: 0.15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA6WB0sfMAaFfo5F_dwIad6ZGs7ulSBob3FMmrDmhtOJzchQRO1kQ477arp3E_zqR1e2HRU4O9zPR6NulCUQptJRJL0L1KYYDH5oPi92uqu8QsqUw-8xM09asGESGFKFyWIvWKw1Nl41cSnNhPABCmfjR6-XsgdajoAlsmMS8XGD13wiRcs-ayK0jhokb9QShfCCCYpwxgnKyz27HxCLrn5LXsL65kly2HvBKh8-o7-1dMd4-7UWF2HIklx4QomICGvKy6NbcwPmwo',
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
                      'Marcus Chen',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '2h ago • Elite Runners',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showPostOptionsSheet(context, 'Marcus Chen',
                    onHide: () => setState(() => _hideMarcusPost = true)),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.more_horiz, color: Colors.white54),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Post body text
          Text(
            "Just smashed the Morning Mist 10k Challenge! The humidity was real but the pace felt consistent. Who's next? 🏃‍♂️💨",
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          // Post image container with float badge
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 180,
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
          const SizedBox(height: 16),
          // Interaction buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _AnimatedLikeButton(
                    isLiked: _marcusLiked,
                    count: _marcusLikesCount,
                    onTap: _toggleMarcusLike,
                  ),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: () => _showCommentsSheet(
                        context, 'Marcus Chen', _marcusComments),
                    child: Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded,
                            color: Colors.white60, size: 19),
                        const SizedBox(width: 8),
                        Text(
                          '${_marcusComments.length}',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.share_outlined,
                  color: Colors.white60,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _sharePost('Marcus Chen',
                    "Just smashed the Morning Mist 10k Challenge!"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSarahBadgePostCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accent.withValues(alpha: 0.15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDAP1fzvajosGDCVTnUyqq4353TwT5L9hbdzIAbfVjL23jJvqwjbbg9OEdJD3tgrwrmFKd9QBHpnh_P_TAreUaxMF87aHQGluoDMjKAIMNydXCSFOz7NoDC-C0qQ0PAQytcLv3yf-_Ht2YrCPaoIeHWLOjIWHct32nVuTRlVDle0tfc8u70qmwS3nvQ6yfc3tpX2A_w0nrzZOlzqFt3ArMcMGIp3JUD66upNfTKxZBZ-Dwvs3Mtpy1CCuj2LRYp3YM6QZk5MMqMx2A',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Sarah J. ',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'earned a badge',
                            style: GoogleFonts.hankenGrotesk(
                              color: Colors.white54,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '4h ago • Iron Addicts',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showPostOptionsSheet(context, 'Sarah J.',
                    onHide: () => setState(() => _hideSarahPost = true)),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.more_horiz, color: Colors.white54),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Badge Sub-card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B1E),
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
          const SizedBox(height: 16),
          // Interaction buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _AnimatedLikeButton(
                    isLiked: _sarahLiked,
                    count: _sarahLikesCount,
                    onTap: _toggleSarahLike,
                  ),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: () =>
                        _showCommentsSheet(context, 'Sarah J.', _sarahComments),
                    child: Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded,
                            color: Colors.white60, size: 19),
                        const SizedBox(width: 8),
                        Text(
                          '${_sarahComments.length}',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined,
                    color: Colors.white60, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _sharePost('Sarah J.',
                    'Earned 80% Century Club badge on FitRybe!'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubTabItem(int index, String label) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Squad & Friends',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '4 Active Now',
                  style: GoogleFonts.hankenGrotesk(
                    color: _accent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Friends Bar
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: _cardBg.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white38, size: 20),
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
                      hintText: 'Search friends by name or trybe...',
                      hintStyle: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 13),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (_friendSearchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _friendSearchController.clear();
                      setState(() {
                        _friendSearchQuery = '';
                      });
                    },
                    child: const Icon(Icons.close, color: Colors.white54, size: 18),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailScreen(
                        chatId: 'friend_${friend['name']}',
                        name: friend['name'],
                        avatar: friend['avatar'],
                        isOnline: friend['isOnline'] ?? true,
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
                        'Now following $name!',
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
                    hasAdded ? 'Following' : 'Follow',
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

class _AnimatedLikeButton extends StatefulWidget {
  final bool isLiked;
  final int count;
  final VoidCallback onTap;

  const _AnimatedLikeButton({
    required this.isLiked,
    required this.count,
    required this.onTap,
  });

  @override
  State<_AnimatedLikeButton> createState() => _AnimatedLikeButtonState();
}

class _AnimatedLikeButtonState extends State<_AnimatedLikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.45), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.45, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFFF5722);
    return GestureDetector(
      onTap: _handleTap,
      child: Row(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              widget.isLiked
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
              color: widget.isLiked ? accentColor : Colors.white60,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: Text(
              '${widget.count} Likes',
              key: ValueKey(widget.count),
              style: GoogleFonts.hankenGrotesk(
                color: widget.isLiked ? accentColor : Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

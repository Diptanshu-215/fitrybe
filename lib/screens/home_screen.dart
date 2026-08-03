import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'activity_analytics_tab.dart';
import 'customize_goal_screen.dart';
import 'record_screen.dart';
import 'trybes_tab.dart';
import 'clique_tab.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  int _activeTrybesSubTab = 0; // 0: Trybe, 1: Friends
  final Color _accent = const Color(0xFFFF5722);
  final Color _cardBg = const Color(0xFF1F1F22);
  final Color _bg = const Color(0xFF131316);

  // Profile URLs matching user request
  final String _userProfileUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAPJac6Lb0URSnKqe4BbcHLk5uXFWLHQZCaDxtPDbNcJG_WyveOuZcmItV-X1bAWs2r2SBhrToJBxv27J6iYYZTV_pAzkKXlGCBB8u3-qytLDB_DTKxbkFyndjRnIdaHGmOZDtEayjCDy3BEXN1Ad-nboUOj_gnYDNp0yUksh9RxOAisSoP4YHXG3Om6YME_BEeiTnOrBvR5x-XexZt6EEN9hfe4g-_zL6ocewUJMszV7fD_M9Ceq15L3UqR6kmDROZ2LGyKxR4BcQ';

  final String _marcusProfileUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBgjRSNIhjmFhRP_8S3tuvi1UgLC68VGmAkh42cOH9VQliTiy7tCc6SthMMHXDQA4u5KVBjJbgUpMGDWngdIa0napfGh8KuaI2R7Vg5APFj_FuEPtSycFIZ0S48-A0mTSDF9pEM1B68-1eG3zJonxwSmwvmtIGw9-09xvJbXE20Bc3pv4KvyqQJNn1emw8tMbAY9KUjxJD_Lmjaw4Duenm3KPou27843mgzy-OF2cdC5p_ej4RvuGJAVUmHusIFbL2nb5sunZYAAqE';

  final String _runPhotoUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDZEtQZ2pORiFgwS8V2nQO0E69YkI0Oqooc8KhFjmnTDLcYvyoMxeLVRixFQd9a_BBq9BG9nvLci8oAL92pScug74S9dIcF6fIRW_uznf2ED1ss6gtmVCpajslV1W_mEgVJh1D8_eaA_XdbpOEMbhFcQCVGihiYEC7dPpHMOjGWwHCmHkoW-cWIo84ku68eXpJYrAqDMoAjPaFHk6bpwduHgxoRYNvB-mMS4bFDxEbb2Qkf7hSAlA5mWF6P3WQVed2wLfpN7uSNFAg';

  final String _gujProfileUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBWx5umQiyz5zTsO2R59sz6-ZJBoCs_nZs85WNJFvHFAXTu2QdPMQAnLFwnsOjJEqaKcAdcpv9qPq6NQlJV7p3SyDX5EIVrn0bEU9-AP4_8x_xEUVHdOiDAP3wLWp-IHQa66Tlzzu2-LDvsB2lxqL53shYINDqc8cVbqVZ_A5LMSmdfU-nToulwi9Fj81mCD9UTzqkJlubLx5AcUiLKC8JqNPOE2QnZ7YAtQXOmHziYWkiMpbPMGmnYNiBMEoC970DEuzYd659rK9k';

  final String _grxtvtbProfileUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD5xXoM82GHJSQNSl-JXZOu5g-UWak_YAKKVH81A7Pf5_ExAZcNb5DbW8GCumWsV-zMwHv3df74Lwq1T84Rv4lBZWo542IXaSkyYwXzvb8k8g_JPrPu1T53bWgYiW-AyaVdApEQgzXSpD478-4u-5NEbhYkbWboLJOGYNrPueRMJMQgJCb2G1RrKuTkG2RDaTaD4CU8k1_BBvmnX26awaaSmU5ageWKNr-9UQ_Joyp8XDp3nuGlhp_AMJzgltoEIZ4Cp2JFHzHIqug';

  final String _elenaProfileUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDCQQabYLTohBmurAKr1RUN2IAmRiPuGsqFmInWzHEf__Aq8Lrup0DEecMWshiQqtOB1HAs-8fkX6PyMCEda_L3qGqU0Hd3pZ6C2Y99UPYmQjEvRzMX1Ola5UWClM-T51g-lXpPghN0dwlp7dEba8xTJJu76POnA9jCcIucHyiHs382ck93N92xzFSCg5Ed3_FxMZ4LfiX1hUbWrKGISFRwSRvCzC5BrI0mY3Ul_Hg9WbhgXrTKTFZULhLCg3sEkwFHYGol8j0dPoc';

  // State to simulate Kudos interactions
  int _marcusKudos = 124;
  bool _marcusKudosed = false;
  int _elenaKudos = 42;
  bool _elenaKudosed = false;

  final Set<String> _followedUsers = {};

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg.withValues(alpha: 0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: _isSearching
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search, color: Colors.white54, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        autofocus: true,
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search activities, trybes...',
                          hintStyle: GoogleFonts.hankenGrotesk(
                            color: Colors.white38,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white54,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _isSearching = false;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  // Left: Logo
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/fitrybe-mark.svg',
                          height: 22,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFFF5722),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        SvgPicture.asset(
                          'assets/images/fitrybe-wordmark-white.svg',
                          height: 14,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center: Record button
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecordScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFFF5722,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(
                              0xFFFF5722,
                            ).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.fiber_manual_record,
                              color: Color(0xFFFF5722),
                              size: 12,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Record',
                              style: GoogleFonts.hankenGrotesk(
                                color: const Color(0xFFFF5722),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Right: Search + Message (Inbox) + User Profile (Rightmost)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSearching = true;
                            });
                          },
                          child: const Icon(
                            Icons.search,
                            color: Colors.white70,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.mail_outline_rounded,
                            color: Colors.white70,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(_userProfileUrl),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      body: _buildCurrentTab(),
      floatingActionButton: _currentNavIndex == 2
          ? SizedBox(
              height: 48,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomizeGoalScreen(),
                    ),
                  );
                },
                backgroundColor: _accent,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                icon: const Icon(Icons.track_changes_rounded, size: 20),
                label: Text(
                  'Customize Goals',
                  style: GoogleFonts.hankenGrotesk(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ),
            )
          : _currentNavIndex == 1
              ? (_activeTrybesSubTab == 0
                  ? SizedBox(
                      height: 48,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: _accent,
                              content: Text(
                                'Create Trybe coming soon!',
                                style: GoogleFonts.hankenGrotesk(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                        backgroundColor: _accent,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        icon: const Icon(Icons.group_add_rounded, size: 20),
                        label: Text(
                          'Create Trybe',
                          style: GoogleFonts.hankenGrotesk(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    )
                  : null)
              : _currentNavIndex == 3
                  ? null
                  : FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 6,
                      child: const Icon(Icons.add, size: 28),
                    ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentNavIndex) {
      case 0:
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWeeklyStats(),
              _buildRunActivityPost(),
              _buildGrowYourTrybeSection(),
              _buildStrengthActivityPost(),
              const SizedBox(height: 100), // Bottom padding for FAB and Nav
            ],
          ),
        );
      case 2:
        return const ActivityAnalyticsTab();
      case 1:
        return TrybesTab(
          onSubTabChanged: (subIdx) {
            setState(() {
              _activeTrybesSubTab = subIdx;
            });
          },
        );
      case 3:
        return const CliqueTab();
      case 4:
        return _buildPlaceholderTab(
          'Notification',
          Icons.notifications_rounded,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPlaceholderTab(String tabName, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _accent.withValues(alpha: 0.3), size: 80),
            const SizedBox(height: 16),
            Text(
              tabName,
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore $tabName statistics, metrics, and clique discussions coming soon.',
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white54,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyStats() {
    return Container(
      color: const Color(0xFF1B1B1E).withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WEEKLY PROGRESS',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'Details',
                style: GoogleFonts.hankenGrotesk(
                  color: _accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatsCard('Activities', '4', '')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatsCard('Distance', '12.4', ' km')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatsCard('Time', '2.5', ' h')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String label, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
              children: [
                TextSpan(text: value),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: unit,
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 12,
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

  Widget _buildRunActivityPost() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(_marcusProfileUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Marcus Vane',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '2h ago • Morning Run',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, color: Colors.white54),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Title & Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COASTAL RIDGE PR 🔥',
                  style: GoogleFonts.anybody(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pushed through the drizzle this morning. The coastal trail never disappoints. Record broken on the 5k segment!',
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Activity Image & Overlay Stats
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(_runPhotoUrl, fit: BoxFit.cover),
                ),
                // Gradient Bottom Overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                // Stat Badges
                Positioned(
                  bottom: 24,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DISTANCE',
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 9,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '8.2 km',
                              style: GoogleFonts.anybody(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PACE',
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 9,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '4:32 /km',
                              style: GoogleFonts.anybody(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Map Icon
                Positioned(
                  bottom: 24,
                  right: 20,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: _accent,
                    child: const Icon(Icons.map, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Interaction Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _marcusKudosed = !_marcusKudosed;
                          if (_marcusKudosed) {
                            _marcusKudos++;
                          } else {
                            _marcusKudos--;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_up_rounded,
                            color: _marcusKudosed ? _accent : Colors.white60,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_marcusKudos Likes',
                            style: GoogleFonts.hankenGrotesk(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.white60,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '18',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.share_outlined,
                    color: Colors.white60,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowYourTrybeSection() {
    return Container(
      color: const Color(0xFF1B1B1E).withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grow your trybe',
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.arrow_forward, color: _accent, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildRecommendationCard(
                  'Gu J',
                  'Patna, Bihar',
                  _gujProfileUrl,
                ),
                const SizedBox(width: 14),
                _buildRecommendationCard(
                  'Grxtvtb Y',
                  'Patna, Bihar',
                  _grxtvtbProfileUrl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(String name, String location, String imgUrl) {
    final isFollowing = _followedUsers.contains(name);
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 28, backgroundImage: NetworkImage(imgUrl)),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            location.toUpperCase(),
            style: GoogleFonts.hankenGrotesk(
              color: Colors.white38,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  if (isFollowing) {
                    _followedUsers.remove(name);
                  } else {
                    _followedUsers.add(name);
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isFollowing ? Colors.white12 : _accent,
                foregroundColor: isFollowing ? Colors.white : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.zero,
                elevation: 0,
              ),
              child: Text(
                isFollowing ? 'Following' : 'Follow',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthActivityPost() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(_elenaProfileUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Elena Forge',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '5h ago • Powerlifting',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, color: Colors.white54),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HIGH VOLUME MONDAY',
                  style: GoogleFonts.anybody(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _cardBg,
                          borderRadius: BorderRadius.circular(16),
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
                                child: Container(color: _accent),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'VOLUME',
                                      style: GoogleFonts.hankenGrotesk(
                                        color: Colors.white54,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    RichText(
                                      text: TextSpan(
                                        style: GoogleFonts.anybody(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          const TextSpan(text: '8,420'),
                                          TextSpan(
                                            text: ' kg',
                                            style: GoogleFonts.hankenGrotesk(
                                              fontSize: 12,
                                              color: Colors.white60,
                                              fontWeight: FontWeight.normal,
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
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _cardBg,
                          borderRadius: BorderRadius.circular(16),
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
                                child: Container(color: _accent),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'TIME',
                                      style: GoogleFonts.hankenGrotesk(
                                        color: Colors.white54,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '1h 12m',
                                      style: GoogleFonts.anybody(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
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
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Interaction Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _elenaKudosed = !_elenaKudosed;
                          if (_elenaKudosed) {
                            _elenaKudos++;
                          } else {
                            _elenaKudos--;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_up_rounded,
                            color: _elenaKudosed ? _accent : Colors.white60,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_elenaKudos Likes',
                            style: GoogleFonts.hankenGrotesk(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.white60,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '5',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.share_outlined,
                    color: Colors.white60,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131316).withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, 'Home'),
          _buildNavItem(1, Icons.group_rounded, 'Trybes'),
          _buildNavItem(2, Icons.directions_run_rounded, 'Activity'),
          _buildNavItem(3, Icons.monitor_heart_rounded, 'Clique'),
          _buildNavItem(4, Icons.notifications_rounded, 'Notification'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final active = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _currentNavIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? _accent : Colors.white54, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.hankenGrotesk(
              color: active ? _accent : Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

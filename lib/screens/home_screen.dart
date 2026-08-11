import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'activity_analytics_tab.dart';
import 'record_screen.dart';
import 'trybes_tab.dart';
import 'clique_tab.dart';
import 'profile_tab.dart';
import 'notifications_tab.dart';
import 'create_post_screen.dart';
import 'create_trybe_screen.dart';
import 'create_clique_activity_screen.dart';
import 'customize_goal_screen.dart';
import 'subscription_screen.dart';
import 'messaging_screen.dart';
import '../models/post_store.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  int _activeTrybesSubTab = 0; // 0: Trybe, 1: Friends
  int _activeCliqueSubTab = 0; // 0: Activity, 1: Challenges, 2: Synergy
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

  bool _marcusMuted = false;
  bool _elenaMuted = false;
  bool _marcusPostHidden = false;
  bool _elenaPostHidden = false;
  final Set<String> _hiddenUserPostIds = {};

  final Map<String, List<Map<String, String>>> _postComments = {
    'marcus_post_1': [
      {
        'author': 'Sarah Jenkins',
        'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDZEtQZ2pORiFgwS8V2nQO0E69YkI0Oqooc8KhFjmnTDLcYvyoMxeLVRixFQd9a_BBq9BG9nvLci8oAL92pScug74S9dIcF6fIRW_uznf2ED1ss6gtmVCpajslV1W_mEgVJh1D8_eaA_XdbpOEMbhFcQCVGihiYEC7dPpHMOjGWwHCmHkoW-cWIo84ku68eXpJYrAqDMoAjPaFHk6bpwduHgxoRYNvB-mMS4bFDxEbb2Qkf7hSAlA5mWF6P3WQVed2wLfpN7uSNFAg',
        'text': 'Insane pace Marcus! Let\'s run together next week.',
        'time': '1h ago',
      },
      {
        'author': 'David Kim',
        'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDKbEFetka61Uzn8RD44STxX3QwAz_xcaaMZ-qzvnunUmBoges-xYFwWQTFpXij18kynNXL1kCjJ7eHZrLBexMEquhDjbpT30ThWjuWEdlZaW_ByrqJdvwg18EsATBXBVms3RCoQVOkpH9PeZiVTAQVE1iGclOOB2OwI8EIuMCCTrdCrl7qcAnsjMphuMjE9MqHlVIp1wCbJOr1ql0Bsee3LkdKqgpT6d9PbFZUGm8ojitxqhE6k0tOEM1_5PnJwz9-xYmUS1H2faU',
        'text': 'Congrats on the PR! 🔥',
        'time': '30m ago',
      },
    ],
    'elena_post_1': [
      {
        'author': 'Marcus Vane',
        'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBgjRSNIhjmFhRP_8S3tuvi1UgLC68VGmAkh42cOH9VQliTiy7tCc6SthMMHXDQA4u5KVBjJbgUpMGDWngdIa0napfGh8KuaI2R7Vg5APFj_FuEPtSycFIZ0S48-A0mTSDF9pEM1B68-1eG3zJonxwSmwvmtIGw9-09xvJbXE20Bc3pv4KvyqQJNn1emw8tMbAY9KUjxJD_Lmjaw4Duenm3KPou27843mgzy-OF2cdC5p_ej4RvuGJAVUmHusIFbL2nb5sunZYAAqE',
        'text': 'Strong lifts Elena! That bench is crazy.',
        'time': '4h ago',
      },
    ],
  };

  final Map<String, int> _userPostLikes = {};
  final Set<String> _likedUserPostIds = {};

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
    final bool isSynergyOrbit = _currentNavIndex == 3 && _activeCliqueSubTab == 2;
    final String tabTitle = const ['Home', 'Trybes', 'Activity', 'Clique', 'Notification'][_currentNavIndex];
    return Scaffold(
      backgroundColor: isSynergyOrbit ? Colors.black : _bg,
      appBar: AppBar(
        backgroundColor: isSynergyOrbit
            ? Colors.black
            : _bg.withValues(alpha: 0.9),
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
                  // Left: Logo + Tab title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/fitrybe-mark.svg',
                          height: 28,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFFF5722),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          tabTitle,
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center: Record button
                  if (_currentNavIndex == 0)
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RecordScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5722).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFFF5722).withValues(alpha: 0.25),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Symbols.circle_rounded,
                                color: Color(0xFFFF5722),
                                size: 10,
                                fill: 1.0,
                                weight: 700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'RECORD',
                                style: GoogleFonts.hankenGrotesk(
                                  color: const Color(0xFFFF5722),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
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
                        if (_currentNavIndex == 0) ...[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSearching = true;
                              });
                            },
                            child: SvgPicture.string(
                              '''<svg xmlns="http://www.w3.org/2000/svg" width="104" height="100" viewBox="0 0 104 100">
                                <defs>
                                  <mask id="search-cutout">
                                    <rect width="104" height="100" fill="white" />
                                    <circle cx="44" cy="40" r="20" fill="black" />
                                  </mask>
                                </defs>
                                <g fill="currentColor" stroke="currentColor" mask="url(#search-cutout)">
                                  <path d="M60 56 L92 88" stroke-width="20" stroke-linecap="round" fill="none"/>
                                  <circle cx="44" cy="40" r="34" stroke="none" fill="currentColor"/>
                                </g>
                              </svg>''',
                              height: 22,
                              colorFilter: const ColorFilter.mode(
                                Colors.white70,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MessagingScreen(),
                              ),
                            );
                          },
                          child: SvgPicture.string(
                            '''<svg xmlns="http://www.w3.org/2000/svg" width="120" height="88" viewBox="0 0 120 88">
                              <defs>
                                <mask id="cutout">
                                  <rect width="120" height="88" fill="white" />
                                  <rect x="36" y="24" width="48" height="12" rx="6" fill="black" />
                                  <rect x="36" y="42" width="32" height="12" rx="6" fill="black" />
                                </mask>
                              </defs>
                              <g fill="currentColor" mask="url(#cutout)">
                                <ellipse cx="60" cy="40" rx="42" ry="33"/>
                                <path d="M24 56 L17 68 Q14 73 20 73 L60 73 Z"/>
                              </g>
                            </svg>''',
                            height: 22,
                            colorFilter: const ColorFilter.mode(
                              Colors.white70,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  backgroundColor: const Color(0xFF131316),
                                  appBar: AppBar(
                                    backgroundColor: const Color(0xFF131316),
                                    elevation: 0,
                                    scrolledUnderElevation: 0,
                                    leading: IconButton(
                                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    title: Text(
                                      'Profile',
                                      style: GoogleFonts.anybody(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    actions: [
                                      IconButton(
                                        icon: const Icon(Icons.settings_outlined, color: Colors.white),
                                        onPressed: () {
                                          HapticFeedback.lightImpact();
                                          _showSettingsBottomSheet(context);
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                  body: const SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: ProfileTab(),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 14,
                            backgroundImage: NetworkImage(_userProfileUrl),
                          ),
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
                  HapticFeedback.lightImpact();
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
                icon: const Icon(
                  Symbols.track_changes_rounded,
                  size: 24,
                  weight: 800,
                  grade: 200,
                ),
                label: Text(
                  'Customize Goal',
                  style: GoogleFonts.hankenGrotesk(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ),
            )
          : _currentNavIndex == 3
              ? SizedBox(
                  height: 48,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CreateCliqueActivityScreen(),
                        ),
                      );
                    },
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    icon: const Icon(
                      Symbols.add_rounded,
                      size: 26,
                      weight: 900,
                      grade: 200,
                    ),
                    label: Text(
                      'Create Activity',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateTrybeScreen(),
                            ),
                          );
                        },
                        backgroundColor: _accent,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        icon: const Icon(
                          Symbols.group_add_rounded,
                          size: 20,
                          fill: 1.0,
                          weight: 700,
                          grade: 200,
                          opticalSize: 24,
                        ),
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
              : _currentNavIndex == 4
                  ? null
                  : FloatingActionButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreatePostScreen(),
                          ),
                        );
                      },
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 6,
                      child: const Icon(
                        Symbols.add_rounded,
                        size: 28,
                        fill: 1.0,
                        weight: 700,
                        grade: 200,
                        opticalSize: 24,
                      ),
                    ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }



  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF131316),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF131316),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
              ),
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
                  const SizedBox(height: 24),
                  Text(
                    'Settings',
                    style: GoogleFonts.anybody(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsItem(
                    Icons.stars_rounded,
                    'Trybe Pro Premium',
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SubscriptionScreen(),
                        ),
                      );
                    },
                    color: _accent,
                  ),
                  _buildSettingsItem(
                    Icons.person_outline_rounded,
                    'Account Settings',
                    () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildSettingsItem(
                    Icons.notifications_none_rounded,
                    'Notifications',
                    () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildSettingsItem(
                    Icons.privacy_tip_outlined,
                    'Privacy & Sharing',
                    () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildSettingsItem(
                    Icons.help_outline_rounded,
                    'Help & Support',
                    () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(color: Colors.white10, height: 24),
                  _buildSettingsItem(
                    Icons.logout_rounded,
                    'Log Out',
                    () {
                      Navigator.pop(context);
                    },
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap, {Color color = Colors.white70}) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        title,
        style: GoogleFonts.hankenGrotesk(
          color: color,
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 18),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentNavIndex) {
      case 0:
        return ListenableBuilder(
          listenable: PostStore.instance,
          builder: (context, _) {
            final userPosts = PostStore.instance.posts.where((p) => !_hiddenUserPostIds.contains(p.id)).toList();
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeeklyStats(),
                  ...userPosts.map((post) => _buildDynamicUserPost(post)),
                  if (!_marcusMuted && !_marcusPostHidden) _buildRunActivityPost(),
                  _buildGrowYourTrybeSection(),
                  if (!_elenaMuted && !_elenaPostHidden) _buildStrengthActivityPost(),
                  const SizedBox(height: 100), // Bottom padding for FAB and Nav
                ],
              ),
            );
          },
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
        return CliqueTab(
          onSubTabChanged: (subIdx) {
            setState(() {
              _activeCliqueSubTab = subIdx;
            });
          },
        );
      case 4:
        return const NotificationsTab();
      default:
        return const SizedBox.shrink();
    }
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
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _currentNavIndex = 2;
                  });
                },
                child: Text(
                  'Details',
                  style: GoogleFonts.hankenGrotesk(
                    color: _accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
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

  int _getCommentCount(String postId) {
    return _postComments[postId]?.length ?? 0;
  }

  void _showCommentsBottomSheet(BuildContext context, String postId) {
    final textController = TextEditingController();
    final scrollController = ScrollController();
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF131316),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final comments = _postComments[postId] ?? [];
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Comments (${comments.length})',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close_rounded, color: Colors.white54, size: 20),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white10),
                  Expanded(
                    child: comments.isEmpty
                        ? Center(
                            child: Text(
                              'No comments yet. Be the first to comment!',
                              style: GoogleFonts.hankenGrotesk(color: Colors.white30, fontSize: 13),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundImage: NetworkImage(comment['avatar'] ?? _userProfileUrl),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                comment['author'] ?? 'User',
                                                style: GoogleFonts.hankenGrotesk(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.5,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                comment['time'] ?? 'Just now',
                                                style: GoogleFonts.hankenGrotesk(
                                                  color: Colors.white30,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            comment['text'] ?? '',
                                            style: GoogleFonts.hankenGrotesk(
                                              color: Colors.white70,
                                              fontSize: 13,
                                              height: 1.35,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xFF131316),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(_userProfileUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(21),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: textController,
                                    style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: 'Add a comment...',
                                      hintStyle: GoogleFonts.hankenGrotesk(color: Colors.white30, fontSize: 13),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    final text = textController.text.trim();
                                    if (text.isEmpty) return;
                                    HapticFeedback.lightImpact();
                                    final newComment = {
                                      'author': 'Alex Thorne',
                                      'avatar': _userProfileUrl,
                                      'text': text,
                                      'time': 'Just now',
                                    };
                                    setState(() {
                                      if (_postComments[postId] == null) {
                                        _postComments[postId] = [];
                                      }
                                      _postComments[postId]!.add(newComment);
                                    });
                                    setSheetState(() {});
                                    textController.clear();
                                    Timer(const Duration(milliseconds: 100), () {
                                      if (scrollController.hasClients) {
                                        scrollController.animateTo(
                                          scrollController.position.maxScrollExtent,
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeOut,
                                        );
                                      }
                                    });
                                  },
                                  child: Icon(Icons.send_rounded, color: _accent, size: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
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


  void _showPostOptions({
    required BuildContext context,
    required bool isOwnPost,
    required String postId,
    required String authorName,
    required VoidCallback onHide,
  }) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF131316),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                if (isOwnPost) ...[
                  ListTile(
                    leading: const Icon(Icons.edit_outlined, color: Colors.white70),
                    title: Text('Edit Post', style: GoogleFonts.hankenGrotesk(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      _showEditPostDialog(postId);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    title: Text('Delete Post', style: GoogleFonts.hankenGrotesk(color: Colors.redAccent)),
                    onTap: () {
                      Navigator.pop(context);
                      PostStore.instance.removePost(postId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: _accent,
                          content: Text('Post deleted.', style: GoogleFonts.hankenGrotesk(color: Colors.white)),
                        ),
                      );
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: const Icon(Icons.report_gmailerrorred_rounded, color: Colors.redAccent),
                    title: Text('Report Post', style: GoogleFonts.hankenGrotesk(color: Colors.redAccent)),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: _accent,
                          content: Text('Thank you. Post reported.', style: GoogleFonts.hankenGrotesk(color: Colors.white)),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.volume_off_rounded, color: Colors.white70),
                    title: Text('Mute $authorName', style: GoogleFonts.hankenGrotesk(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        if (authorName == 'Marcus Vane') _marcusMuted = true;
                        if (authorName == 'Elena Forge') _elenaMuted = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: _accent,
                          content: Text('You won\'t see posts from $authorName.', style: GoogleFonts.hankenGrotesk(color: Colors.white)),
                        ),
                      );
                    },
                  ),
                ],
                ListTile(
                  leading: const Icon(Icons.link_rounded, color: Colors.white70),
                  title: Text('Copy Link', style: GoogleFonts.hankenGrotesk(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    Clipboard.setData(const ClipboardData(text: 'https://fitrybe.com/posts/1'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: _accent,
                        content: Text('Link copied to clipboard.', style: GoogleFonts.hankenGrotesk(color: Colors.white)),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.visibility_off_outlined, color: Colors.white70),
                  title: Text('Hide Post', style: GoogleFonts.hankenGrotesk(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    onHide();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: _accent,
                        content: Text('Post hidden.', style: GoogleFonts.hankenGrotesk(color: Colors.white)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditPostDialog(String postId) {
    final posts = PostStore.instance.posts;
    final post = posts.firstWhere((p) => p.id == postId);
    final controller = TextEditingController(text: post.caption);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E22),
          title: Text(
            'Edit Post',
            style: GoogleFonts.hankenGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: TextField(
            controller: controller,
            maxLines: 4,
            style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Edit your post...',
              hintStyle: GoogleFonts.hankenGrotesk(color: Colors.white38),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _accent),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.hankenGrotesk(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                final newCaption = controller.text.trim();
                if (newCaption.isNotEmpty) {
                  PostStore.instance.removePost(postId);
                  PostStore.instance.addPost(
                    UserPost(
                      id: postId,
                      caption: newCaption,
                      type: post.type,
                      audience: post.audience,
                      locationTag: post.locationTag,
                      imagePaths: post.imagePaths,
                      createdAt: post.createdAt,
                    ),
                  );
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: _accent),
              child: Text('Save', style: GoogleFonts.hankenGrotesk(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDynamicUserPost(UserPost post) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(_userProfileUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alex Thorne',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Just now • ${post.type}',
                        style: GoogleFonts.hankenGrotesk(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white54),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    _showPostOptions(
                      context: context,
                      isOwnPost: true,
                      postId: post.id,
                      authorName: 'Alex Thorne',
                      onHide: () {
                        setState(() {
                          _hiddenUserPostIds.add(post.id);
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              post.caption,
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white.withValues(alpha: 0.87),
                fontSize: 14.5,
                height: 1.45,
              ),
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
                          if (_likedUserPostIds.contains(post.id)) {
                            _likedUserPostIds.remove(post.id);
                            _userPostLikes[post.id] = (_userPostLikes[post.id] ?? 1) - 1;
                          } else {
                            _likedUserPostIds.add(post.id);
                            _userPostLikes[post.id] = (_userPostLikes[post.id] ?? 0) + 1;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            _likedUserPostIds.contains(post.id)
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline_rounded,
                            color: _likedUserPostIds.contains(post.id)
                                ? _accent
                                : Colors.white60,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_userPostLikes[post.id] ?? 0} Likes',
                            style: GoogleFonts.hankenGrotesk(
                              color: _likedUserPostIds.contains(post.id)
                                  ? _accent
                                  : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: () => _showCommentsBottomSheet(context, post.id),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Colors.white60,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_getCommentCount(post.id)} Comments',
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
                  onPressed: () => SharePlus.instance.share(ShareParams(text: "Check out my post on FiTrybe! 💪\n\n${post.caption}")),
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
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white54),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    _showPostOptions(
                      context: context,
                      isOwnPost: false,
                      postId: 'marcus_post_1',
                      authorName: 'Marcus Vane',
                      onHide: () {
                        setState(() {
                          _marcusPostHidden = true;
                        });
                      },
                    );
                  },
                ),
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
                            _marcusKudosed
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline_rounded,
                            color: _marcusKudosed ? _accent : Colors.white60,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_marcusKudos Likes',
                            style: GoogleFonts.hankenGrotesk(
                              color: _marcusKudosed ? _accent : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: () => _showCommentsBottomSheet(context, 'marcus_post_1'),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Colors.white60,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_getCommentCount('marcus_post_1')} Comments',
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
                  onPressed: () => SharePlus.instance.share(ShareParams(text: "Check out Marcus Vane's Morning Run 'COASTAL RIDGE PR 🔥' on FiTrybe! 🏃‍♂️\nDistance: 5.2 km\nPace: 4'45\" /km\nTime: 24:39")),
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
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _currentNavIndex = 1;
                });
              },
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
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white54),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    _showPostOptions(
                      context: context,
                      isOwnPost: false,
                      postId: 'elena_post_1',
                      authorName: 'Elena Forge',
                      onHide: () {
                        setState(() {
                          _elenaPostHidden = true;
                        });
                      },
                    );
                  },
                ),
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
                            _elenaKudosed
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline_rounded,
                            color: _elenaKudosed ? _accent : Colors.white60,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_elenaKudos Likes',
                            style: GoogleFonts.hankenGrotesk(
                              color: _elenaKudosed ? _accent : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: () => _showCommentsBottomSheet(context, 'elena_post_1'),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Colors.white60,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_getCommentCount('elena_post_1')} Comments',
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
                  onPressed: () => SharePlus.instance.share(ShareParams(text: "Check out Elena Forge's Powerlifting session 'HIGH VOLUME MONDAY' on FiTrybe! 🏋️‍♀️\nWeight: 14,240 kg\nSets: 24\nTime: 1.2 h")),
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
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      child: Row(
        children: [
          Expanded(child: _buildNavItem(0, Symbols.home_rounded, 'Home')),
          Expanded(child: _buildNavItem(1, Symbols.group_rounded, 'Trybes')),
          Expanded(child: _buildNavItem(2, Symbols.directions_run_rounded, 'Activity')),
          Expanded(child: _buildNavItem(3, Symbols.monitor_heart_rounded, 'Clique')),
          Expanded(child: _buildNavItem(4, Symbols.notifications_rounded, 'Notification')),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final active = _currentNavIndex == index;
    final inactive = Colors.white.withValues(alpha: 0.45);

    return Semantics(
      selected: active,
      button: true,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _currentNavIndex = index);
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              fill: 1.0,
              weight: 700,
              grade: 200,
              opticalSize: 24,
              color: active ? Colors.white : inactive,
            ),
          ],
        ),
      ),
    );
  }

}

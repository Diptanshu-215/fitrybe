import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:share_plus/share_plus.dart';
import 'chat_detail_screen.dart';
import 'create_post_screen.dart';
import '../services/trybe_service.dart';

class TrybeDetailScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String memberCount;
  final String category;
  final String location;
  final bool isJoined;

  const TrybeDetailScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    this.memberCount = '1.2k members',
    this.category = 'Running & Conditioning',
    this.location = 'London, UK • Public',
    this.isJoined = true,
  });

  @override
  State<TrybeDetailScreen> createState() => _TrybeDetailScreenState();
}

class _TrybeDetailScreenState extends State<TrybeDetailScreen>
    with SingleTickerProviderStateMixin {
  final Color _accent = const Color(0xFFFF5722);
  final Color _bg = const Color(0xFF0F0F12);
  final Color _cardBg = const Color(0xFF1B1B1E);

  late bool _isJoined;
  int _activeSubTab = 0; // 0: Feed, 1: Leaderboard, 2: Events, 3: Members

  // Sample Trybe Feed Data
  bool _hidePost1 = false;
  bool _hidePost2 = false;
  bool _post1Liked = false;
  int _post1Likes = 84;
  final List<Map<String, String>> _post1Comments = [
    {'name': 'Marcus Chen', 'text': 'Sub-40 10k squad loading! 🔥', 'time': '1h ago'},
    {'name': 'Elena Forge', 'text': 'See everyone Saturday 6 AM!', 'time': '3h ago'},
  ];

  bool _post2Liked = true;
  int _post2Likes = 142;
  final List<Map<String, String>> _post2Comments = [
    {'name': 'David Kim', 'text': 'Weekly goal smashed 💪', 'time': '2h ago'},
  ];

  // Events RSVP State
  final Map<int, bool> _eventRsvp = {0: true, 1: false};

  @override
  void initState() {
    super.initState();
    _isJoined = widget.isJoined;
  }

  void _toggleJoin() {
    HapticFeedback.heavyImpact();
    final trybeId = widget.title.replaceAll(' ', '_');
    if (!_isJoined) {
      TrybeService().joinTrybe(trybeId);
    } else {
      TrybeService().leaveTrybe(trybeId);
    }
    setState(() {
      _isJoined = !_isJoined;
    });
  }

  void _showTrybeOptionsMenu() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.share_rounded, color: _accent, size: 20),
                ),
                title: Text('Share Trybe', style: GoogleFonts.hankenGrotesk(color: Colors.white, fontWeight: FontWeight.w600)),
                subtitle: Text('Invite friends to join ${widget.title}', style: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 12)),
                onTap: () {
                  Navigator.pop(ctx);
                  SharePlus.instance.share(
                    ShareParams(text: 'Join ${widget.title} on FitRybe! 🏃‍♂️💨 https://fitrybe.app/trybe/${widget.title.replaceAll(' ', '-')}'),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_active_outlined, color: Colors.white70, size: 20),
                ),
                title: Text('Mute Trybe Notifications', style: GoogleFonts.hankenGrotesk(color: Colors.white, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Trybe notifications muted', style: GoogleFonts.hankenGrotesk(color: Colors.white)),
                      backgroundColor: _accent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: _bg,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Center(
                  child: Icon(
                    Symbols.arrow_back_rounded,
                    color: Colors.white,
                    size: 26,
                    weight: 800,
                  ),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatDetailScreen(
                          chatId: widget.title.replaceAll(' ', '_'),
                          name: widget.title,
                          avatar: widget.imageUrl,
                          isTrybe: true,
                          isOnline: true,
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SvgPicture.string(
                        '''<svg xmlns="http://www.w3.org/2000/svg" width="120" height="88" viewBox="0 0 120 88">
                          <defs>
                            <mask id="cutout-trybe">
                              <rect width="120" height="88" fill="white" />
                              <rect x="36" y="24" width="48" height="12" rx="6" fill="black" />
                              <rect x="36" y="42" width="32" height="12" rx="6" fill="black" />
                            </mask>
                          </defs>
                          <g fill="currentColor" mask="url(#cutout-trybe)">
                            <ellipse cx="60" cy="40" rx="42" ry="33"/>
                            <path d="M24 56 L17 68 Q14 73 20 73 L60 73 Z"/>
                          </g>
                        </svg>''',
                        height: 22,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _showTrybeOptionsMenu,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 6, right: 18),
                      child: Icon(
                        Symbols.more_horiz_rounded,
                        color: Colors.white,
                        size: 28,
                        weight: 800,
                      ),
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.6),
                            _bg,
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _accent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.category.toUpperCase(),
                                  style: GoogleFonts.hankenGrotesk(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.title,
                            style: GoogleFonts.hankenGrotesk(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.memberCount} • ${widget.location}',
                            style: GoogleFonts.hankenGrotesk(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: _toggleJoin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _isJoined ? const Color(0xFF2A2A2E) : _accent,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      shape: const StadiumBorder(),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            _isJoined ? Icons.check_circle_rounded : Icons.group_add_rounded,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            _isJoined ? 'JOINED' : 'JOIN TRYBE',
                                            style: GoogleFonts.hankenGrotesk(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.5,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  SharePlus.instance.share(
                                    ShareParams(text: 'Check out ${widget.title} on FitRybe! 🏃‍♂️'),
                                  );
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A2A2E),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                                  ),
                                  child: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                                ),
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
          ];
        },
        body: Column(
          children: [
            // Sub-Tab Navigation Bar
            Container(
              color: _bg,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSubTabItem(0, 'Feed'),
                  _buildSubTabItem(1, 'Leaderboard'),
                  _buildSubTabItem(2, 'Events'),
                  _buildSubTabItem(3, 'Members'),
                ],
              ),
            ),
            const Divider(color: Colors.white10, height: 1),

            // Main Body Content
            Expanded(
              child: IndexedStack(
                index: _activeSubTab,
                children: [
                  _buildFeedView(),
                  _buildLeaderboardView(),
                  _buildEventsView(),
                  _buildMembersView(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _activeSubTab == 0
          ? FloatingActionButton(
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
            )
          : null,
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
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? _accent : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.hankenGrotesk(
            color: isActive ? _accent : Colors.white60,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }

  // ── 1. FEED TAB VIEW ────────────────────────────────────────────────────────
  Widget _buildFeedView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      children: [
        // Weekly Trybe Goal Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'WEEKLY TRYBE GOAL',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '425.8 / 500 km (85%)',
                    style: GoogleFonts.hankenGrotesk(
                      color: _accent,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: 0.85,
                  minHeight: 8,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(_accent),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '425.8 km achieved by members this week',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Post 1: Marcus Chen
        if (!_hidePost1) ...[
          _buildFeedCard(
            author: 'Marcus Chen',
            time: '2h ago',
            avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA6WB0sfMAaFfo5F_dwIad6ZGs7ulSBob3FMmrDmhtOJzchQRO1kQ477arp3E_zqR1e2HRU4O9zPR6NulCUQptJRJL0L1KYYDH5oPi92uqu8QsqUw-8xM09asGESGFKFyWIvWKw1Nl41cSnNhPABCmfjR6-XsgdajoAlsmMS8XGD13wiRcs-ayK0jhokb9QShfCCCYpwxgnKyz27HxCLrn5LXsL65kly2HvBKh8-o7-1dMd4-7UWF2HIklx4QomICGvKy6NbcwPmwo',
            caption: "Just smashed the Morning Mist 10k Challenge! Who's joining the Saturday group run? 🏃‍♂️💨",
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbSCMsV9KQe-Ufcf5p7oP6YPC-9dbK582RBUf8UbE4q9YxcHM9O6mEB_MAFWpcMWg5Pvup83vzPmGSkp39tH3yZ8FNS39Qvv0I4cb5gpdZyGAxXYnkuETYcg1X5Cc3QxY6Hn-jwGNEdI2rYZ7Sf0dm0KzLb1OBIBYWfc4hOsuxSm69C5EJdo2IdGRIbiE-fSQCRI59DbxJRMIvlvW33lTl2ULjaTsDGytcyap7mAi3u07BjwoSUHEnzM8Rzn8I-DTnlZMsJbEmLvk',
            isLiked: _post1Liked,
            likesCount: _post1Likes,
            comments: _post1Comments,
            onLikeTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _post1Liked = !_post1Liked;
                _post1Likes += _post1Liked ? 1 : -1;
              });
            },
            onHide: () => setState(() => _hidePost1 = true),
          ),
          const SizedBox(height: 20),
        ],

        // Post 2: Sarah J.
        if (!_hidePost2) ...[
          _buildFeedCard(
            author: 'Sarah J.',
            time: '4h ago',
            avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDAP1fzvajosGDCVTnUyqq4353TwT5L9hbdzIAbfVjL23jJvqwjbbg9OEdJD3tgrwrmFKd9QBHpnh_P_TAreUaxMF87aHQGluoDMjKAIMNydXCSFOz7NoDC-C0qQ0PAQytcLv3yf-_Ht2YrCPaoIeHWLOjIWHct32nVuTRlVDle0tfc8u70qmwS3nvQ6yfc3tpX2A_w0nrzZOlzqFt3ArMcMGIp3JUD66upNfTKxZBZ-Dwvs3Mtpy1CCuj2LRYp3YM6QZk5MMqMx2A',
            caption: 'Earned the 80% Century Club badge for this Trybe! Keep pushing everyone! 🏋️‍♀️✨',
            imageUrl: null,
            isLiked: _post2Liked,
            likesCount: _post2Likes,
            comments: _post2Comments,
            onLikeTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _post2Liked = !_post2Liked;
                _post2Likes += _post2Liked ? 1 : -1;
              });
            },
            onHide: () => setState(() => _hidePost2 = true),
          ),
        ],
        const SizedBox(height: 80),
      ],
    );
  }



  Widget _buildFeedCard({
    required String author,
    required String time,
    required String avatarUrl,
    required String caption,
    required String? imageUrl,
    required bool isLiked,
    required int likesCount,
    required List<Map<String, String>> comments,
    required VoidCallback onLikeTap,
    required VoidCallback onHide,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 18, backgroundImage: NetworkImage(avatarUrl)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.bold)),
                    Text(time, style: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 11.5)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showPostOptionsSheet(context, author, onHide: onHide),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.more_horiz, color: Colors.white38),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(caption, style: GoogleFonts.hankenGrotesk(color: Colors.white70, fontSize: 13.5, height: 1.4)),
          if (imageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(imageUrl, height: 170, width: double.infinity, fit: BoxFit.cover),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onLikeTap,
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                          color: isLiked ? _accent : Colors.white60,
                          size: 19,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$likesCount Likes',
                          style: GoogleFonts.hankenGrotesk(color: isLiked ? _accent : Colors.white70, fontWeight: FontWeight.bold, fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => _showCommentsSheet(context, author, comments),
                    child: Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white60, size: 18),
                        const SizedBox(width: 6),
                        Text('${comments.length}', style: GoogleFonts.hankenGrotesk(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12.5)),
                      ],
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white60, size: 18),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  SharePlus.instance.share(ShareParams(text: 'Check out this post from ${widget.title}: "$caption"'));
                },
              ),
            ],
          ),
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
      backgroundColor: _cardBg,
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
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: _accent.withValues(alpha: 0.2),
                                      child: Icon(Icons.person_rounded, color: _accent, size: 16),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment['name'] ?? 'User',
                                            style: GoogleFonts.hankenGrotesk(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            comment['text'] ?? '',
                                            style: GoogleFonts.hankenGrotesk(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      comment['time'] ?? 'Just now',
                                      style: GoogleFonts.hankenGrotesk(
                                        color: Colors.white38,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
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
                              style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Add a comment for $postAuthor...',
                                hintStyle: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 13),
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
                            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
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

  void _showPostOptionsSheet(BuildContext context, String postAuthor, {required VoidCallback onHide}) {
    HapticFeedback.mediumImpact();
    bool isSaved = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: _cardBg,
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
                      isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: isSaved ? _accent : Colors.white70,
                      size: 22,
                    ),
                    title: Text(
                      isSaved ? 'Remove from Saved' : 'Save Post',
                      style: GoogleFonts.hankenGrotesk(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.5),
                    ),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setSheetState(() {
                        isSaved = !isSaved;
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.visibility_off_outlined, color: Colors.white70, size: 22),
                    title: Text('Hide this post', style: GoogleFonts.hankenGrotesk(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.5)),
                    subtitle: Text('See fewer posts like this', style: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 12)),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(ctx);
                      onHide();
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.person_remove_outlined, color: Colors.white70, size: 22),
                    title: Text('Unfollow $postAuthor', style: GoogleFonts.hankenGrotesk(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.5)),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(ctx);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.flag_outlined, color: Colors.red.shade400, size: 22),
                    title: Text('Report Post', style: GoogleFonts.hankenGrotesk(color: Colors.red.shade400, fontWeight: FontWeight.w600, fontSize: 14.5)),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(ctx);
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

  // ── 2. LEADERBOARD TAB VIEW ──────────────────────────────────────────────────
  Widget _buildLeaderboardView() {
    final leaderList = [
      {'rank': '1', 'name': 'Marcus Chen', 'stat': '84.2 km', 'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA6WB0sfMAaFfo5F_dwIad6ZGs7ulSBob3FMmrDmhtOJzchQRO1kQ477arp3E_zqR1e2HRU4O9zPR6NulCUQptJRJL0L1KYYDH5oPi92uqu8QsqUw-8xM09asGESGFKFyWIvWKw1Nl41cSnNhPABCmfjR6-XsgdajoAlsmMS8XGD13wiRcs-ayK0jhokb9QShfCCCYpwxgnKyz27HxCLrn5LXsL65kly2HvBKh8-o7-1dMd4-7UWF2HIklx4QomICGvKy6NbcwPmwo'},
      {'rank': '2', 'name': 'Elena Forge', 'stat': '76.5 km', 'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDAP1fzvajosGDCVTnUyqq4353TwT5L9hbdzIAbfVjL23jJvqwjbbg9OEdJD3tgrwrmFKd9QBHpnh_P_TAreUaxMF87aHQGluoDMjKAIMNydXCSFOz7NoDC-C0qQ0PAQytcLv3yf-_Ht2YrCPaoIeHWLOjIWHct32nVuTRlVDle0tfc8u70qmwS3nvQ6yfc3tpX2A_w0nrzZOlzqFt3ArMcMGIp3JUD66upNfTKxZBZ-Dwvs3Mtpy1CCuj2LRYp3YM6QZk5MMqMx2A'},
      {'rank': '3', 'name': 'David Kim', 'stat': '68.1 km', 'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbSCMsV9KQe-Ufcf5p7oP6YPC-9dbK582RBUf8UbE4q9YxcHM9O6mEB_MAFWpcMWg5Pvup83vzPmGSkp39tH3yZ8FNS39Qvv0I4cb5gpdZyGAxXYnkuETYcg1X5Cc3QxY6Hn-jwGNEdI2rYZ7Sf0dm0KzLb1OBIBYWfc4hOsuxSm69C5EJdo2IdGRIbiE-fSQCRI59DbxJRMIvlvW33lTl2ULjaTsDGytcyap7mAi3u07BjwoSUHEnzM8Rzn8I-DTnlZMsJbEmLvk'},
      {'rank': '4', 'name': 'Sophia Martinez', 'stat': '54.0 km', 'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDKbEFetka61Uzn8RD44STxX3QwAz_xcaaMZ-qzvnunUmBoges-xYFwWQTFpXij18kynNXL1kCjJ7eHZrLBexMEquhDjbpT30ThWjuWEdlZaW_ByrqJdvwg18EsATBXBVms3RCoQVOkpH9PeZiVTAQVE1iGclOOB2OwI8EIuMCCTrdCrl7qcAnsjMphuMjE9MqHlVIp1wCbJOr1ql0Bsee3LkdKqgpT6d9PbFZUGm8ojitxqhE6k0tOEM1_5PnJwz9-xYmUS1H2faU'},
      {'rank': '5', 'name': 'You (Alex)', 'stat': '48.5 km', 'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAHT0fSiT-tBM9-LHbHVlF65CZIgyCqn-DoDUSl05Y0gcWZ5GDqFvUrdutx26mNY5DtnE0ZpijRovfDxUuDLTu5hStbuDoEqMg95eZOlGU7rLLNjJ0EvPXvLs18QfqyMuOb-lgEkqg4Ybw2FlQVeIXwhwd8mUkP3SpCWEUMQnuUuHL2ac9TI_c2sG5wyicbvZ1rz7TuvQ74aVOFymH_WjY3EuexlU6cz0GhX0Kb_z1JbXHSiQhULIuH'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: leaderList.length,
      itemBuilder: (ctx, idx) {
        final item = leaderList[idx];
        final isMe = item['name']!.contains('You');
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  item['rank']!,
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(radius: 18, backgroundImage: NetworkImage(item['avatar']!)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item['name']!,
                  style: GoogleFonts.hankenGrotesk(
                    color: isMe ? _accent : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                item['stat']!,
                style: GoogleFonts.hankenGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── 3. EVENTS TAB VIEW ───────────────────────────────────────────────────────
  Widget _buildEventsView() {
    final events = [
      {
        'id': 0,
        'title': 'Saturday Sunrise 10K Group Run',
        'date': 'Sat, Aug 15 • 06:00 AM',
        'location': 'Hyde Park Bandstand, London',
        'attendees': '24 Runners Going',
      },
      {
        'id': 1,
        'title': 'Wednesday Evening Tempo Sprints',
        'date': 'Wed, Aug 19 • 07:00 PM',
        'location': 'Regent\'s Park Track',
        'attendees': '16 Runners Going',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (ctx, idx) {
        final ev = events[idx];
        final id = ev['id'] as int;
        final isRsvped = _eventRsvp[id] ?? false;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.event_rounded, color: _accent, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ev['title'] as String, style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(ev['date'] as String, style: GoogleFonts.hankenGrotesk(color: _accent, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: Colors.white38, size: 14),
                  const SizedBox(width: 6),
                  Text(ev['location'] as String, style: GoogleFonts.hankenGrotesk(color: Colors.white54, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ev['attendees'] as String, style: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 11.5, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _eventRsvp[id] = !isRsvped;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRsvped ? const Color(0xFF2A2A2E) : _accent,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      isRsvped ? 'GOING ✓' : 'RSVP',
                      style: GoogleFonts.hankenGrotesk(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ── 4. MEMBERS TAB VIEW ──────────────────────────────────────────────────────
  Widget _buildMembersView() {
    final members = [
      {'name': 'Marcus Chen', 'role': 'Trybe Creator', 'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA6WB0sfMAaFfo5F_dwIad6ZGs7ulSBob3FMmrDmhtOJzchQRO1kQ477arp3E_zqR1e2HRU4O9zPR6NulCUQptJRJL0L1KYYDH5oPi92uqu8QsqUw-8xM09asGESGFKFyWIvWKw1Nl41cSnNhPABCmfjR6-XsgdajoAlsmMS8XGD13wiRcs-ayK0jhokb9QShfCCCYpwxgnKyz27HxCLrn5LXsL65kly2HvBKh8-o7-1dMd4-7UWF2HIklx4QomICGvKy6NbcwPmwo'},
      {'name': 'Elena Forge', 'role': 'Captain', 'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDAP1fzvajosGDCVTnUyqq4353TwT5L9hbdzIAbfVjL23jJvqwjbbg9OEdJD3tgrwrmFKd9QBHpnh_P_TAreUaxMF87aHQGluoDMjKAIMNydXCSFOz7NoDC-C0qQ0PAQytcLv3yf-_Ht2YrCPaoIeHWLOjIWHct32nVuTRlVDle0tfc8u70qmwS3nvQ6yfc3tpX2A_w0nrzZOlzqFt3ArMcMGIp3JUD66upNfTKxZBZ-Dwvs3Mtpy1CCuj2LRYp3YM6QZk5MMqMx2A'},
      {'name': 'David Kim', 'role': 'Member', 'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbSCMsV9KQe-Ufcf5p7oP6YPC-9dbK582RBUf8UbE4q9YxcHM9O6mEB_MAFWpcMWg5Pvup83vzPmGSkp39tH3yZ8FNS39Qvv0I4cb5gpdZyGAxXYnkuETYcg1X5Cc3QxY6Hn-jwGNEdI2rYZ7Sf0dm0KzLb1OBIBYWfc4hOsuxSm69C5EJdo2IdGRIbiE-fSQCRI59DbxJRMIvlvW33lTl2ULjaTsDGytcyap7mAi3u07BjwoSUHEnzM8Rzn8I-DTnlZMsJbEmLvk'},
      {'name': 'Sophia Martinez', 'role': 'Member', 'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDKbEFetka61Uzn8RD44STxX3QwAz_xcaaMZ-qzvnunUmBoges-xYFwWQTFpXij18kynNXL1kCjJ7eHZrLBexMEquhDjbpT30ThWjuWEdlZaW_ByrqJdvwg18EsATBXBVms3RCoQVOkpH9PeZiVTAQVE1iGclOOB2OwI8EIuMCCTrdCrl7qcAnsjMphuMjE9MqHlVIp1wCbJOr1ql0Bsee3LkdKqgpT6d9PbFZUGm8ojitxqhE6k0tOEM1_5PnJwz9-xYmUS1H2faU'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: members.length,
      itemBuilder: (ctx, idx) {
        final m = members[idx];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(radius: 20, backgroundImage: NetworkImage(m['avatar']!)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m['name']!, style: GoogleFonts.hankenGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(m['role']!, style: GoogleFonts.hankenGrotesk(color: _accent, fontSize: 11.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: Text('Follow', style: GoogleFonts.hankenGrotesk(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}

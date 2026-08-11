import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_detail_screen.dart';

class MessagingScreen extends StatefulWidget {
  static const routeName = '/MessagingScreen';

  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> with SingleTickerProviderStateMixin {
  final Color _accent = const Color(0xFFFF5722);
  final Color _bg = const Color(0xFF131316);
  final Color _cardBg = const Color(0xFF1E1E22);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilterIndex = 0; // 0: All, 1: Direct, 2: Trybes



  // Conversations List
  final List<Map<String, dynamic>> _conversations = [
    {
      'id': 'c1',
      'type': 'direct',
      'name': 'Marcus Vane',
      'sub': 'Patna, Bihar • Runner',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBgjRSNIhjmFhRP_8S3tuvi1UgLC68VGmAkh42cOH9VQliTiy7tCc6SthMMHXDQA4u5KVBjJbgUpMGDWngdIa0napfGh8KuaI2R7Vg5APFj_FuEPtSycFIZ0S48-A0mTSDF9pEM1B68-1eG3zJonxwSmwvmtIGw9-09xvJbXE20Bc3pv4KvyqQJNn1emw8tMbAY9KUjxJD_Lmjaw4Duenm3KPou27843mgzy-OF2cdC5p_ej4RvuGJAVUmHusIFbL2nb5sunZYAAqE',
      'lastMessage': 'Awesome pace on today’s morning 10K run! 🔥',
      'time': '10m ago',
      'unread': 2,
      'isOnline': true,
    },
    {
      'id': 'c2',
      'type': 'trybe',
      'name': 'Patna Striders 🏃‍♂️',
      'sub': '1,240 members',
      'avatar':
          'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=400',
      'lastMessage': 'Elena: Group meetup at Gandhi Maidan at 6:00 AM tomorrow!',
      'time': '34m ago',
      'unread': 5,
      'isOnline': false,
    },
    {
      'id': 'c3',
      'type': 'direct',
      'name': 'Elena Forge',
      'sub': 'Mumbai, India • Powerlifter',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDCQQabYLTohBmurAKr1RUN2IAmRiPuGsqFmInWzHEf__Aq8Lrup0DEecMWshiQqtOB1HAs-8fkX6PyMCEda_L3qGqU0Hd3pZ6C2Y99UPYmQjEvRzMX1Ola5UWClM-T51g-lXpPghN0dwlp7dEba8xTJJu76POnA9jCcIucHyiHs382ck93N92xzFSCg5Ed3_FxMZ4LfiX1hUbWrKGISFRwSRvCzC5BrI0mY3Ul_Hg9WbhgXrTKTFZULhLCg3sEkwFHYGol8j0dPoc',
      'lastMessage': 'Sent you the new powerlifting workout routine 🏋️‍♀️',
      'time': '2h ago',
      'unread': 0,
      'isOnline': true,
    },
    {
      'id': 'c4',
      'type': 'trybe',
      'name': 'Elite Runners Trybe',
      'sub': '842 members',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDegFaC4Ag757kCG6u-XWSSoEytMNfsVKTDGaGZBHQd6UtsdJChKNrtDWjc3XRP4UcT3rhD8XPQMdb6EtfCVLGT9vJhVkAW8rROvOhZqBxco1sl9-B7kfUq9Hpsc6ilJHL1woe80Qc6HgaSFdLqbL7dfm3na1Dqaa3Slr7TQZ-4HI-7Sv0VGNtY-omsZSrBLLVT6oCy4pW17ZCXuj_1rd8OvLc4YTnXPqPYKGcPZAZO45ztzq-ZnQ847Qouqq6Wfq3lsb-kofKqyXo',
      'lastMessage': 'Sarah shared a workout: 15.2 km Interval Training',
      'time': '4h ago',
      'unread': 0,
      'isOnline': false,
    },
    {
      'id': 'c5',
      'type': 'direct',
      'name': 'Sarah Jenkins',
      'sub': 'Patna, Bihar • Cyclist',
      'avatar':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDZEtQZ2pORiFgwS8V2nQO0E69YkI0Oqooc8KhFjmnTDLcYvyoMxeLVRixFQd9a_BBq9BG9nvLci8oAL92pScug74S9dIcF6fIRW_uznf2ED1ss6gtmVCpajslV1W_mEgVJh1D8_eaA_XdbpOEMbhFcQCVGihiYEC7dPpHMOjGWwHCmHkoW-cWIo84ku68eXpJYrAqDMoAjPaFHk6bpwduHgxoRYNvB-mMS4bFDxEbb2Qkf7hSAlA5mWF6P3WQVed2wLfpN7uSNFAg',
      'lastMessage': 'Are we cycling towards Digha Ghat this weekend?',
      'time': '1d ago',
      'unread': 0,
      'isOnline': true,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openChat(Map<String, dynamic> chatData) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(
          chatId: chatData['id'],
          name: chatData['name'],
          avatar: chatData['avatar'],
          isTrybe: chatData['type'] == 'trybe',
          isOnline: chatData['isOnline'] ?? false,
        ),
      ),
    );
  }

  void _showNewChatDialog() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'New Message',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: _accent.withValues(alpha: 0.15),
                  child: Icon(Icons.person_add_rounded, color: _accent),
                ),
                title: Text(
                  'New Direct Message',
                  style: GoogleFonts.hankenGrotesk(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Chat 1-on-1 with a friend or athlete',
                  style: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _openChat(_conversations[0]);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: _accent.withValues(alpha: 0.15),
                  child: Icon(Icons.groups_rounded, color: _accent),
                ),
                title: Text(
                  'New Trybe Group Chat',
                  style: GoogleFonts.hankenGrotesk(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Start a conversation with Trybe members',
                  style: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _openChat(_conversations[1]);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredConversations = _conversations.where((c) {
      if (_selectedFilterIndex == 1 && c['type'] != 'direct') return false;
      if (_selectedFilterIndex == 2 && c['type'] != 'trybe') return false;
      if (_searchQuery.isNotEmpty) {
        final name = c['name'].toString().toLowerCase();
        final msg = c['lastMessage'].toString().toLowerCase();
        return name.contains(_searchQuery) || msg.contains(_searchQuery);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Messages',
          style: GoogleFonts.hankenGrotesk(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _showNewChatDialog,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SvgPicture.string(
                '''<svg xmlns="http://www.w3.org/2000/svg" width="120" height="100" viewBox="0 0 120 100">
                  <defs>
                    <mask id="cutout">
                      <rect width="120" height="100" fill="white" />
                      <rect x="36" y="24" width="48" height="12" rx="6" fill="black" />
                      <rect x="36" y="42" width="32" height="12" rx="6" fill="black" />
                      <circle cx="96" cy="76" r="21" fill="black" />
                    </mask>
                  </defs>
                  <g fill="currentColor" mask="url(#cutout)">
                    <ellipse cx="60" cy="40" rx="42" ry="33"/>
                    <path d="M24 56 L17 68 Q14 73 20 73 L60 73 Z"/>
                  </g>
                  <g fill="currentColor">
                    <rect x="79" y="70.5" width="34" height="11" rx="5.5"/>
                    <rect x="90.5" y="59" width="11" height="34" rx="5.5"/>
                  </g>
                </svg>''',
                height: 25,
                colorFilter: const ColorFilter.mode(
                  Colors.white70,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim().toLowerCase();
                });
              },
              style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.white38, size: 20),
                hintText: 'Search messages or friends...',
                hintStyle: GoogleFonts.hankenGrotesk(color: Colors.white30, fontSize: 13.5),
                filled: true,
                fillColor: _cardBg,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),



          // Filter Segmented Pills (All / Direct / Trybes)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildFilterChip('All', 0),
                const SizedBox(width: 8),
                _buildFilterChip('Direct Messages', 1),
                const SizedBox(width: 8),
                _buildFilterChip('Trybes', 2),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Conversations List
          Expanded(
            child: filteredConversations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, color: Colors.white24, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          'No conversations found',
                          style: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: filteredConversations.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white.withValues(alpha: 0.08),
                      height: 1,
                      indent: 62,
                    ),
                    itemBuilder: (context, index) {
                      final item = filteredConversations[index];
                      final isUnread = (item['unread'] ?? 0) > 0;

                      return GestureDetector(
                        onTap: () => _openChat(item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(item['avatar']),
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
                                          item['name'],
                                          style: GoogleFonts.hankenGrotesk(
                                            color: Colors.white,
                                            fontWeight:
                                                isUnread ? FontWeight.bold : FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          item['time'],
                                          style: GoogleFonts.hankenGrotesk(
                                            color: isUnread ? _accent : Colors.white38,
                                            fontSize: 11,
                                            fontWeight:
                                                isUnread ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item['lastMessage'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.hankenGrotesk(
                                              color: isUnread ? Colors.white : Colors.white54,
                                              fontWeight: isUnread
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        if (isUnread) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 7,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _accent,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              '${item['unread']}',
                                              style: GoogleFonts.hankenGrotesk(
                                                color: Colors.white,
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
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
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? _accent.withValues(alpha: 0.15) : _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _accent : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.hankenGrotesk(
            color: isSelected ? Colors.white : Colors.white60,
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum _NotifType {
  kudos,
  comment,
  followRequest,
  trybeInvite,
  achievement,
  liveActivity,
  badge,
  follow,
}

class _NotificationItem {
  _NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
    this.avatarUrl,
    this.isRead = false,
    this.actionable = false,
  });

  final String id;
  final _NotifType type;
  final String title;
  final String subtitle;
  final String time;
  final String? avatarUrl;
  bool isRead;
  final bool actionable;
  String? actionResolution; // null, 'accepted', 'declined', 'joined', 'ignored'
}

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  final Color _accent = const Color(0xFFFF5722);

  static const String _marcusUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBgjRSNIhjmFhRP_8S3tuvi1UgLC68VGmAkh42cOH9VQliTiy7tCc6SthMMHXDQA4u5KVBjJbgUpMGDWngdIa0napfGh8KuaI2R7Vg5APFj_FuEPtSycFIZ0S48-A0mTSDF9pEM1B68-1eG3zJonxwSmwvmtIGw9-09xvJbXE20Bc3pv4KvyqQJNn1emw8tMbAY9KUjxJD_Lmjaw4Duenm3KPou27843mgzy-OF2cdC5p_ej4RvuGJAVUmHusIFbL2nb5sunZYAAqE';
  static const String _elenaUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDCQQabYLTohBmurAKr1RUN2IAmRiPuGsqFmInWzHEf__Aq8Lrup0DEecMWshiQqtOB1HAs-8fkX6PyMCEda_L3qGqU0Hd3pZ6C2Y99UPYmQjEvRzMX1Ola5UWClM-T51g-lXpPghN0dwlp7dEba8xTJJu76POnA9jCcIucHyiHs382ck93N92xzFSCg5Ed3_FxMZ4LfiX1hUbWrKGISFRwSRvCzC5BrI0mY3Ul_Hg9WbhgXrTKTFZULhLCg3sEkwFHYGol8j0dPoc';
  static const String _gujUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBWx5umQiyz5zTsO2R59sz6-ZJBoCs_nZs85WNJFvHFAXTu2QdPMQAnLFwnsOjJEqaKcAdcpv9qPq6NQlJV7p3SyDX5EIVrn0bEU9-AP4_8x_xEUVHdOiDAP3wLWp-IHQa66Tlzzu2-LDvsB2lxqL53shYINDqc8cVbqVZ_A5LMSmdfU-nToulwi9Fj81mCD9UTzqkJlubLx5AcUiLKC8JqNPOE2QnZ7YAtQXOmHziYWkiMpbPMGmnYNiBMEoC970DEuzYd659rK9k';
  static const String _grxUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD5xXoM82GHJSQNSl-JXZOu5g-UWak_YAKKVH81A7Pf5_ExAZcNb5DbW8GCumWsV-zMwHv3df74Lwq1T84Rv4lBZWo542IXaSkyYwXzvb8k8g_JPrPu1T53bWgYiW-AyaVdApEQgzXSpD478-4u-5NEbhYkbWboLJOGYNrPueRMJMQgJCb2G1RrKuTkG2RDaTaD4CU8k1_BBvmnX26awaaSmU5ageWKNr-9UQ_Joyp8XDp3nuGlhp_AMJzgltoEIZ4Cp2JFHzHIqug';

  late final List<_NotificationItem> _today = [
    _NotificationItem(
      id: 't1',
      type: _NotifType.kudos,
      title: 'Marcus liked ur post',
      subtitle: 'On your "Morning Run" activity',
      time: '12m ago',
      avatarUrl: _marcusUrl,
    ),
    _NotificationItem(
      id: 't2',
      type: _NotifType.comment,
      title: 'Elena commented on your post',
      subtitle: '"Let\'s crush this weekend 🔥"',
      time: '45m ago',
      avatarUrl: _elenaUrl,
    ),
    _NotificationItem(
      id: 't3',
      type: _NotifType.follow,
      title: 'Guj followed you',
      subtitle: 'Check out their profile',
      time: '2h ago',
      avatarUrl: _gujUrl,
    ),
  ];

  late final List<_NotificationItem> _yesterday = [
    _NotificationItem(
      id: 'y1',
      type: _NotifType.trybeInvite,
      title: 'Marcus invited you to a Trybe',
      subtitle: '"Daily Cardio Crew" · 24 members',
      time: '1d ago',
      avatarUrl: _marcusUrl,
      actionable: true,
    ),
    _NotificationItem(
      id: 'y2',
      type: _NotifType.achievement,
      title: 'You moved up in Weekend Warrior',
      subtitle: 'Now ranked #98, up 14 places',
      time: '1d ago',
      isRead: true,
    ),
    _NotificationItem(
      id: 'y3',
      type: _NotifType.liveActivity,
      title: '"Evening Walk" starts soon',
      subtitle: 'Clique activity begins in 1 hour',
      time: '1d ago',
      isRead: true,
    ),
  ];

  late final List<_NotificationItem> _earlier = [
    _NotificationItem(
      id: 'e1',
      type: _NotifType.kudos,
      title: 'Elena and 3 others liked your PR',
      subtitle: 'Strength Training personal record',
      time: '3d ago',
      avatarUrl: _elenaUrl,
      isRead: true,
    ),
    _NotificationItem(
      id: 'e2',
      type: _NotifType.badge,
      title: 'New badge unlocked',
      subtitle: 'You earned the "7-Day Streak" badge',
      time: '5d ago',
      isRead: true,
    ),
    _NotificationItem(
      id: 'e3',
      type: _NotifType.follow,
      title: 'grxtvtb started following you',
      subtitle: 'Check out their profile',
      time: '6d ago',
      avatarUrl: _grxUrl,
      isRead: true,
    ),
  ];

  bool get _hasUnread => [
        ..._today,
        ..._yesterday,
        ..._earlier,
      ].any((n) => !n.isRead);

  void _markAllRead() {
    HapticFeedback.lightImpact();
    setState(() {
      for (final n in [..._today, ..._yesterday, ..._earlier]) {
        n.isRead = true;
      }
    });
  }

  void _markRead(_NotificationItem item) {
    if (item.isRead) return;
    setState(() => item.isRead = true);
  }

  void _resolveAction(_NotificationItem item, String resolution, String message) {
    HapticFeedback.mediumImpact();
    setState(() {
      item.actionResolution = resolution;
      item.isRead = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _accent,
        content: Text(
          message,
          style: GoogleFonts.hankenGrotesk(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = _today.isEmpty && _yesterday.isEmpty && _earlier.isEmpty;

    if (isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildHeader(),
            const SizedBox(height: 20),
            if (_today.isNotEmpty) ...[
              _buildSectionHeader('TODAY'),
              const SizedBox(height: 12),
              ..._today.map(_buildNotificationCard),
              const SizedBox(height: 20),
            ],
            if (_yesterday.isNotEmpty) ...[
              _buildSectionHeader('YESTERDAY'),
              const SizedBox(height: 12),
              ..._yesterday.map(_buildNotificationCard),
              const SizedBox(height: 20),
            ],
            if (_earlier.isNotEmpty) ...[
              _buildSectionHeader('EARLIER'),
              const SizedBox(height: 12),
              ..._earlier.map(_buildNotificationCard),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Stay on top of your Trybe activity.',
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white38,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _hasUnread ? _markAllRead : null,
          child: Opacity(
            opacity: _hasUnread ? 1.0 : 0.35,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.done_all_rounded, color: Colors.white70, size: 15),
                  const SizedBox(width: 6),
                  Text(
                    'Mark all read',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white70,
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String label) {
    return Text(
      label,
      style: GoogleFonts.hankenGrotesk(
        color: Colors.white38,
        fontSize: 10.5,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  ({IconData icon, Color color}) _iconFor(_NotifType type) {
    switch (type) {
      case _NotifType.kudos:
        return (icon: Icons.favorite_rounded, color: const Color(0xFFFF5722));
      case _NotifType.comment:
        return (icon: Icons.chat_bubble_rounded, color: const Color(0xFF448AFF));
      case _NotifType.followRequest:
      case _NotifType.follow:
        return (icon: Icons.person_add_alt_1_rounded, color: const Color(0xFF81C784));
      case _NotifType.trybeInvite:
        return (icon: Icons.group_add_rounded, color: const Color(0xFFFFB300));
      case _NotifType.achievement:
        return (icon: Icons.emoji_events_rounded, color: const Color(0xFFFF5722));
      case _NotifType.liveActivity:
        return (icon: Icons.directions_run_rounded, color: const Color(0xFFE57373));
      case _NotifType.badge:
        return (icon: Icons.military_tech_rounded, color: const Color(0xFFFFB300));
    }
  }

  Widget _buildLeading(_NotificationItem item) {
    final iconSpec = _iconFor(item.type);
    if (item.avatarUrl != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(item.avatarUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: iconSpec.color,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF131316), width: 2),
              ),
              child: Icon(iconSpec.icon, color: Colors.white, size: 11),
            ),
          ),
        ],
      );
    }
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: iconSpec.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(iconSpec.icon, color: iconSpec.color, size: 22),
    );
  }

  Widget _buildNotificationCard(_NotificationItem item) {
    final bool unread = !item.isRead;
    return GestureDetector(
      onTap: () => _markRead(item),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeading(item),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: GoogleFonts.hankenGrotesk(
                            color: unread ? Colors.white : Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (unread) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: _accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white54,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.time,
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white24,
                      fontSize: 10.5,
                    ),
                  ),
                  if (item.actionable) ...[
                    const SizedBox(height: 12),
                    _buildActionRow(item),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(_NotificationItem item) {
    if (item.actionResolution != null) {
      final resolved = item.actionResolution!;
      final bool positive = resolved == 'accepted' || resolved == 'joined';
      return Row(
        children: [
          Icon(
            positive ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: positive ? const Color(0xFF81C784) : Colors.white38,
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            resolved == 'accepted'
                ? 'Accepted'
                : resolved == 'declined'
                    ? 'Declined'
                    : resolved == 'joined'
                        ? 'Joined'
                        : 'Ignored',
            style: GoogleFonts.hankenGrotesk(
              color: positive ? const Color(0xFF81C784) : Colors.white38,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    final bool isInvite = item.type == _NotifType.trybeInvite;
    final String positiveLabel = isInvite ? 'Join' : 'Accept';
    final String negativeLabel = isInvite ? 'Ignore' : 'Decline';

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _resolveAction(
              item,
              isInvite ? 'joined' : 'accepted',
              isInvite ? 'Joined the Trybe!' : 'Follow request accepted',
            ),
            child: Container(
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                positiveLabel,
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => _resolveAction(
              item,
              isInvite ? 'ignored' : 'declined',
              isInvite ? 'Invite ignored' : 'Follow request declined',
            ),
            child: Container(
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2E2E32)),
              ),
              child: Text(
                negativeLabel,
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_rounded, color: _accent.withValues(alpha: 0.3), size: 80),
            const SizedBox(height: 16),
            Text(
              'All caught up',
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have no notifications right now.',
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
}

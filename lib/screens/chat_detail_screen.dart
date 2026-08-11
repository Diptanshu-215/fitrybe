import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String name;
  final String avatar;
  final bool isTrybe;
  final bool isOnline;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.name,
    required this.avatar,
    this.isTrybe = false,
    this.isOnline = false,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final Color _accent = const Color(0xFFFF5722);
  final Color _bg = const Color(0xFF131316);
  final Color _cardBg = const Color(0xFF1E1E22);

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  late List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      {
        'id': 'm1',
        'isMe': false,
        'senderName': widget.name,
        'text': 'Hey! Great run today! Are we meeting at Gandhi Maidan at 6:00 AM tomorrow?',
        'time': '10:14 AM',
        'type': 'text',
      },
      {
        'id': 'm2',
        'isMe': true,
        'senderName': 'You',
        'text': 'Yes absolutely! I will bring the new hydration strategy test plan.',
        'time': '10:16 AM',
        'type': 'text',
      },
      {
        'id': 'm3',
        'isMe': false,
        'senderName': widget.name,
        'type': 'workout',
        'workoutTitle': 'Morning 10K Tempo Run',
        'distance': '10.2 km',
        'pace': '4:52 /km',
        'timeStr': '49m 38s',
        'calories': '680 kcal',
        'time': '10:20 AM',
      },
      {
        'id': 'm4',
        'isMe': false,
        'senderName': widget.name,
        'text': 'Check out my tempo pace from yesterday! Setting a new PR for our Saturday group run.',
        'time': '10:21 AM',
        'type': 'text',
      },
    ];
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage({String text = '', String type = 'text', String? mediaPath}) {
    final msgText = text.trim();
    if (msgText.isEmpty && type == 'text') return;

    HapticFeedback.lightImpact();
    final now = DateTime.now();
    final timeStr = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'isMe': true,
        'senderName': 'You',
        'text': msgText,
        'type': type,
        'mediaPath': mediaPath,
        'time': timeStr,
        'workoutTitle': type == 'workout' ? 'Morning 5K Workout' : null,
        'distance': type == 'workout' ? '5.0 km' : null,
        'pace': type == 'workout' ? '5:10 /km' : null,
        'timeStr': type == 'workout' ? '25m 50s' : null,
        'calories': type == 'workout' ? '340 kcal' : null,
      });
    });

    _textController.clear();
    _scrollToBottom();
  }

  Future<void> _attachImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (image != null) {
        _sendMessage(type: 'image', mediaPath: image.path);
      }
    } catch (e) {
      debugPrint('Error attaching image: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
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
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.avatar),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (widget.isTrybe)
                    Text(
                      'Trybe Group Chat',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Message Feed
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // Input Dock
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _bg,
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 14),
                      onSubmitted: (val) => _sendMessage(text: val),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.hankenGrotesk(color: Colors.white30, fontSize: 14),
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        prefixIcon: IconButton(
                          icon: const Icon(
                            Symbols.add_photo_alternate_rounded,
                            color: Colors.white54,
                            size: 22,
                            fill: 1.0,
                            weight: 700,
                          ),
                          onPressed: _attachImage,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: Colors.white38),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white54,
                      size: 24,
                    ),
                    onPressed: () => _sendMessage(text: _textController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final bool isMe = msg['isMe'] == true;
    final String type = msg['type'] ?? 'text';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? _accent : _cardBg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe && widget.isTrybe) ...[
              Text(
                msg['senderName'] ?? '',
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
            ],

            // Text message
            if (type == 'text' && msg['text'] != null && msg['text'].isNotEmpty)
              Text(
                msg['text'],
                style: GoogleFonts.hankenGrotesk(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),

            // Image message
            if (type == 'image' && msg['mediaPath'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(msg['mediaPath']),
                  fit: BoxFit.cover,
                ),
              ),

            // Workout card message
            if (type == 'workout') ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMe ? Colors.black.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.directions_run_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            msg['workoutTitle'] ?? 'Shared Workout',
                            style: GoogleFonts.hankenGrotesk(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCol('DISTANCE', msg['distance'] ?? '10.0 km'),
                        _buildStatCol('PACE', msg['pace'] ?? '5:00 /km'),
                        _buildStatCol('TIME', msg['timeStr'] ?? '45m 00s'),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  msg['time'] ?? '',
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white54,
                    fontSize: 10,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all_rounded, color: Colors.white70, size: 12),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCol(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.hankenGrotesk(color: Colors.white38, fontSize: 9.5, fontWeight: FontWeight.bold),
        ),
        Text(
          val,
          style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

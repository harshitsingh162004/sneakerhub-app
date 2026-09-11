import 'package:flutter/material.dart';
import '../../core/constants.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock conversations
    final conversations = [
      {
        'name': 'Nike Store Official',
        'lastMessage': 'Your bid of ₹18,500 was accepted!',
        'time': '2m ago',
        'unread': 2,
        'avatar': 'N',
        'color': AppConstants.electricBlue,
      },
      {
        'name': 'Sneaker Seller Pro',
        'lastMessage': 'The item will be shipped within 3 days',
        'time': '1h ago',
        'unread': 0,
        'avatar': 'S',
        'color': AppConstants.success,
      },
      {
        'name': 'Jordan Collector',
        'lastMessage': 'Is the size 10 available?',
        'time': '3h ago',
        'unread': 1,
        'avatar': 'J',
        'color': AppConstants.warning,
      },
      {
        'name': 'SneakerHub Support',
        'lastMessage': 'How can we help you today?',
        'time': '1d ago',
        'unread': 0,
        'avatar': '?',
        'color': AppConstants.neonBlue,
      },
    ];

    return Scaffold(
      backgroundColor: AppConstants.bgDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Messages', style: AppConstants.heading1),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.cardBlue,
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: const Icon(Icons.edit_outlined,
                        color: AppConstants.textWhite, size: 20),
                  ),
                ],
              ),
            ),

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                style: const TextStyle(color: AppConstants.textWhite),
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: const TextStyle(color: AppConstants.textGrey),
                  prefixIcon:
                      const Icon(Icons.search, color: AppConstants.textGrey),
                  filled: true,
                  fillColor: AppConstants.cardBlue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conv = conversations[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatDetailScreen(
                          name: conv['name'] as String,
                          avatar: conv['avatar'] as String,
                          avatarColor: conv['color'] as Color,
                        ),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppConstants.cardBlue,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusM),
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: (conv['color'] as Color).withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: conv['color'] as Color, width: 1.5),
                            ),
                            child: Center(
                              child: Text(
                                conv['avatar'] as String,
                                style: TextStyle(
                                  color: conv['color'] as Color,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      conv['name'] as String,
                                      style: const TextStyle(
                                        color: AppConstants.textWhite,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      conv['time'] as String,
                                      style: const TextStyle(
                                        color: AppConstants.textGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        conv['lastMessage'] as String,
                                        style: const TextStyle(
                                          color: AppConstants.textGrey,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if ((conv['unread'] as int) > 0)
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          color: AppConstants.electricBlue,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${conv['unread']}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String avatar;
  final Color avatarColor;

  const ChatDetailScreen({
    super.key,
    required this.name,
    required this.avatar,
    required this.avatarColor,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _msgController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hi! I saw you placed a bid on my Nike Air Jordan listing.',
      'isMine': false,
      'time': '10:30 AM',
    },
    {
      'text': 'Yes! Really interested. Is it in good condition?',
      'isMine': true,
      'time': '10:31 AM',
    },
    {
      'text': 'Absolutely! Brand new, never worn. Original box included.',
      'isMine': false,
      'time': '10:32 AM',
    },
    {
      'text': 'Great! I\'ll place my best bid.',
      'isMine': true,
      'time': '10:33 AM',
    },
  ];

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'text': _msgController.text.trim(),
        'isMine': true,
        'time': TimeOfDay.now().format(context),
      });
    });
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgDark,
      appBar: AppBar(
        backgroundColor: AppConstants.navyBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: widget.avatarColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: widget.avatarColor, width: 1.5),
              ),
              child: Center(
                child: Text(
                  widget.avatar,
                  style: TextStyle(
                    color: widget.avatarColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const Text('Online',
                    style:
                        TextStyle(fontSize: 12, color: AppConstants.success)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMine = msg['isMine'] as bool;
                return Align(
                  alignment:
                      isMine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      gradient: isMine ? AppConstants.blueGradient : null,
                      color: isMine ? null : AppConstants.cardBlue,
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      boxShadow: isMine
                          ? [
                              BoxShadow(
                                color:
                                    AppConstants.electricBlue.withOpacity(0.2),
                                blurRadius: 8,
                              )
                            ]
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          msg['text'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Input
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: AppConstants.navyBlue,
              border: Border(
                top: BorderSide(
                    color: AppConstants.electricBlue.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    style: const TextStyle(color: AppConstants.textWhite),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: AppConstants.textGrey),
                      filled: true,
                      fillColor: AppConstants.cardBlue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppConstants.blueGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.electricBlue.withOpacity(0.4),
                          blurRadius: 10,
                        ),
                      ],
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
    );
  }
}

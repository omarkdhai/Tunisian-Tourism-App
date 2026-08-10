import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, required this.timestamp});
}

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hi! 👋 I\'m your AI travel assistant for Tunisia. I can help you plan your trip, find places to visit, recommend restaurants, and answer any questions during your journey.\n\nHow can I help you today?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  final List<String> _quickReplies = [
    'What should I do today?',
    'Where should I eat?',
    'I\'m bored, suggest something',
    'It\'s raining, change my plan',
    'Find places under 30 TND',
    'How do I get to the Medina?',
  ];

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _ctrl.clear();

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
      _isTyping = true;
    });
    _scrollToBottom();

    // Simulate AI response delay (replace with actual /api/trips/chat endpoint)
    await Future.delayed(const Duration(milliseconds: 1500));

    final response = _generateMockResponse(text);
    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(text: response, isUser: false, timestamp: DateTime.now()));
    });
    _scrollToBottom();
  }

  String _generateMockResponse(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('eat') || lower.contains('food') || lower.contains('restaurant')) {
      return '🍽️ Based on your location, I recommend:\n\n1. **Dar El Jeld** (Tunis Medina) — Traditional Tunisian cuisine, ★4.8\n2. **Restaurant Carthage** — Great couscous, ★4.5\n3. **Le Pirate** (Sidi Bou Said) — Seafood with a view\n\nWould you like directions to any of these?';
    }
    if (lower.contains('bored') || lower.contains('suggest') || lower.contains('nearby')) {
      return '🎯 You\'re 10 minutes from Sidi Bou Said! Here are some options:\n\n• 🏛️ Carthage ruins (2.3km away)\n• 🎨 Art gallery in the village (500m)\n• ☕ Café des Délices with panoramic sea views\n\nWhich sounds interesting?';
    }
    if (lower.contains('rain')) {
      return '☔ No worries! Indoor alternatives for today:\n\n• 🕌 The Bardo National Museum (open until 5pm)\n• 🛍️ Tunisia Mall shopping center\n• ☕ Relax at a traditional café in the Medina\n\nWant me to update your itinerary with one of these?';
    }
    if (lower.contains('30') || lower.contains('cheap') || lower.contains('budget')) {
      return '💰 Under 30 TND near you:\n\n• Sidi Bou Said walk (free!)\n• Medina artisan tour: 15 TND\n• Traditional hammam experience: 25 TND\n• Bardo Museum entry: 8 TND\n\nAll great value options! 🎉';
    }
    if (lower.contains('get to') || lower.contains('how') || lower.contains('direction')) {
      return '🗺️ To get there:\n\n• **Metro Line 4** from Tunis Marine (25 min, 2 TND)\n• **Taxi** approximately 15-20 TND\n• **Louage** from Bab Saadoun station (cheapest!)\n\nI can open the map for turn-by-turn directions! Want me to?';
    }
    return '🤖 Great question! I\'m analyzing your current itinerary and preferences to give you the best recommendation for Tunisia.\n\nBased on your interest in ${['beaches', 'culture', 'food'][DateTime.now().second % 3]}, I suggest checking out some hidden gems nearby. Shall I add something to your itinerary?';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => context.pop()),
        title: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: const BoxDecoration(color: Color(0xFF1E1E1E), shape: BoxShape.circle),
              child: const Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Assistant', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Online · Tunisia Expert', style: GoogleFonts.inter(fontSize: 11, color: Colors.green)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) return _buildTypingIndicator();
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Quick Replies
          if (_messages.length <= 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickReplies.map((r) => GestureDetector(
                    onTap: () => _sendMessage(r),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(r, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                  )).toList(),
                ),
              ),
            ),

          // Input Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _ctrl,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _sendMessage(_ctrl.text),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E1E1E),
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
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32, height: 32,
              decoration: const BoxDecoration(color: Color(0xFF1E1E1E), shape: BoxShape.circle),
              child: const Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Text(
                message.text,
                style: GoogleFonts.inter(
                  color: isUser ? Colors.white : const Color(0xFF111827),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: const BoxDecoration(color: Color(0xFF1E1E1E), shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _buildDot(i)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (index * 150)),
      builder: (_, v, __) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 8, height: 8,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3 + (v * 0.7)),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

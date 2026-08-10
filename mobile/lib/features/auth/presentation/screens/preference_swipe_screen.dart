import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class PreferenceSwiperCard {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String emoji;

  const PreferenceSwiperCard({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.emoji,
  });
}

class PreferenceSwipeScreen extends StatefulWidget {
  const PreferenceSwipeScreen({super.key});

  @override
  State<PreferenceSwipeScreen> createState() => _PreferenceSwipeScreenState();
}

class _PreferenceSwipeScreenState extends State<PreferenceSwipeScreen> {
  final CardSwiperController _swiperController = CardSwiperController();
  final List<String> _likedCategories = [];
  int _swipedCount = 0;

  final List<PreferenceSwiperCard> _cards = const [
    PreferenceSwiperCard(
      id: '1',
      title: 'El Djem Amphitheatre',
      category: 'MONUMENT',
      imageUrl: 'https://images.unsplash.com/photo-1589568058-a7e4f57bc1f8?auto=format&fit=crop&w=600',
      emoji: '🏛️',
    ),
    PreferenceSwiperCard(
      id: '2',
      title: 'Djerba Beaches',
      category: 'BEACH',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=600',
      emoji: '🏖️',
    ),
    PreferenceSwiperCard(
      id: '3',
      title: 'Sahara Desert',
      category: 'NATURE',
      imageUrl: 'https://images.unsplash.com/photo-1509316785289-025f5b846b35?auto=format&fit=crop&w=600',
      emoji: '🏜️',
    ),
    PreferenceSwiperCard(
      id: '4',
      title: 'Tunisian Couscous',
      category: 'FOOD',
      imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=600',
      emoji: '🍲',
    ),
    PreferenceSwiperCard(
      id: '5',
      title: 'Sidi Bou Said',
      category: 'CULTURE',
      imageUrl: 'https://images.unsplash.com/photo-1574482596549-33b0fd379d74?auto=format&fit=crop&w=600',
      emoji: '🎨',
    ),
    PreferenceSwiperCard(
      id: '6',
      title: 'Medina of Tunis',
      category: 'CULTURE',
      imageUrl: 'https://images.unsplash.com/photo-1591111544400-8ce2f3c5f7c2?auto=format&fit=crop&w=600',
      emoji: '🕌',
    ),
    PreferenceSwiperCard(
      id: '7',
      title: 'Scuba Diving in Tabarka',
      category: 'ADVENTURE',
      imageUrl: 'https://images.unsplash.com/photo-1682687220742-aba13b6e50ba?auto=format&fit=crop&w=600',
      emoji: '🤿',
    ),
    PreferenceSwiperCard(
      id: '8',
      title: 'Bulla Regia Ruins',
      category: 'MONUMENT',
      imageUrl: 'https://images.unsplash.com/photo-1569944991063-ab6c8f5b6a1d?auto=format&fit=crop&w=600',
      emoji: '🏺',
    ),
  ];

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  void _onSwiped(int previous, int current, CardSwiperDirection direction) {
    final card = _cards[previous];
    if (direction == CardSwiperDirection.right) {
      _likedCategories.add(card.category);
    }
    setState(() => _swipedCount = current);
  }

  void _onEnd() {
    // Here you'd call the User Service to save preferences
    // POST /api/users/preferences with { likedCategories: _likedCategories }
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('What do you love?', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'Swipe right on things you like, left to skip',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 15, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  // Progress dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _cards.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 6,
                        width: i == _swipedCount ? 24 : 6,
                        decoration: BoxDecoration(
                          color: i == _swipedCount ? const Color(0xFF1E1E1E) : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Swiper
            Expanded(
              child: CardSwiper(
                controller: _swiperController,
                cardsCount: _cards.length,
                onSwipe: (previousIndex, currentIndex, direction) {
                  _onSwiped(previousIndex, currentIndex ?? 0, direction);
                  return true;
                },
                onEnd: _onEnd,
                numberOfCardsDisplayed: 2,
                backCardOffset: const Offset(20, 20),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                cardBuilder: (context, index, _, __) {
                  final card = _cards[index];
                  return _buildCard(card);
                },
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 32, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Dislike
                  _buildActionButton(
                    onTap: () => _swiperController.swipe(CardSwiperDirection.left),
                    icon: Icons.close_rounded,
                    color: Colors.redAccent,
                    size: 56,
                  ),
                  // Skip
                  _buildActionButton(
                    onTap: () => context.go('/home'),
                    icon: Icons.skip_next_rounded,
                    color: Colors.grey,
                    size: 44,
                    label: 'Skip',
                  ),
                  // Like
                  _buildActionButton(
                    onTap: () => _swiperController.swipe(CardSwiperDirection.right),
                    icon: Icons.favorite_rounded,
                    color: const Color(0xFF1B6A45),
                    size: 56,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(PreferenceSwiperCard card) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: DecorationImage(
          image: NetworkImage(card.imageUrl),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
            stops: const [0.4, 1.0],
          ),
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.4)),
              ),
              child: Text(
                '${card.emoji}  ${card.category}',
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              card.title,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1.1),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.swipe_right, color: Colors.greenAccent, size: 20),
                const SizedBox(width: 6),
                Text('Swipe right if you love this', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
    required double size,
    String? label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: size * 0.45),
          ),
          if (label != null) ...[
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
          ],
        ],
      ),
    );
  }
}

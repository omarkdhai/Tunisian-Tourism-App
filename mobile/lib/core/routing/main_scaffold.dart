import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  static const List<String> _routes = ['/home', '/trips', '/map', '/search', '/profile'];
  static const List<IconData> _icons = [
    Icons.home_rounded,
    Icons.map_outlined,
    Icons.explore_outlined,
    Icons.search_rounded,
    Icons.person_outline_rounded,
  ];

  void _onTabTapped(BuildContext context, int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    // Sync selected index from current route
    final location = GoRouterState.of(context).uri.path;
    final routeIndex = _routes.indexOf(location);
    if (routeIndex >= 0 && routeIndex != _currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _currentIndex = routeIndex);
      });
    }

    return Scaffold(
      extendBody: true,
      body: widget.child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/ai-chat'),
        backgroundColor: const Color(0xFF1E1E1E),
        shape: const CircleBorder(),
        tooltip: 'AI Assistant',
        child: const Icon(Icons.auto_awesome, color: Colors.amberAccent),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            // Leave a gap in the center for FAB
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [0, 1].map((i) => _buildNavItem(i, context)).toList(),
                ),
              ),
              // Center spacer for FAB
              const SizedBox(width: 72),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [2, 3].map((i) => _buildNavItem(i, context)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, BuildContext context) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(context, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: isSelected
            ? const BoxDecoration(color: Colors.white, shape: BoxShape.circle)
            : null,
        child: Icon(
          _icons[index],
          color: isSelected ? const Color(0xFF1E1E1E) : Colors.white54,
          size: 26,
        ),
      ),
    );
  }
}

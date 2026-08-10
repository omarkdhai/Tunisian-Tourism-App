import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class GeneratingTripScreen extends StatefulWidget {
  const GeneratingTripScreen({super.key});

  @override
  State<GeneratingTripScreen> createState() => _GeneratingTripScreenState();
}

class _GeneratingTripScreenState extends State<GeneratingTripScreen> with SingleTickerProviderStateMixin {
  int _messageIndex = 0;
  final List<String> _messages = [
    'Analyzing travel preferences...',
    'Scanning top-rated spots in Tunisia...',
    'Calculating travel distances...',
    'Drafting your perfect itinerary...',
  ];

  late Timer _timer;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_messageIndex < _messages.length - 1) {
        setState(() {
          _messageIndex++;
        });
      } else {
        timer.cancel();
        // After "generation", redirect to the itinerary. In a real app we wait for the FutureProvider.
        Future.delayed(const Duration(seconds: 1), () {
           context.go('/trip-itinerary'); // Redirect to dummy itinerary
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotationTransition(
                turns: _animController,
                child: const Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 64),
              ),
              const SizedBox(height: 32),
              Text(
                'AI Magic in Progress',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _messages[_messageIndex],
                  key: ValueKey(_messageIndex),
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

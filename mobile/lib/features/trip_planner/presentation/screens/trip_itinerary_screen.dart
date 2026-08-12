import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TripItineraryScreen extends StatelessWidget {
  const TripItineraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text('Iconic Brazil', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Wed, Oct 21 - Sun, Nov 1', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTab('Tour schedule', true),
                      _buildTab('Accommodation', false),
                      _buildTab('Booking details', false),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text('8-Days Brazil Adventure', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                
                // Day 1
                _buildDayCard(
                  context, 
                  'Day 1', 
                  'Arrival to Rio de Janeiro', 
                  'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=crop&w=400',
                  expanded: true,
                ),
                const SizedBox(height: 16),
                // Day 2
                _buildDayCard(
                  context, 
                  'Day 2', 
                  'Rio de Janeiro Highlights', 
                  'https://images.unsplash.com/photo-1483729558449-99ef09a8c325?auto=format&fit=crop&w=400',
                  expanded: false,
                ),
                const SizedBox(height: 16),
                // Day 3
                _buildDayCard(
                  context, 
                  'Day 3', 
                  'Copacabana Beach', 
                  'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=400',
                  expanded: false,
                ),
              ],
            ),
          ),
          
          // Book Tour Button docked at bottom
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                'Book a tour',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, String day, String title, String imgUrl, {bool expanded = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(imgUrl, width: 70, height: 70, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(day, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12)),
                    Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey)
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 16),
            _buildTimelineItem('Morning', 'Arrive in Rio de Janeiro and transfer to your hotel'),
            _buildTimelineItem('Afternoon', 'Free time to relax or explore the nearby area'),
            _buildTimelineItem('Evening', 'Welcome dinner at a traditional Brazilian restaurant'),
          ]
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String time, String desc) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12)),
          const SizedBox(height: 4),
          Text(desc, style: GoogleFonts.inter(fontSize: 14)),
        ],
      ),
    );
  }
}

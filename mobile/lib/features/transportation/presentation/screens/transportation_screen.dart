import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class TransportOption {
  final String type;
  final String emoji;
  final String name;
  final String description;
  final String estimatedTime;
  final String estimatedCost;
  final Color color;

  const TransportOption({
    required this.type,
    required this.emoji,
    required this.name,
    required this.description,
    required this.estimatedTime,
    required this.estimatedCost,
    required this.color,
  });
}

class TransportationScreen extends StatefulWidget {
  final String? fromLocation;
  final String? toLocation;

  const TransportationScreen({super.key, this.fromLocation, this.toLocation});

  @override
  State<TransportationScreen> createState() => _TransportationScreenState();
}

class _TransportationScreenState extends State<TransportationScreen> {
  String _selectedType = '';

  final List<TransportOption> _options = const [
    TransportOption(
      type: 'CAR_RENTAL',
      emoji: '🚗',
      name: 'Car Rental',
      description: 'Freedom to explore at your own pace',
      estimatedTime: 'Flexible',
      estimatedCost: '60–120 TND/day',
      color: Color(0xFF6C63FF),
    ),
    TransportOption(
      type: 'TAXI',
      emoji: '🚕',
      name: 'Taxi',
      description: 'Door-to-door convenience',
      estimatedTime: '~35 min',
      estimatedCost: '15–25 TND',
      color: Color(0xFFFFBF69),
    ),
    TransportOption(
      type: 'PRIVATE_DRIVER',
      emoji: '🚙',
      name: 'Private Driver',
      description: 'Comfort with a personal guide',
      estimatedTime: '~30 min',
      estimatedCost: '80–150 TND/day',
      color: Color(0xFF1E1E1E),
    ),
    TransportOption(
      type: 'TRAIN',
      emoji: '🚆',
      name: 'Train (SNCFT)',
      description: 'Scenic and affordable',
      estimatedTime: '~1h 20min',
      estimatedCost: '4–12 TND',
      color: Color(0xFF43D9A2),
    ),
    TransportOption(
      type: 'BUS',
      emoji: '🚌',
      name: 'TRANSTU Bus',
      description: 'Budget-friendly city connections',
      estimatedTime: '~1h 45min',
      estimatedCost: '1–5 TND',
      color: Color(0xFFFF6584),
    ),
    TransportOption(
      type: 'LOUAGE',
      emoji: '🚐',
      name: 'Louage (Shared Taxi)',
      description: 'Fastest intercity option',
      estimatedTime: '~1h',
      estimatedCost: '6–15 TND',
      color: Color(0xFFFF8C42),
    ),
    TransportOption(
      type: 'WALKING',
      emoji: '🚶',
      name: 'Walking',
      description: 'Best for short distances in Medina',
      estimatedTime: '~20 min',
      estimatedCost: 'Free',
      color: Color(0xFF9B9B9B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => context.pop()),
        title: Text('Transportation', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Route card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 10, height: 10,
                        decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                      ),
                      Container(width: 2, height: 28, color: Colors.white30),
                      Container(
                        width: 10, height: 10,
                        decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.fromLocation ?? 'Your Current Location',
                            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text(widget.toLocation ?? 'El Djem Amphitheatre',
                            style: GoogleFonts.inter(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const Icon(Icons.swap_vert, color: Colors.white70),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('${_options.length} options available',
                    style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Options list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _options.length,
              itemBuilder: (context, index) {
                final opt = _options[index];
                final isSelected = _selectedType == opt.type;
                return GestureDetector(
                  onTap: () => setState(() => _selectedType = isSelected ? '' : opt.type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isSelected ? opt.color.withOpacity(0.08) : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isSelected ? opt.color : Colors.transparent,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            color: opt.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(child: Text(opt.emoji, style: const TextStyle(fontSize: 24))),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(opt.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 2),
                              Text(opt.description, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _buildBadge(Icons.access_time, opt.estimatedTime),
                                  const SizedBox(width: 8),
                                  _buildBadge(Icons.attach_money, opt.estimatedCost),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: opt.color, shape: BoxShape.circle),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Select Button
          if (_selectedType.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$_selectedType selected and added to your itinerary!'), backgroundColor: Colors.green),
                    );
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1E1E),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Confirm Transport', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey.shade500),
        const SizedBox(width: 3),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

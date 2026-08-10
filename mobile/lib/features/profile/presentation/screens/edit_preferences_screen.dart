import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../providers/profile_providers.dart';

class EditPreferencesScreen extends ConsumerStatefulWidget {
  const EditPreferencesScreen({super.key});

  @override
  ConsumerState<EditPreferencesScreen> createState() => _EditPreferencesScreenState();
}

class _EditPreferencesScreenState extends ConsumerState<EditPreferencesScreen> {
  String _travelerType = 'SOLO';
  int _numberOfTravelers = 1;
  String _preferredLanguage = 'EN';
  String _preferredCurrency = 'USD';
  final Set<String> _selectedCategories = {};

  final List<Map<String, String>> _categories = [
    {'id': 'BEACH', 'emoji': '🏖️', 'label': 'Beaches'},
    {'id': 'MONUMENT', 'emoji': '🏛️', 'label': 'Monuments'},
    {'id': 'CULTURE', 'emoji': '🕌', 'label': 'Culture'},
    {'id': 'FOOD', 'emoji': '🍴', 'label': 'Food'},
    {'id': 'SAHARA', 'emoji': '🏜️', 'label': 'Sahara'},
    {'id': 'NATURE', 'emoji': '🌿', 'label': 'Nature'},
    {'id': 'ACTIVITY', 'emoji': '🏄', 'label': 'Activities'},
    {'id': 'SHOPPING', 'emoji': '🛍️', 'label': 'Shopping'},
    {'id': 'NIGHTLIFE', 'emoji': '🌃', 'label': 'Nightlife'},
    {'id': 'ART', 'emoji': '🎨', 'label': 'Art'},
    {'id': 'ADVENTURE', 'emoji': '🧗', 'label': 'Adventure'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        title: Text('Travel Preferences', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => context.pop()),
        actions: [
          TextButton(
            onPressed: _savePreferences,
            child: Text('Save', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF1E1E1E), fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Traveler Type
            _buildSectionTitle('Traveler Mode'),
            const SizedBox(height: 12),
            Row(
              children: ['SOLO', 'COUPLE', 'FAMILY', 'GROUP'].map((type) {
                final icons = {'SOLO': '🧑', 'COUPLE': '👫', 'FAMILY': '👨‍👩‍👧', 'GROUP': '👥'};
                final isSelected = _travelerType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _travelerType = type),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? const Color(0xFF1E1E1E) : Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Text(icons[type] ?? '🧑', style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 4),
                          Text(type,
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : Colors.black87)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),
            _buildSectionTitle('Number of Travelers'),
            const SizedBox(height: 12),
            _buildCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Travelers', style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () { if (_numberOfTravelers > 1) setState(() => _numberOfTravelers--); },
                      ),
                      Text('$_numberOfTravelers', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => _numberOfTravelers++),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            _buildSectionTitle('Preferred Language'),
            const SizedBox(height: 12),
            _buildDropdown(
              value: _preferredLanguage,
              items: {'EN': '🇬🇧 English', 'FR': '🇫🇷 Français', 'AR': '🇸🇦 العربية', 'DE': '🇩🇪 Deutsch'},
              onChanged: (v) => setState(() => _preferredLanguage = v!),
            ),

            const SizedBox(height: 20),
            _buildSectionTitle('Preferred Currency'),
            const SizedBox(height: 12),
            _buildDropdown(
              value: _preferredCurrency,
              items: {'TND': 'TND — Tunisian Dinar', 'USD': 'USD — US Dollar', 'EUR': 'EUR — Euro', 'GBP': 'GBP — British Pound'},
              onChanged: (v) => setState(() => _preferredCurrency = v!),
            ),

            const SizedBox(height: 28),
            _buildSectionTitle('Interests'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _categories.map((cat) {
                final isSelected = _selectedCategories.contains(cat['id']);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) _selectedCategories.remove(cat['id']);
                      else _selectedCategories.add(cat['id']!);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: isSelected ? const Color(0xFF1E1E1E) : Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(cat['emoji']!, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(cat['label']!,
                            style: GoogleFonts.inter(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _savePreferences() {
    ref.read(userRepositoryProvider).updatePreferences({
      'travelerType': _travelerType,
      'numberOfTravelers': _numberOfTravelers,
      'preferredLanguage': _preferredLanguage,
      'preferredCurrency': _preferredCurrency,
      'preferredCategories': _selectedCategories.toList(),
    });
    ref.invalidate(myProfileProvider);
    context.pop();
  }

  Widget _buildSectionTitle(String title) =>
      Text(title, style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.bold));

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: child,
    );
  }

  Widget _buildDropdown({required String value, required Map<String, String> items, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(18),
          items: items.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

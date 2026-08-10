import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../providers/profile_providers.dart';
import '../../data/models/user_profile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myProfileProvider);

    return profileAsync.when(
      data: (profile) => _buildContent(context, ref, profile),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => _buildContent(context, ref, UserProfile(
        id: '', firstName: 'Visitor', lastName: '', email: 'visitor@example.com',
      )),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, UserProfile profile) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: profile.avatarUrl != null
                            ? NetworkImage(profile.avatarUrl!)
                            : null,
                        backgroundColor: Colors.white24,
                        child: profile.avatarUrl == null
                            ? Text(profile.firstName.isNotEmpty ? profile.firstName[0] : 'U',
                                style: GoogleFonts.inter(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold))
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(profile.fullName,
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(profile.email,
                          style: GoogleFonts.inter(color: Colors.white60, fontSize: 14)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatChip('${profile.numberOfTravelers}', 'Travelers'),
                          _buildStatChip(profile.travelerType, 'Mode'),
                          _buildStatChip(profile.preferredCurrency, 'Currency'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Preferred Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Interests', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: profile.preferredCategories.isNotEmpty
                        ? profile.preferredCategories.map((c) => _buildCategoryChip(c)).toList()
                        : [Text('No preferences set yet.', style: GoogleFonts.inter(color: Colors.grey))],
                  ),

                  const SizedBox(height: 28),
                  Text('Account Settings', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  _buildSettingTile(
                    context,
                    icon: Icons.person_outline,
                    label: 'Edit Profile',
                    onTap: () => context.push('/edit-profile'),
                  ),
                  _buildSettingTile(
                    context,
                    icon: Icons.tune,
                    label: 'Travel Preferences',
                    onTap: () => context.push('/edit-preferences'),
                  ),
                  _buildSettingTile(
                    context,
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () => context.push('/notifications'),
                  ),
                  _buildSettingTile(
                    context,
                    icon: Icons.language,
                    label: 'Language: ${profile.preferredLanguage}',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    context,
                    icon: Icons.attach_money,
                    label: 'Currency: ${profile.preferredCurrency}',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    context,
                    icon: Icons.favorite_outline,
                    label: 'Saved Places',
                    onTap: () {},
                  ),
                  _buildSettingTile(
                    context,
                    icon: Icons.history,
                    label: 'Travel History',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/login'),
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                      label: Text('Sign Out',
                          style: GoogleFonts.inter(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(color: Colors.white60, fontSize: 11)),
      ],
    );
  }

  Widget _buildCategoryChip(String category) {
    final Map<String, String> icons = {
      'BEACH': '🏖️', 'MONUMENT': '🏛️', 'CULTURE': '🕌', 'FOOD': '🍴',
      'SAHARA': '🏜️', 'NATURE': '🌿', 'ADVENTURE': '🧗', 'SHOPPING': '🛍️',
      'NIGHTLIFE': '🌃', 'ART': '🎨', 'ACTIVITY': '🏄',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text('${icons[category] ?? '✨'} $category',
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildSettingTile(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1E1E1E), size: 22),
            const SizedBox(width: 14),
            Text(label, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Hero image top half
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1574482596549-33b0fd379d74?auto=format&fit=crop&w=800',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.55)],
                    ),
                  ),
                  padding: const EdgeInsets.all(28),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tunisia', style: GoogleFonts.inter(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                      Text('Sidi Bou Said', style: GoogleFonts.inter(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom login panel
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome to', style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade600)),
                    Text('TunTrip', style: GoogleFonts.inter(fontSize: 34, fontWeight: FontWeight.bold, color: const Color(0xFF111827))),
                    const SizedBox(height: 8),
                    Text(
                      'Discover Tunisia like never before.\nPersonalized trips powered by AI.',
                      style: GoogleFonts.inter(fontSize: 15, color: Colors.grey.shade500, height: 1.5),
                    ),
                    const Spacer(),
                    // Login with Google
                    _buildSocialButton(
                      onTap: () => context.push('/preference-swipe'),
                      label: 'Continue with Google',
                      icon: '🔍',
                      bgColor: Colors.white,
                      textColor: const Color(0xFF111827),
                      hasBorder: true,
                    ),
                    const SizedBox(height: 12),
                    // Login with Apple
                    _buildSocialButton(
                      onTap: () => context.push('/preference-swipe'),
                      label: 'Continue with Apple',
                      icon: '🍎',
                      bgColor: const Color(0xFF111827),
                      textColor: Colors.white,
                      hasBorder: false,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () => context.go('/home'),
                        child: Text(
                          'Skip for now →',
                          style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14, decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    required String label,
    required String icon,
    required Color bgColor,
    required Color textColor,
    required bool hasBorder,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30),
          border: hasBorder ? Border.all(color: Colors.grey.shade300) : null,
          boxShadow: hasBorder
              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Text(label, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const Color backgroundTop = Color(0xFFEAF6FC);
  static const Color backgroundBottom = Color(0xFFF8FCFE);

  static const Color textDark = Color(0xFF222222);
  static const Color textGrey = Color(0xFF777777);
  static const Color textLightGrey = Color(0xFFA0A0A0);

  static const Color primaryBlue = Color(0xFF079BEF);
  static const Color borderColor = Color(0xFFE9EDF0);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundTop, backgroundBottom, Colors.white],
            stops: [0.0, 0.45, 1.0],
          ),
        ),

        child: Stack(
          children: [
            // =========================
            // TOP VIDEO SECTION
            // =========================
            //
            // This area is intentionally empty.
            //
            // Later you can replace this section with:
            //
            // VideoPlayer(controller)
            //
            // The authentication card will remain
            // over the bottom part of the screen.
            //

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenHeight * 0.43,
              child: const SizedBox(),
            ),

            // =========================
            // AUTH CARD
            // =========================
            Align(
              alignment: Alignment.bottomCenter,
              child: _AuthCard(),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// AUTH CARD
// ============================================================

class _AuthCard extends StatelessWidget {
  const _AuthCard();

  static const Color textDark = Color(0xFF222222);
  static const Color textGrey = Color(0xFF777777);
  static const Color textLightGrey = Color(0xFFA0A0A0);

  static const Color primaryBlue = Color(0xFF079BEF);
  static const Color borderColor = Color(0xFFE9EDF0);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Keep the card close to the reference proportions
    final cardWidth = screenWidth > 500 ? 420.0 : screenWidth - 20;

    return Container(
      width: cardWidth,

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),

        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 30,
            spreadRadius: 0,
            offset: Offset(0, -5),
          ),
        ],
      ),

      child: SafeArea(
        top: false,

        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // =================================================
              // DRAG HANDLE
              // =================================================

              Container(
                width: 45,
                height: 4,

                decoration: BoxDecoration(
                  color: const Color(0xFFE1E3E5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 30),

              // =================================================
              // WELCOME TO
              // =================================================

              Text(
                'Welcome to',
                textAlign: TextAlign.center,

                style: GoogleFonts.barlowCondensed(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: textDark,
                  height: 1,
                ),
              ),

              const SizedBox(height: 1),

              // =================================================
              // TUNISIA
              // =================================================

              Text(
                'Tunisia',
                textAlign: TextAlign.center,

                style: GoogleFonts.barlowCondensed(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: textDark,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 18),

              // =================================================
              // DESCRIPTION
              // =================================================

              Text(
                'Discover the vibrant energy of the\n'
                'coast and the warmth of the Sahara.',

                textAlign: TextAlign.center,

                style: GoogleFonts.barlowCondensed(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: textLightGrey,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 28),

              // =================================================
              // CREATE ACCOUNT BUTTON
              // =================================================

              SizedBox(
                width: double.infinity,
                height: 41,

                child: ElevatedButton(
                  onPressed: () {
                    context.push('/preference-swipe');
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,

                    elevation: 0,

                    padding: EdgeInsets.zero,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    shadowColor: Colors.transparent,
                  ),

                  child: Text(
                    'Create Account',

                    style: GoogleFonts.barlowCondensed(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // =================================================
              // OR SIGN IN WITH
              // =================================================

              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: Color(0xFFECEFF1),
                      thickness: 1,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),

                    child: Text(
                      'Or sign in with',

                      style: GoogleFonts.barlowCondensed(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: textLightGrey,
                      ),
                    ),
                  ),

                  const Expanded(
                    child: Divider(
                      color: Color(0xFFECEFF1),
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // =================================================
              // SOCIAL BUTTONS
              // =================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialButton(
                    child: SvgPicture.asset(
                      'assets/icons/google.svg',
                      width: 19,
                      height: 19,
                    ),

                    onTap: () {
                      context.push('/preference-swipe');
                    },
                  ),

                  const SizedBox(width: 12),

                  _SocialButton(
                    child: SvgPicture.asset(
                      'assets/icons/apple.svg',
                      width: 19,
                      height: 19,
                    ),

                    onTap: () {
                      context.push('/preference-swipe');
                    },
                  ),

                  const SizedBox(width: 12),

                  _SocialButton(
                    child: SvgPicture.asset(
                      'assets/icons/facebook.svg',
                      width: 19,
                      height: 19,
                    ),

                    onTap: () {
                      context.push('/preference-swipe');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // =================================================
              // LOGIN
              // =================================================

              GestureDetector(
                onTap: () {
                  context.go('/home');
                },

                child: RichText(
                  textAlign: TextAlign.center,

                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',

                        style: GoogleFonts.barlowCondensed(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: textGrey,
                        ),
                      ),

                      TextSpan(
                        text: 'Log in',

                        style: GoogleFonts.barlowCondensed(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SOCIAL BUTTON
// ============================================================

class _SocialButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _SocialButton({
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 62,
        height: 42,

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(13),

          border: Border.all(
            color: const Color(0xFFE9EDF0),
            width: 1,
          ),

          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 7,
              offset: Offset(0, 2),
            ),
          ],
        ),

        child: Center(
          child: child,
        ),
      ),
    );
  }
}
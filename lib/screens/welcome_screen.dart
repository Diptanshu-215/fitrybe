import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth_screens.dart';

class SlideData {
  final String imageUrl;
  final String topText;
  final String bottomText;

  const SlideData({
    required this.imageUrl,
    required this.topText,
    required this.bottomText,
  });
}

const List<SlideData> _slides = [
  SlideData(
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBSd0rXxt8GHv-Q01707zsHFQAuI1ALEnvWFQ9dXFXnJ6p3oX35X5QQpIOPkh9tqD346Sw8HkV3GVqz-QDHgkusK159R_w_vSe0AxhSyq2GRLPtt_GFbQJlKDgVzlV-RtLWwZolBHPGBUbCCr47GR83ThHq0CyQGCGqeiNJPqhZnq8hYzVRg78KsoCIFJU7Er3kJcaVBOxf2X-SakUL6fMWLc-pSTr2O1LW8ug-a7dvoE1SsV_XbpGQ=w1200',
    topText: 'MOVE',
    bottomText: 'TOGETHER',
  ),
  SlideData(
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDyqgWQlDw1nMRG6EDTVxMDeH0eOe8r4kXBJ0fWBZmYUed5-6lDDPOxhiYriWkGA_1G9o90BeFU0PKebULY5KVAk4YHZK9pxM4aFU94jK225Tptdz7uUNKlNrX9kRuNreggew2XMzmydam6cOBnQlL-oQ7EcINyvx-X-rRR9Cl2E7u79XlwEcxlw-jM9Vgi7KzrqzlnPmbcmBNsFU6G27iHo2xfYS9i7KB4fHaRg96JJMmnoUz_JJqk=w1200',
    topText: 'ACHIEVE',
    bottomText: 'MORE',
  ),
  SlideData(
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAG-I53lPR_TQCxt3QpPlZQ7G_4ag7mXlEOSRY6CjxcBW3KPwOGwf9CgSC0B8MdgOeJTqD7JWgS9c8Ynd0mIXglk1Kts3VbUjzU5QnuqnoluPZHx_ZuydGWeiuMsS1A4UsSZd3-13ZFbOFq1D_MAxGpzA_neNrbvwszKQk3HJoiIbj-TLroG3pNEbrWzr3H0AMLzpPJrbGKAwr7EVJd5UxZ5EZ2h-BqCnHyerjEycv3N-diXxcpq8Lu=w1200',
    topText: 'FIND YOUR',
    bottomText: 'TRYBE',
  ),
  SlideData(
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAnWKP9VdFd4mjBTFmwQTeQu0dic1hQONcaIHWwxWPUuT_SIy30pAqlOyrY3Pp6viutD6l9FVamL-ukyzZuwB3Y60NQmYBK61WFKMvH9q5fi0DksF77RBA62aUWjp5pEAq0aSqFkoeG0EXebJt5jWQTNigdR6vrDcu9bMFRF5CxWsfNLEqewGBi8rfbYh2po1jktucknCBbFIvJqjUoxCIXwFA_IINcrR51BG3Gqt1bqAS-TMKEjMA2=w1200',
    topText: 'PUSH YOUR',
    bottomText: 'LIMITS',
  ),
];

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  int _currentSlide = 0;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _currentSlide = (_currentSlide + 1) % _slides.length;
          });
          _progressController.reset();
          _progressController.forward();
        }
      }
    });

    _progressController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache network images for smooth slide transitions without visual flicker
    for (var slide in _slides) {
      precacheImage(
        NetworkImage(slide.imageUrl),
        context,
        onError: (error, stack) {
          // Suppress network errors during tests/offline
        },
      );
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Cinematic Background Image Carousel (Cross-fading)
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1500),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Image.network(
                _slides[_currentSlide].imageUrl,
                key: ValueKey<int>(_currentSlide),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF131316),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.fitness_center_rounded,
                      color: Color(0xFFFF5722),
                      size: 80,
                    ),
                  );
                },
              ),
            ),
          ),

          // 2. Cinematic Vignette & Bottom/Top Gradient Overlays
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66131316),
                    Color(0xE6131316),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    Colors.transparent,
                    Color(0xCC131316),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),

          // 3. Main Interface Layer
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header (Top Brand Bar)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/fitrybe-mark.svg',
                        height: 32,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFF5722),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/images/fitrybe-wordmark-white.svg',
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Animated Main Headline Text (Slide-up & Fade-in transition)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      transitionBuilder: (child, animation) {
                        final slideIn = Tween<Offset>(
                          begin: const Offset(0.0, 0.3),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: const Cubic(0.2, 1.0, 0.3, 1.0),
                        ));
                        return SlideTransition(
                          position: slideIn,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        key: ValueKey<int>(_currentSlide),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _slides[_currentSlide].topText,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.anybody(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF5722),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _slides[_currentSlide].bottomText,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.anybody(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -1.0,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Actions Container at bottom (Constrained & Centered for responsive layout)
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 40.0),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Progress Indicators (Dot carousel indicators)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_slides.length, (index) {
                              final isActive = index == _currentSlide;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: isActive ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF353438),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: isActive
                                    ? AnimatedBuilder(
                                        animation: _progressController,
                                        builder: (context, child) {
                                          return Align(
                                            alignment: Alignment.centerLeft,
                                            child: FractionallySizedBox(
                                              widthFactor: _progressController.value,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFF5722),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : null,
                              );
                            }),
                          ),
                          const SizedBox(height: 24),

                           // Buttons Layout
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text('Join Us'),
                          ),
                          const SizedBox(height: 12),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0x992D3238),
                              foregroundColor: Colors.white,
                              elevation: 0,
                            ),
                            child: const Text('Log In'),
                          ),
                          const SizedBox(height: 16),

                          // Terms of Service Legal text
                          Text(
                            'By continuing you agree to our Terms of Service',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

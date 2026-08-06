import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final Color _accent = const Color(0xFFFF5722);
  final Color _cardBg = const Color(0xFF1F1F22);
  final Color _bg = const Color(0xFF131316);

  // Profile fields controllers
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  // Mock URLs matching ProfileTab
  final String _bannerUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuB6TPeMuX0LW4ItpQWypk7_L5uUJEXStbcwTo0u6Qh2iiaJAnM_gvOKAwZHOjmQQrYYN3ryuR96W3O6yy0NClyBiDzgbW7GehFko-vrnjWLAvO_VeKAi-ixSqLJazJ2rsV7TnPyPq6GNsIRv0J7rXJg24hBRNgAAH5omJcCclVTJ1X7ODm1ZXjf8EqafkBDPwWz6P9rP61AW5nEe8yUMyOy6GEu8aN2Uh6B2l_2fK3GsYKCN4Mhu1rf';
  final String _avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAHT0fSiT-tBM9-LHbHVlF65CZIgyCqn-DoDUSl05Y0gcWZ5GDqFvUrdutx26mNY5DtnE0ZpijRovfDxUuDLTu5hStbuDoEqMg95eZOlGU7rLLNjJ0EvPXvLs18QfqyMuOb-lgEkqg4Ybw2FlQVeIXwhwd8mUkP3SpCWEUMQnuUuHL2ac9TI_c2sG5wyicbvZ1rz7TuvQ74aVOFymH_WjY3EuexlU6cz0GhX0Kb_z1JbXHSiQhULIuH';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Alex Thorne');
    _bioController = TextEditingController(
        text: 'Pushing limits. Ultra-runner & Calisthenics enthusiast. Chasing the next PR.');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.anybody(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: _accent,
                  content: Text(
                    'Profile settings updated successfully!',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: GoogleFonts.hankenGrotesk(
                color: _accent,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner & Avatar stack with Edit buttons
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Banner background
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 160,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Opacity(
                          opacity: 0.4,
                          child: Image.network(
                            _bannerUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Black overlay gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                _bg.withValues(alpha: 0.8),
                                _bg,
                              ],
                            ),
                          ),
                        ),
                        // Camera overlay button for cover photo
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Change Cover',
                                    style: GoogleFonts.hankenGrotesk(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
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

                  // Avatar
                  Positioned(
                    bottom: 0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _bg, width: 4),
                            image: DecorationImage(
                              image: NetworkImage(_avatarUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.4),
                              border: Border.all(color: _bg, width: 4),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Profile Input Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Display Name'),
                  _buildTextField(_nameController, Icons.person_outline_rounded, 'Enter display name'),
                  const SizedBox(height: 20),

                  _buildLabel('Bio'),
                  _buildTextField(
                    _bioController,
                    Icons.text_fields_rounded,
                    'Tell us about yourself...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        label,
        style: GoogleFonts.hankenGrotesk(
          color: Colors.white54,
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    IconData icon,
    String hint, {
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      style: GoogleFonts.hankenGrotesk(
        color: readOnly ? Colors.white38 : Colors.white,
        fontSize: 14.5,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.hankenGrotesk(color: Colors.white30),
        prefixIcon: Icon(icon, color: readOnly ? Colors.white24 : Colors.white38, size: 20),
        suffixIcon: readOnly
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.gps_fixed_rounded, color: Colors.white24, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Auto',
                      style: GoogleFonts.hankenGrotesk(color: Colors.white24, fontSize: 11),
                    ),
                  ],
                ),
              )
            : null,
        filled: true,
        fillColor: readOnly ? _cardBg.withValues(alpha: 0.3) : _cardBg.withValues(alpha: 0.6),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.03)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _accent.withValues(alpha: 0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

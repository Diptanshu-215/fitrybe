import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/achievement_model.dart';

/// Renders one Fitrybe achievement badge.
///
/// The artwork lives in `assets/badges/<id>.svg` — one file per achievement,
/// generated from the design source. Each file has a 120x128 viewBox where the
/// badge frame occupies the middle 104 units; the small surrounding margin
/// carries the outer glow and the legendary ray burst. [size] means *the
/// frame*, so a `size: 76` badge lays out in an 88x94 box.
///
/// pubspec.yaml:
/// ```yaml
/// dependencies:
///   flutter_svg: ^2.0.10
/// flutter:
///   assets:
///     - assets/badges/
/// ```
class AchievementBadgeWidget extends StatefulWidget {
  const AchievementBadgeWidget({
    super.key,
    required this.badge,
    this.size = 76,
    this.showLabel = true,
    this.showStatusText = true,
    this.onTap,
    this.labelColor,
    this.dropShadow = true,
  });

  final AchievementBadge badge;

  /// Diameter of the badge *frame*. The artwork box drawn is larger than this
  /// so break-out elements are not clipped.
  final double size;

  final bool showLabel;
  final bool showStatusText;
  final VoidCallback? onTap;
  final Color? labelColor;
  final bool dropShadow;

  @override
  State<AchievementBadgeWidget> createState() => _AchievementBadgeWidgetState();
}

class _AchievementBadgeWidgetState extends State<AchievementBadgeWidget> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final b = widget.badge;
    final unlocked = b.unlocked;

    final art = AchievementBadgeArt(
      badgeId: b.id,
      size: widget.size,
      locked: !unlocked,
      dropShadow: widget.dropShadow,
    );

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        art,
        if (widget.showLabel) ...[
          const SizedBox(height: 2),
          Text(
            b.name.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.hankenGrotesk(
              color: widget.labelColor ??
                  (unlocked ? const Color(0xFFCFD5DF) : const Color(0xFF6A717C)),
              fontSize: 9.5,
              height: 1.3,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
        ],
        if (widget.showStatusText) ...[
          const SizedBox(height: 3),
          Text(
            unlocked ? 'UNLOCKED' : 'LOCKED',
            style: GoogleFonts.hankenGrotesk(
              color: unlocked ? const Color(0xFF5FD08C) : const Color(0xFF4C535E),
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );

    if (widget.onTap == null) return column;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap!.call();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: column,
      ),
    );
  }
}

/// The artwork on its own — no label, no gesture. Use this inside detail
/// sheets, toasts and unlock animations.
class AchievementBadgeArt extends StatelessWidget {
  const AchievementBadgeArt({
    super.key,
    required this.badgeId,
    this.size = 76,
    this.locked = false,
    this.dropShadow = true,
  });

  final String badgeId;
  final double size;
  final bool locked;
  final bool dropShadow;

  /// artwork viewBox (120 x 128) relative to the frame (104 wide).
  static const double _boxW = 120 / 104;
  static const double _boxH = 128 / 104;

  static String assetFor(String id) => 'assets/badges/$id.svg';

  /// Warm the SVG cache so the first scroll through the grid does not stutter.
  /// Call once, e.g. from `initState` of the achievements screen.
  static Future<void> precache(Iterable<String> badgeIds) async {
    for (final id in badgeIds) {
      try {
        final loader = SvgAssetLoader(assetFor(id));
        await svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
      } catch (_) {
        // a missing or unreadable asset must never block the screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = size * _boxW;
    final h = size * _boxH;

    Widget picture = SvgPicture.asset(
      assetFor(badgeId),
      width: w,
      height: h,
      fit: BoxFit.contain,
      placeholderBuilder: (_) => SizedBox(width: w, height: h),
    );

    if (dropShadow && !locked) {
      picture = Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: Offset(0, size * 0.07),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: size * 0.09, sigmaY: size * 0.09),
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(Color(0x8C000000), BlendMode.srcATop),
                child: SvgPicture.asset(
                  assetFor(badgeId),
                  width: w,
                  height: h,
                  fit: BoxFit.contain,
                  placeholderBuilder: (_) => SizedBox(width: w, height: h),
                ),
              ),
            ),
          ),
          picture,
        ],
      );
    }

    if (locked) {
      picture = Opacity(
        opacity: _lockedOpacity,
        child: ColorFiltered(colorFilter: _lockedFilter, child: picture),
      );
    }

    return SizedBox(width: w, height: h, child: picture);
  }

  // ---- locked treatment ---------------------------------------------------
  // The pin goes unlit: the orange enamel drains to grey and the metal dims.
  // The mark is still fully legible, so you can see what you are chasing —
  // it just has no colour in it yet.
  static const double _lockedSaturation = 0.05;
  static const double _lockedBrightness = 0.60;
  static const double _lockedContrast = 1.05;
  static const double _lockedOpacity = 0.85;

  static final ColorFilter _lockedFilter = _buildFilter(
    saturation: _lockedSaturation,
    brightness: _lockedBrightness,
    contrast: _lockedContrast,
  );

  static ColorFilter _buildFilter({
    required double saturation,
    required double brightness,
    required double contrast,
  }) {
    // luminance weights (same as the CSS `saturate()` filter)
    const lr = 0.213, lg = 0.715, lb = 0.072;
    final k = brightness * contrast;
    final o = (0.5 - 0.5 * contrast) * 255.0;

    double sr(double lum) => ((1 - saturation) * lum) * k;
    final rr = ((1 - saturation) * lr + saturation) * k;
    final gg = ((1 - saturation) * lg + saturation) * k;
    final bb = ((1 - saturation) * lb + saturation) * k;

    return ColorFilter.matrix(<double>[
      rr,      sr(lg), sr(lb), 0, o,
      sr(lr),  gg,     sr(lb), 0, o,
      sr(lr),  sr(lg), bb,     0, o,
      0,       0,      0,      1, 0,
    ]);
  }
}

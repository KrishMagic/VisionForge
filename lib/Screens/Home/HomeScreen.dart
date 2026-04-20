import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _triggerSOS(BuildContext context) {
    HapticFeedback.heavyImpact();
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(
          'Emergency SOS',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.5),
        ),
        content: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Are you sure you want to broadcast your location to emergency services?',
            style: TextStyle(height: 1.3),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              'Cancel',
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text(
              'Send SOS',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              HapticFeedback.vibrate();
              Navigator.pop(context);
              // Handle SOS logic
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensuring a deep OLED black base
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AppBar(
              backgroundColor: Colors.white.withOpacity(0.02),
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PremiumInteractiveButton(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                    child: const Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              title: const Text(
                'Map View',
                style: TextStyle(
                  fontFamily:
                      '.SF Pro Display', // Defaults to system sans-serif
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Premium Map Background
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0C0C0E), // Very dark charcoal
              child: CustomPaint(
                painter: MapGridPainter(),
                child: const SizedBox.expand(),
              ),
            ),
          ),

          // Deep Gradient overlay to blend the bottom
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Color(0x88000000),
                    Color(0xFF000000), // Solid black at the bottom
                  ],
                  stops: [0.0, 0.5, 0.75, 1.0],
                ),
              ),
            ),
          ),

          // Glowing Apple-style Location Pin
          const Center(child: PulsatingLocationDot()),

          // Top "Track Me" glassmorphic button
          Positioned(
            top: 120, // Adjusted for safe area & app bar
            left: 0,
            right: 0,
            child: Center(
              child: PremiumInteractiveButton(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF1C1C1E),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      content: const Text(
                        'Tracking active',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.location_fill,
                            color: Colors.white.withOpacity(0.9),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Track Me',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Premium SOS Button
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: PremiumInteractiveButton(
                onTap: () => _triggerSOS(context),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFB20A2C), // Deep Crimson
                        Color(0xFFE50000), // Vibrant Red
                        Color(0xFFFF3B30), // Bright Orange-Red (Apple Red)
                      ],
                    ),
                    boxShadow: [
                      // Tight shadow for depth
                      BoxShadow(
                        color: const Color(0xFFE50000).withOpacity(0.6),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                      // Wide ambient glow
                      BoxShadow(
                        color: const Color(0xFFFF3B30).withOpacity(0.3),
                        blurRadius: 40,
                        offset: const Offset(0, 0),
                        spreadRadius: 12,
                      ),
                      // Inner highlight emulation (via subtle white shadow)
                      BoxShadow(
                        color: Colors.white.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(-2, -2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.exclamationmark_triangle_fill,
                          color: Colors.white.withOpacity(0.95),
                          size: 32,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// COMPONENT: Pulsating Location Pin
// ---------------------------------------------------------
class PulsatingLocationDot extends StatefulWidget {
  const PulsatingLocationDot({super.key});

  @override
  State<PulsatingLocationDot> createState() => _PulsatingLocationDotState();
}

class _PulsatingLocationDotState extends State<PulsatingLocationDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(
              0xFF0A84FF,
            ).withOpacity(_animation.value * 0.2), // Apple Blue Glow
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF0A84FF,
                ).withOpacity(_animation.value * 0.4),
                blurRadius: 20 * _animation.value,
                spreadRadius: 8 * _animation.value,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0A84FF),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ), // Crisp white border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------
// COMPONENT: Apple-Style Bouncing Scale Button
// ---------------------------------------------------------
class PremiumInteractiveButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const PremiumInteractiveButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<PremiumInteractiveButton> createState() =>
      _PremiumInteractiveButtonState();
}

class _PremiumInteractiveButtonState extends State<PremiumInteractiveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: widget.child,
      ),
    );
  }
}

// ---------------------------------------------------------
// COMPONENT: High-End Radar Map Grid Painter
// ---------------------------------------------------------
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Ultra subtle strokes for minimalist aesthetic
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final majorRoadPaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Draw grid lines (minor roads)
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadPaint);
    }

    // Draw major roads
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      majorRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      majorRoadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.35),
      Offset(size.width, size.height * 0.35),
      majorRoadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.65),
      Offset(size.width, size.height * 0.65),
      majorRoadPaint,
    );

    // Draw a diagonal road
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width * 0.5, size.height * 0.5),
      majorRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width * 0.5, size.height * 0.5),
      majorRoadPaint,
    );

    // Draw subtle abstract blocks (buildings)
    final blockPaint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.fill;

    final blocks = [
      Rect.fromLTWH(size.width * 0.05, size.height * 0.05, 60, 40),
      Rect.fromLTWH(size.width * 0.5, size.height * 0.1, 80, 50),
      Rect.fromLTWH(size.width * 0.75, size.height * 0.4, 50, 60),
      Rect.fromLTWH(size.width * 0.1, size.height * 0.7, 70, 45),
      Rect.fromLTWH(size.width * 0.55, size.height * 0.72, 65, 55),
    ];

    for (final block in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          block,
          const Radius.circular(8),
        ), // Softer building edges
        blockPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

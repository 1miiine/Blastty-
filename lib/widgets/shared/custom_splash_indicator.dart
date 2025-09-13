// lib/widgets/shared/custom_splash_indicator.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import '../../../theme/colors.dart'; // Import mainBlue

/// A widget displaying the custom MYbarbers SVG with a continuous spinning animation.
/// Used primarily as a global loading/splash indicator.
class CustomSplashIndicator extends StatefulWidget {
  /// The size of the SVG icon.
  final double size;

  /// The color to tint the SVG.
  final Color color;

  /// The duration of one full rotation cycle.
  final Duration duration;

  const CustomSplashIndicator({
    super.key,
    this.size = 100.0,
    this.color = mainBlue, // Defaults to the app's main blue color
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<CustomSplashIndicator> createState() => _CustomSplashIndicatorState();
}

class _CustomSplashIndicatorState extends State<CustomSplashIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller to repeat indefinitely
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
    // Define the animation: rotate from 0 to 2*pi radians (full circle)
    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use RotationTransition to apply the animated rotation value
    return RotationTransition(
      turns: _animation,
      child: SvgPicture.asset(
        'assets/svg/MYbarbers.svg', // Ensure this path matches your asset
        width: widget.size,
        height: widget.size,
        colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn), // Apply color
      ),
    );
  }
}
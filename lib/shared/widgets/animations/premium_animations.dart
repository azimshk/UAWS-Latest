import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/theme/app_theme.dart';

/// Premium animation utilities for sophisticated micro-interactions
class PremiumAnimations {
  /// Elegant fade-in animation with scale
  static Widget fadeInScale({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? delay,
    double fromScale = 0.95,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? AppTheme.mediumAnimation,
      curve: curve ?? AppTheme.premiumCurve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: fromScale + (1.0 - fromScale) * value,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  /// Sophisticated slide-in animation
  static Widget slideIn({
    required Widget child,
    SlideDirection direction = SlideDirection.bottom,
    Duration? duration,
    Curve? curve,
    double distance = 50.0,
  }) {
    late Offset beginOffset;

    switch (direction) {
      case SlideDirection.top:
        beginOffset = Offset(0, -distance);
        break;
      case SlideDirection.bottom:
        beginOffset = Offset(0, distance);
        break;
      case SlideDirection.left:
        beginOffset = Offset(-distance, 0);
        break;
      case SlideDirection.right:
        beginOffset = Offset(distance, 0);
        break;
    }

    return TweenAnimationBuilder<Offset>(
      duration: duration ?? AppTheme.mediumAnimation,
      curve: curve ?? AppTheme.smoothCurve,
      tween: Tween(begin: beginOffset, end: Offset.zero),
      builder: (context, offset, child) {
        return Transform.translate(offset: offset, child: child);
      },
      child: child,
    );
  }

  /// Premium shimmer loading effect
  static Widget shimmer({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
    Duration? duration,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
      tween: Tween(begin: -2.0, end: 2.0),
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor ?? AppTheme.surfaceContainer,
                highlightColor ?? AppTheme.surfaceElevated,
                baseColor ?? AppTheme.surfaceContainer,
              ],
              stops: [
                (value - 1.0).clamp(0.0, 1.0),
                value.clamp(0.0, 1.0),
                (value + 1.0).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }

  /// Bounce effect for button interactions
  static Widget bounceTouch({
    required Widget child,
    VoidCallback? onTap,
    double scale = 0.95,
    Duration? duration,
  }) {
    return _BounceTouch(
      onTap: onTap,
      scale: scale,
      duration: duration ?? AppTheme.fastAnimation,
      child: child,
    );
  }

  /// Floating animation for cards and containers
  static Widget floating({
    required Widget child,
    Duration? duration,
    double amplitude = 4.0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? const Duration(seconds: 3),
      curve: Curves.easeInOut,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        final animationValue = (value * 2 * math.pi); // Full circle
        final offset = Offset(0, amplitude * math.sin(animationValue));

        return Transform.translate(offset: offset, child: child);
      },
      child: child,
    );
  }

  /// Reveal animation for cards
  static Widget revealCard({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? AppTheme.slowAnimation,
      curve: curve ?? AppTheme.premiumCurve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              child!,
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        AppTheme.surfaceColor,
                        AppTheme.surfaceColor,
                        Colors.transparent,
                      ],
                      stops: [0.0, value - 0.3, value, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }

  /// Staggered animation for lists
  static Widget staggeredList({
    required List<Widget> children,
    Duration? staggerDelay,
    Duration? itemDuration,
    Curve? curve,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        final delay =
            (staggerDelay ?? const Duration(milliseconds: 100)) * index;

        return TweenAnimationBuilder<double>(
          duration: (itemDuration ?? AppTheme.mediumAnimation) + delay,
          curve: curve ?? AppTheme.smoothCurve,
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            final animationValue =
                (value -
                        (delay.inMilliseconds /
                            ((itemDuration ?? AppTheme.mediumAnimation) + delay)
                                .inMilliseconds))
                    .clamp(0.0, 1.0);

            return Transform.translate(
              offset: Offset(0, 30 * (1 - animationValue)),
              child: Opacity(opacity: animationValue, child: child),
            );
          },
          child: child,
        );
      }).toList(),
    );
  }

  /// Premium pulse animation for notifications
  static Widget pulse({
    required Widget child,
    Duration? duration,
    double minScale = 0.98,
    double maxScale = 1.02,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? const Duration(seconds: 2),
      curve: Curves.easeInOut,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        final scale =
            minScale +
            (maxScale - minScale) * (0.5 + 0.5 * math.sin(value * 2 * math.pi));

        return Transform.scale(scale: scale, child: child);
      },
      child: child,
    );
  }
}

enum SlideDirection { top, bottom, left, right }

/// Private widget for bounce touch interaction
class _BounceTouch extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;

  const _BounceTouch({
    required this.child,
    this.onTap,
    required this.scale,
    required this.duration,
  });

  @override
  State<_BounceTouch> createState() => _BounceTouchState();
}

class _BounceTouchState extends State<_BounceTouch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scale).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.premiumCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Premium page transition builder
class PremiumPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final RouteTransitionType transitionType;
  final Duration duration;
  final Curve curve;

  PremiumPageRoute({
    required this.child,
    this.transitionType = RouteTransitionType.slideFromRight,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeInOutCubic,
    super.settings,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return _buildTransition(
             child,
             animation,
             secondaryAnimation,
             transitionType,
             curve,
           );
         },
       );

  static Widget _buildTransition(
    Widget child,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    RouteTransitionType type,
    Curve curve,
  ) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

    switch (type) {
      case RouteTransitionType.slideFromRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      case RouteTransitionType.slideFromLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      case RouteTransitionType.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      case RouteTransitionType.fadeScale:
        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      case RouteTransitionType.fade:
        return FadeTransition(opacity: curvedAnimation, child: child);
    }
  }
}

enum RouteTransitionType {
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  fadeScale,
  fade,
}

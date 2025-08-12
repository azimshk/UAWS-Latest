import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/theme/app_theme.dart';
import '../animations/premium_animations.dart';

/// Premium loading indicator with sophisticated animations
class PremiumLoading extends StatefulWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final String? message;
  final LoadingType type;

  const PremiumLoading({
    super.key,
    this.size = 48.0,
    this.color,
    this.strokeWidth = 3.0,
    this.message,
    this.type = LoadingType.circular,
  });

  @override
  State<PremiumLoading> createState() => _PremiumLoadingState();
}

class _PremiumLoadingState extends State<PremiumLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _controller.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PremiumAnimations.fadeInScale(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLoadingIndicator(),
          if (widget.message != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    switch (widget.type) {
      case LoadingType.circular:
        return _buildCircularLoader();
      case LoadingType.dots:
        return _buildDotsLoader();
      case LoadingType.pulse:
        return _buildPulseLoader();
      case LoadingType.spinner:
        return _buildSpinnerLoader();
      case LoadingType.wave:
        return _buildWaveLoader();
    }
  }

  Widget _buildCircularLoader() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * math.pi,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              strokeWidth: widget.strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.color ?? AppTheme.primaryColor,
              ),
              backgroundColor: (widget.color ?? AppTheme.primaryColor)
                  .withValues(alpha: 0.2),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDotsLoader() {
    return SizedBox(
      width: widget.size,
      height: widget.size / 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = index * 0.2;
              final animationValue = (_controller.value + delay) % 1.0;
              final scale = 0.5 + 0.5 * math.sin(animationValue * 2 * math.pi);

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size / 6,
                  height: widget.size / 6,
                  decoration: BoxDecoration(
                    color: widget.color ?? AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildPulseLoader() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: (widget.color ?? AppTheme.primaryColor).withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: widget.size * 0.6,
                height: widget.size * 0.6,
                decoration: BoxDecoration(
                  color: widget.color ?? AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpinnerLoader() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * math.pi,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: SpinnerPainter(
                color: widget.color ?? AppTheme.primaryColor,
                strokeWidth: widget.strokeWidth,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveLoader() {
    return SizedBox(
      width: widget.size,
      height: widget.size / 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = index * 0.1;
              final animationValue = (_controller.value + delay) % 1.0;
              final height =
                  (widget.size / 4) +
                  (widget.size / 4) * math.sin(animationValue * 2 * math.pi);

              return Container(
                width: widget.size / 8,
                height: height,
                decoration: BoxDecoration(
                  color: widget.color ?? AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(widget.size / 16),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

/// Custom painter for spinner loading
class SpinnerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  SpinnerPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    // Draw multiple arcs for spinner effect
    for (int i = 0; i < 8; i++) {
      final startAngle = (i * 45) * math.pi / 180;
      final sweepAngle = 30 * math.pi / 180;
      final opacity = 1.0 - (i * 0.1);

      paint.color = color.withValues(alpha: opacity);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum LoadingType { circular, dots, pulse, spinner, wave }

/// Premium progress bar with smooth animations
class PremiumProgressBar extends StatefulWidget {
  final double value;
  final double? height;
  final Color? backgroundColor;
  final Color? progressColor;
  final BorderRadius? borderRadius;
  final String? label;
  final String? subtitle;
  final bool showPercentage;
  final Duration animationDuration;

  const PremiumProgressBar({
    super.key,
    required this.value,
    this.height,
    this.backgroundColor,
    this.progressColor,
    this.borderRadius,
    this.label,
    this.subtitle,
    this.showPercentage = true,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  State<PremiumProgressBar> createState() => _PremiumProgressBarState();
}

class _PremiumProgressBarState extends State<PremiumProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimation =
        Tween<double>(begin: 0.0, end: widget.value.clamp(0.0, 1.0)).animate(
          CurvedAnimation(parent: _controller, curve: AppTheme.smoothCurve),
        );

    _controller.forward();
  }

  @override
  void didUpdateWidget(PremiumProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _progressAnimation =
          Tween<double>(
            begin: _progressAnimation.value,
            end: widget.value.clamp(0.0, 1.0),
          ).animate(
            CurvedAnimation(parent: _controller, curve: AppTheme.smoothCurve),
          );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PremiumAnimations.fadeInScale(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null || widget.showPercentage) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (widget.showPercentage)
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Text(
                        '${(_progressAnimation.value * 100).round()}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.secondaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                height: widget.height ?? 8,
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? AppTheme.surfaceContainer,
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.progressColor ?? AppTheme.primaryColor,
                    ),
                  ),
                ),
              );
            },
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.tertiaryTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Premium circular progress indicator
class PremiumCircularProgress extends StatefulWidget {
  final double value;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final String? centerText;
  final Widget? centerWidget;
  final bool showPercentage;
  final Duration animationDuration;

  const PremiumCircularProgress({
    super.key,
    required this.value,
    this.size = 120,
    this.strokeWidth = 8,
    this.backgroundColor,
    this.progressColor,
    this.centerText,
    this.centerWidget,
    this.showPercentage = true,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<PremiumCircularProgress> createState() =>
      _PremiumCircularProgressState();
}

class _PremiumCircularProgressState extends State<PremiumCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimation =
        Tween<double>(begin: 0.0, end: widget.value.clamp(0.0, 1.0)).animate(
          CurvedAnimation(parent: _controller, curve: AppTheme.smoothCurve),
        );

    _controller.forward();
  }

  @override
  void didUpdateWidget(PremiumCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _progressAnimation =
          Tween<double>(
            begin: _progressAnimation.value,
            end: widget.value.clamp(0.0, 1.0),
          ).animate(
            CurvedAnimation(parent: _controller, curve: AppTheme.smoothCurve),
          );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PremiumAnimations.fadeInScale(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return CircularProgressIndicator(
                  value: _progressAnimation.value,
                  strokeWidth: widget.strokeWidth,
                  backgroundColor:
                      widget.backgroundColor ??
                      AppTheme.quaternaryTextColor.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.progressColor ?? AppTheme.primaryColor,
                  ),
                );
              },
            ),
            if (widget.centerWidget != null)
              widget.centerWidget!
            else if (widget.centerText != null)
              Text(
                widget.centerText!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryTextColor,
                ),
                textAlign: TextAlign.center,
              )
            else if (widget.showPercentage)
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Text(
                    '${(_progressAnimation.value * 100).round()}%',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryTextColor,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Premium skeleton loader for placeholder content
class PremiumSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const PremiumSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<PremiumSkeleton> createState() => _PremiumSkeletonState();
}

class _PremiumSkeletonState extends State<PremiumSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat();
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
          width: widget.width,
          height: widget.height ?? 16,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor ?? AppTheme.surfaceContainer,
                widget.highlightColor ?? AppTheme.surfaceElevated,
                widget.baseColor ?? AppTheme.surfaceContainer,
              ],
              stops: [
                (_animation.value - 1.0).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1.0).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../animations/premium_animations.dart';
import '../../utils/responsive_utils.dart';

/// Premium card widget with sophisticated styling and animations
class PremiumCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Color? backgroundColor;
  final Border? border;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final bool enableHoverEffect;
  final bool enablePressEffect;
  final Duration? animationDuration;

  const PremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding,
    this.elevation,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.enableHoverEffect = true,
    this.enablePressEffect = true,
    this.animationDuration,
  });

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration ?? AppTheme.mediumAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppTheme.premiumCurve,
      ),
    );

    _elevationAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppTheme.premiumCurve,
      ),
    );

    _colorAnimation =
        ColorTween(
          begin: widget.backgroundColor ?? AppTheme.surfaceColor,
          end: (widget.backgroundColor ?? AppTheme.surfaceColor).withValues(
            alpha: 0.95,
          ),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: AppTheme.premiumCurve,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enablePressEffect) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePressEffect) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    if (widget.enablePressEffect) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _handleHoverEnter(PointerEvent event) {
    if (widget.enableHoverEffect) {
      _animationController.forward();
    }
  }

  void _handleHoverExit(PointerEvent event) {
    if (widget.enableHoverEffect) {
      if (!_isPressed) {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get responsive margins and padding
    final responsiveMargin =
        widget.margin ??
        context.responsivePadding.copyWith(
          top: context.responsivePadding.top * 0.5,
          bottom: context.responsivePadding.bottom * 0.5,
        );

    final responsivePadding =
        widget.padding ??
        EdgeInsets.all(
          context.isMobile
              ? 16.0
              : context.isTablet
              ? 20.0
              : 24.0,
        );

    return PremiumAnimations.fadeInScale(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: MouseRegion(
              onEnter: _handleHoverEnter,
              onExit: _handleHoverExit,
              child: GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: context.maxContentWidth,
                  ),
                  child: Container(
                    margin: responsiveMargin,
                    padding: responsivePadding,
                    decoration: BoxDecoration(
                      color: _colorAnimation.value,
                      borderRadius:
                          widget.borderRadius ??
                          BorderRadius.circular(
                            context.isMobile
                                ? 16
                                : context.isTablet
                                ? 20
                                : 24,
                          ),
                      border:
                          widget.border ??
                          Border.all(
                            color: AppTheme.quaternaryTextColor.withValues(
                              alpha: 0.1,
                            ),
                            width: 1,
                          ),
                      boxShadow:
                          widget.boxShadow ??
                          [
                            BoxShadow(
                              color: AppTheme.primaryColor.withValues(
                                alpha:
                                    0.04 + (_elevationAnimation.value * 0.01),
                              ),
                              offset: Offset(0, 2 + _elevationAnimation.value),
                              blurRadius: 8 + _elevationAnimation.value,
                              spreadRadius: 0,
                            ),
                          ],
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Premium glass morphism card
class GlassMorphismCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color? color;
  final BorderRadius? borderRadius;
  final Border? border;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const GlassMorphismCard({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.2,
    this.color,
    this.borderRadius,
    this.border,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive styling
    final responsiveMargin =
        margin ??
        context.responsivePadding.copyWith(
          top: context.responsivePadding.top * 0.5,
          bottom: context.responsivePadding.bottom * 0.5,
        );

    final responsivePadding =
        padding ??
        EdgeInsets.all(
          context.isMobile
              ? 16.0
              : context.isTablet
              ? 20.0
              : 24.0,
        );

    final responsiveBorderRadius =
        borderRadius ??
        BorderRadius.circular(
          context.isMobile
              ? 16
              : context.isTablet
              ? 20
              : 24,
        );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: context.maxContentWidth),
      child: Container(
        margin: responsiveMargin,
        decoration: BoxDecoration(
          borderRadius: responsiveBorderRadius,
          border:
              border ??
              Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
        ),
        child: ClipRRect(
          borderRadius: responsiveBorderRadius,
          child: Container(
            padding: responsivePadding,
            decoration: BoxDecoration(
              color: (color ?? Colors.white).withValues(alpha: opacity),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Premium gradient card
class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.borderRadius,
    this.margin,
    this.padding,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive styling
    final responsiveMargin =
        margin ??
        context.responsivePadding.copyWith(
          top: context.responsivePadding.top * 0.5,
          bottom: context.responsivePadding.bottom * 0.5,
        );

    final responsivePadding =
        padding ??
        EdgeInsets.all(
          context.isMobile
              ? 16.0
              : context.isTablet
              ? 20.0
              : 24.0,
        );

    final responsiveBorderRadius =
        borderRadius ??
        BorderRadius.circular(
          context.isMobile
              ? 16
              : context.isTablet
              ? 20
              : 24,
        );

    Widget cardWidget = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: context.maxContentWidth),
      child: Container(
        margin: responsiveMargin,
        padding: responsivePadding,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: responsiveBorderRadius,
          boxShadow: boxShadow ?? AppTheme.premiumShadow,
        ),
        child: child,
      ),
    );

    if (onTap != null) {
      return PremiumAnimations.bounceTouch(onTap: onTap, child: cardWidget);
    }

    return cardWidget;
  }
}

/// Premium floating action card
class FloatingActionCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final IconData? icon;
  final String? label;
  final bool extended;

  const FloatingActionCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.icon,
    this.label,
    this.extended = false,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    final responsiveIconSize = context.isMobile
        ? 24.0
        : context.isTablet
        ? 26.0
        : 28.0;
    final responsivePadding = extended
        ? EdgeInsets.symmetric(
            horizontal: context.isMobile
                ? 20
                : context.isTablet
                ? 24
                : 28,
            vertical: context.isMobile
                ? 14
                : context.isTablet
                ? 16
                : 18,
          )
        : EdgeInsets.all(
            context.isMobile
                ? 14
                : context.isTablet
                ? 16
                : 18,
          );
    final responsiveBorderRadius = extended
        ? (context.isMobile
              ? 20.0
              : context.isTablet
              ? 24.0
              : 28.0)
        : (context.isMobile
              ? 24.0
              : context.isTablet
              ? 28.0
              : 32.0);

    return PremiumAnimations.floating(
      child: PremiumAnimations.bounceTouch(
        onTap: onTap,
        child: Container(
          padding: responsivePadding,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(responsiveBorderRadius),
            boxShadow: AppTheme.floatingShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(icon, color: Colors.white, size: responsiveIconSize),
              if (extended && label != null) ...[
                SizedBox(width: context.isMobile ? 10 : 12),
                Text(
                  label!,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: context.isMobile
                        ? 14
                        : context.isTablet
                        ? 15
                        : 16,
                  ),
                ),
              ],
              if (!extended) child,
            ],
          ),
        ),
      ),
    );
  }
}

/// Premium data card with statistics
class StatisticsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final String? trend;
  final bool isPositiveTrend;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.trailing,
    this.trend,
    this.isPositiveTrend = true,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppTheme.primaryColor).withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (trend != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isPositiveTrend
                        ? AppTheme.successColor.withValues(alpha: 0.1)
                        : AppTheme.errorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositiveTrend
                            ? Icons.trending_up
                            : Icons.trending_down,
                        size: 14,
                        color: isPositiveTrend
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isPositiveTrend
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
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

/// Premium notification card
class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final NotificationType type;
  final DateTime? timestamp;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.iconColor,
    this.onTap,
    this.onDismiss,
    this.type = NotificationType.info,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    Color typeColor;
    IconData typeIcon;

    switch (type) {
      case NotificationType.success:
        typeColor = AppTheme.successColor;
        typeIcon = Icons.check_circle;
        break;
      case NotificationType.warning:
        typeColor = AppTheme.warningColor;
        typeIcon = Icons.warning;
        break;
      case NotificationType.error:
        typeColor = AppTheme.errorColor;
        typeIcon = Icons.error;
        break;
      case NotificationType.info:
        typeColor = AppTheme.infoColor;
        typeIcon = Icons.info;
        break;
    }

    return PremiumAnimations.slideIn(
      direction: SlideDirection.right,
      child: PremiumCard(
        onTap: onTap,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon ?? typeIcon,
                color: iconColor ?? typeColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                  if (timestamp != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(timestamp!),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.tertiaryTextColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onDismiss != null) ...[
              const SizedBox(width: 8),
              PremiumAnimations.bounceTouch(
                onTap: onDismiss,
                child: Icon(
                  Icons.close,
                  color: AppTheme.tertiaryTextColor,
                  size: 18,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

enum NotificationType { success, warning, error, info }

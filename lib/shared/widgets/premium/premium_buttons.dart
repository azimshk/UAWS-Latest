import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../animations/premium_animations.dart';
import '../../utils/responsive_utils.dart';

/// Premium elevated button with sophisticated styling
class PremiumButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonStyle? style;
  final bool isLoading;
  final bool fullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const PremiumButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.style,
    this.isLoading = false,
    this.fullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.mediumAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.premiumCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown() {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _handleTapUp() {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
      widget.onPressed!();
    }
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    // Responsive sizing
    final responsiveHeight = context.isMobile
        ? 52.0
        : context.isTablet
        ? 56.0
        : 60.0;
    final responsiveIconSize = context.isMobile
        ? 18.0
        : context.isTablet
        ? 20.0
        : 22.0;
    final responsiveFontSize = context.isMobile
        ? 14.0
        : context.isTablet
        ? 15.0
        : 16.0;
    final responsiveBorderRadius =
        widget.borderRadius ??
        (context.isMobile
            ? 14.0
            : context.isTablet
            ? 16.0
            : 18.0);
    final responsivePadding =
        widget.padding ??
        EdgeInsets.symmetric(
          horizontal: context.isMobile
              ? 20.0
              : context.isTablet
              ? 24.0
              : 28.0,
          vertical: context.isMobile
              ? 12.0
              : context.isTablet
              ? 14.0
              : 16.0,
        );

    Widget buttonChild = Row(
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: responsiveIconSize,
            height: responsiveIconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.foregroundColor ?? Colors.white,
              ),
            ),
          ),
          SizedBox(width: context.isMobile ? 10 : 12),
        ] else if (widget.icon != null) ...[
          Icon(
            widget.icon,
            size: responsiveIconSize,
            color: widget.foregroundColor ?? Colors.white,
          ),
          SizedBox(width: context.isMobile ? 10 : 12),
        ],
        Text(
          widget.text,
          style:
              widget.textStyle ??
              Theme.of(context).textTheme.labelLarge?.copyWith(
                color: widget.foregroundColor ?? Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                fontSize: responsiveFontSize,
              ),
        ),
      ],
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _handleTapDown(),
            onTapUp: (_) => _handleTapUp(),
            onTapCancel: _handleTapCancel,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widget.fullWidth
                    ? double.infinity
                    : context.maxContentWidth,
                minHeight: responsiveHeight,
              ),
              child: Container(
                width: widget.fullWidth ? double.infinity : null,
                padding: responsivePadding,
                decoration: BoxDecoration(
                  gradient: isDisabled
                      ? null
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.backgroundColor ?? AppTheme.primaryColor,
                            (widget.backgroundColor ?? AppTheme.primaryColor)
                                .withValues(alpha: 0.8),
                          ],
                        ),
                  color: isDisabled
                      ? AppTheme.quaternaryTextColor.withValues(alpha: 0.3)
                      : null,
                  borderRadius: BorderRadius.circular(responsiveBorderRadius),
                  boxShadow: isDisabled
                      ? null
                      : [
                          BoxShadow(
                            color:
                                (widget.backgroundColor ??
                                        AppTheme.primaryColor)
                                    .withValues(alpha: 0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(responsiveBorderRadius),
                    onTap: isDisabled ? null : widget.onPressed,
                    child: Container(
                      alignment: Alignment.center,
                      child: buttonChild,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Premium outlined button with animations
class PremiumOutlinedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final Color? borderColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const PremiumOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.borderColor,
    this.textColor,
    this.borderRadius,
    this.padding,
  });

  @override
  State<PremiumOutlinedButton> createState() => _PremiumOutlinedButtonState();
}

class _PremiumOutlinedButtonState extends State<PremiumOutlinedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _backgroundAnimation;
  late Animation<Color?> _textAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.fastAnimation,
      vsync: this,
    );

    _backgroundAnimation = ColorTween(
      begin: Colors.transparent,
      end: (widget.borderColor ?? AppTheme.primaryColor).withValues(
        alpha: 0.05,
      ),
    ).animate(_controller);

    _textAnimation = ColorTween(
      begin: widget.textColor ?? AppTheme.primaryColor,
      end: widget.borderColor ?? AppTheme.primaryColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return PremiumAnimations.bounceTouch(
      onTap: isDisabled ? null : widget.onPressed,
      child: MouseRegion(
        onEnter: (_) => _controller.forward(),
        onExit: (_) => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: widget.fullWidth ? double.infinity : null,
              height: 56,
              decoration: BoxDecoration(
                color: _backgroundAnimation.value,
                border: Border.all(
                  color: isDisabled
                      ? AppTheme.quaternaryTextColor.withValues(alpha: 0.3)
                      : widget.borderColor ?? AppTheme.primaryColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 16,
                  ),
                  onTap: isDisabled ? null : widget.onPressed,
                  child: Container(
                    padding:
                        widget.padding ??
                        const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                    child: Row(
                      mainAxisSize: widget.fullWidth
                          ? MainAxisSize.max
                          : MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.isLoading) ...[
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _textAnimation.value!,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ] else if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            size: 20,
                            color: _textAnimation.value,
                          ),
                          const SizedBox(width: 12),
                        ],
                        Text(
                          widget.text,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: isDisabled
                                    ? AppTheme.quaternaryTextColor
                                    : _textAnimation.value,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Premium floating action button with pulse animation
class PremiumFloatingActionButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? size;
  final bool mini;
  final bool enablePulse;

  const PremiumFloatingActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.size,
    this.mini = false,
    this.enablePulse = true,
  });

  @override
  State<PremiumFloatingActionButton> createState() =>
      _PremiumFloatingActionButtonState();
}

class _PremiumFloatingActionButtonState
    extends State<PremiumFloatingActionButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: AppTheme.fastAnimation,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: AppTheme.premiumCurve),
    );

    if (widget.enablePulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown() {
    _scaleController.forward();
  }

  void _handleTapUp() {
    _scaleController.reverse();
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = widget.size ?? (widget.mini ? 40.0 : 56.0);

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _scaleController]),
      builder: (context, child) {
        return Transform.scale(
          scale:
              _scaleAnimation.value *
              (widget.enablePulse ? _pulseAnimation.value : 1.0),
          child: GestureDetector(
            onTapDown: (_) => _handleTapDown(),
            onTapUp: (_) => _handleTapUp(),
            onTapCancel: _handleTapCancel,
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(buttonSize / 2),
                boxShadow: AppTheme.floatingShadow,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(buttonSize / 2),
                  onTap: widget.onPressed,
                  child: Icon(
                    widget.icon,
                    color: widget.foregroundColor ?? Colors.white,
                    size: widget.mini ? 18 : 24,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Premium icon button with ripple effect
class PremiumIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final double? iconSize;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;

  const PremiumIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size,
    this.iconSize,
    this.tooltip,
    this.padding,
  });

  @override
  State<PremiumIconButton> createState() => _PremiumIconButtonState();
}

class _PremiumIconButtonState extends State<PremiumIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.fastAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.premiumCurve),
    );

    _colorAnimation = ColorTween(
      begin: widget.backgroundColor ?? Colors.transparent,
      end: (widget.color ?? AppTheme.primaryColor).withValues(alpha: 0.1),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = widget.size ?? 48.0;

    Widget button = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              borderRadius: BorderRadius.circular(buttonSize / 2),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(buttonSize / 2),
                onTap: widget.onPressed,
                onTapDown: (_) => _controller.forward(),
                onTapUp: (_) => _controller.reverse(),
                onTapCancel: () => _controller.reverse(),
                child: Container(
                  padding: widget.padding ?? const EdgeInsets.all(12),
                  child: Icon(
                    widget.icon,
                    color: widget.color ?? AppTheme.primaryColor,
                    size: widget.iconSize ?? 24,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }

    return button;
  }
}

/// Premium toggle button with smooth transitions
class PremiumToggleButton extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final IconData? activeIcon;
  final IconData? inactiveIcon;
  final Color? activeColor;
  final Color? inactiveColor;

  const PremiumToggleButton({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.activeIcon,
    this.inactiveIcon,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<PremiumToggleButton> createState() => _PremiumToggleButtonState();
}

class _PremiumToggleButtonState extends State<PremiumToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.mediumAnimation,
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin:
          widget.inactiveColor ??
          AppTheme.quaternaryTextColor.withValues(alpha: 0.2),
      end: widget.activeColor ?? AppTheme.primaryColor,
    ).animate(_controller);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.bounceCurve),
    );

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(PremiumToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PremiumAnimations.bounceTouch(
      onTap: widget.onChanged != null
          ? () => widget.onChanged!(!widget.value)
          : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(12),
                boxShadow: widget.value ? AppTheme.premiumShadow : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.value && widget.activeIcon != null ||
                      !widget.value && widget.inactiveIcon != null)
                    Icon(
                      widget.value ? widget.activeIcon : widget.inactiveIcon,
                      color: widget.value
                          ? Colors.white
                          : AppTheme.secondaryTextColor,
                      size: 20,
                    ),
                  if (widget.label != null &&
                      (widget.activeIcon != null ||
                          widget.inactiveIcon != null))
                    const SizedBox(width: 8),
                  if (widget.label != null)
                    Text(
                      widget.label!,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: widget.value
                            ? Colors.white
                            : AppTheme.secondaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

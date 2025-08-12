import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../animations/premium_animations.dart';

/// Premium text field with sophisticated styling and animations
class PremiumTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool showFloatingLabel;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderRadius;

  const PremiumTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
    this.contentPadding,
    this.textStyle,
    this.inputFormatters,
    this.showFloatingLabel = true,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
  });

  @override
  State<PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<PremiumTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _borderColorAnimation;
  late Animation<double> _labelScaleAnimation;
  late FocusNode _focusNode;

  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = AnimationController(
      duration: AppTheme.mediumAnimation,
      vsync: this,
    );

    _borderColorAnimation = ColorTween(
      begin:
          widget.borderColor ??
          AppTheme.quaternaryTextColor.withValues(alpha: 0.2),
      end: AppTheme.primaryColor,
    ).animate(_controller);

    _labelScaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.smoothCurve),
    );

    _focusNode.addListener(_onFocusChange);

    if (widget.controller != null) {
      _hasText = widget.controller!.text.isNotEmpty;
      widget.controller!.addListener(_onTextChange);
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused || _hasText) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _onTextChange() {
    final hasText = widget.controller!.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });

      if (_hasText || _isFocused) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PremiumAnimations.fadeInScale(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null && widget.showFloatingLabel)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _labelScaleAnimation.value,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.labelText!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: _isFocused
                          ? AppTheme.primaryColor
                          : AppTheme.secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          if (widget.labelText != null && widget.showFloatingLabel)
            const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 16,
                  ),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  validator: widget.validator,
                  onChanged: widget.onChanged,
                  onFieldSubmitted: widget.onSubmitted,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  obscureText: widget.obscureText,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  maxLength: widget.maxLength,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  inputFormatters: widget.inputFormatters,
                  style:
                      widget.textStyle ??
                      Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  decoration: InputDecoration(
                    labelText: widget.showFloatingLabel
                        ? null
                        : widget.labelText,
                    hintText: widget.hintText,
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: widget.suffixIcon,
                    filled: true,
                    fillColor: widget.fillColor ?? AppTheme.surfaceElevated,
                    contentPadding:
                        widget.contentPadding ??
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius ?? 16,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius ?? 16,
                      ),
                      borderSide: BorderSide(
                        color: _borderColorAnimation.value!,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius ?? 16,
                      ),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius ?? 16,
                      ),
                      borderSide: const BorderSide(
                        color: AppTheme.errorColor,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius ?? 16,
                      ),
                      borderSide: const BorderSide(
                        color: AppTheme.errorColor,
                        width: 2,
                      ),
                    ),
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.tertiaryTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                    labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: _isFocused
                          ? AppTheme.primaryColor
                          : AppTheme.secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                    floatingLabelStyle: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Premium search field with search icon and clear button
class PremiumSearchField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool showClearButton;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;

  const PremiumSearchField({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.showClearButton = true,
    this.prefixIcon,
    this.contentPadding,
  });

  @override
  State<PremiumSearchField> createState() => _PremiumSearchFieldState();
}

class _PremiumSearchFieldState extends State<PremiumSearchField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  void _clearText() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return PremiumTextField(
      controller: _controller,
      hintText: widget.hintText ?? 'Search...',
      onSubmitted: widget.onSubmitted,
      showFloatingLabel: false,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      contentPadding: widget.contentPadding,
      prefixIcon:
          widget.prefixIcon ??
          Icon(Icons.search, color: AppTheme.tertiaryTextColor, size: 20),
      suffixIcon: widget.showClearButton && _hasText
          ? PremiumAnimations.fadeInScale(
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: AppTheme.tertiaryTextColor,
                  size: 20,
                ),
                onPressed: _clearText,
                splashRadius: 20,
              ),
            )
          : null,
    );
  }
}

/// Premium dropdown field with custom styling
class PremiumDropdownField<T> extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final bool enabled;
  final double? borderRadius;
  final Color? fillColor;

  const PremiumDropdownField({
    super.key,
    this.labelText,
    this.hintText,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
    this.borderRadius,
    this.fillColor,
  });

  @override
  State<PremiumDropdownField<T>> createState() =>
      _PremiumDropdownFieldState<T>();
}

class _PremiumDropdownFieldState<T> extends State<PremiumDropdownField<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _borderColorAnimation;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.mediumAnimation,
      vsync: this,
    );

    _borderColorAnimation = ColorTween(
      begin: AppTheme.quaternaryTextColor.withValues(alpha: 0.2),
      end: AppTheme.primaryColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange(bool focused) {
    setState(() {
      _isFocused = focused;
    });

    if (focused) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PremiumAnimations.fadeInScale(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null) ...[
            Text(
              widget.labelText!,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _isFocused
                    ? AppTheme.primaryColor
                    : AppTheme.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
          ],
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 16,
                  ),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: DropdownButtonFormField<T>(
                  value: widget.value,
                  items: widget.items,
                  onChanged: widget.enabled ? widget.onChanged : null,
                  validator: widget.validator,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    prefixIcon: widget.prefixIcon,
                    filled: true,
                    fillColor: widget.fillColor ?? AppTheme.surfaceElevated,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius ?? 16,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius ?? 16,
                      ),
                      borderSide: BorderSide(
                        color: _borderColorAnimation.value!,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius ?? 16,
                      ),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.tertiaryTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                  dropdownColor: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _onFocusChange(true),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Premium checkbox with custom styling
class PremiumCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? title;
  final String? subtitle;
  final Color? activeColor;
  final Color? checkColor;

  const PremiumCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.title,
    this.subtitle,
    this.activeColor,
    this.checkColor,
  });

  @override
  State<PremiumCheckbox> createState() => _PremiumCheckboxState();
}

class _PremiumCheckboxState extends State<PremiumCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.fastAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.bounceCurve),
    );

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(PremiumCheckbox oldWidget) {
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
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: widget.value
                        ? widget.activeColor ?? AppTheme.primaryColor
                        : Colors.transparent,
                    border: Border.all(
                      color: widget.value
                          ? widget.activeColor ?? AppTheme.primaryColor
                          : AppTheme.quaternaryTextColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: widget.value
                      ? Icon(
                          Icons.check,
                          color: widget.checkColor ?? Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              );
            },
          ),
          if (widget.title != null) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

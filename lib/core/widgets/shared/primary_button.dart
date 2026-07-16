import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSecondary;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isSecondary = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isSecondary ? AppColors.surface : AppColors.primaryGreen;
    final shadowColor = widget.isSecondary ? AppColors.divider : AppColors.primaryGreenDark;
    final textColor = widget.isSecondary ? AppColors.textPrimary : Colors.white;
    final hoverColor = widget.isSecondary ? Colors.grey[50] : const Color(0xFF6DE010);

    return MouseRegion(
      cursor: widget.onPressed == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          if (widget.onPressed != null) widget.onPressed!();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: EdgeInsets.only(top: _isPressed ? 4 : 0),
          decoration: BoxDecoration(
            color: _isHovered ? hoverColor : baseColor,
            borderRadius: BorderRadius.circular(AppConstants.radius16),
            border: widget.isSecondary ? Border.all(color: AppColors.divider, width: 2) : null,
            boxShadow: _isPressed || widget.onPressed == null
                ? []
                : [
                    BoxShadow(
                      color: shadowColor,
                      offset: const Offset(0, 4),
                    )
                  ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Center(
            child: Text(
              widget.text.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: widget.onPressed == null ? AppColors.textSecondary : textColor,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BigButton extends StatefulWidget {
  const BigButton({
    super.key,
    required this.label,
    this.onTap,
    this.color,
    this.textColor,
  });

  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final Color? textColor;

  @override
  State<BigButton> createState() => _BigButtonState();
}

class _BigButtonState extends State<BigButton> with SingleTickerProviderStateMixin {
  double _scale = 1;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.98;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _scale = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(24);
    final gradientColors = [
      (widget.color ?? theme.colorScheme.primary).withOpacity(0.92),
      widget.color != null
          ? widget.color!.withOpacity(0.85)
          : theme.colorScheme.primaryContainer.withOpacity(0.9),
    ];
    final textColor = widget.textColor ?? theme.colorScheme.onPrimary;

    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          borderRadius: borderRadius,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
              alignment: Alignment.center,
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

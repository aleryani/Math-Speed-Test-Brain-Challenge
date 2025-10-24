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
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: widget.color ?? theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: widget.textColor ?? theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

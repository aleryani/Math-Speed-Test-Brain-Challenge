import 'package:flutter/material.dart';

class FeedbackOverlay extends StatelessWidget {
  const FeedbackOverlay({
    super.key,
    required this.showCorrect,
    required this.showWrong,
    required this.successColor,
    required this.errorColor,
  });

  final bool showCorrect;
  final bool showWrong;
  final Color successColor;
  final Color errorColor;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Stack(
        children: [
          AnimatedOpacity(
            opacity: showCorrect ? 0.25 : 0,
            duration: const Duration(milliseconds: 150),
            child: Container(color: successColor),
          ),
          AnimatedOpacity(
            opacity: showWrong ? 0.25 : 0,
            duration: const Duration(milliseconds: 150),
            child: Container(color: errorColor),
          ),
        ],
      ),
    );
  }
}

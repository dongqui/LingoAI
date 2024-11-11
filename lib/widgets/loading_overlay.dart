import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final String message;
  final Widget? adWidget;

  const LoadingOverlay({
    super.key,
    this.message = '당신의 이야기를 그림으로 만드는 중...',
    this.adWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF4D4EE8),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            if (adWidget != null) ...[
              const SizedBox(height: 24),
              adWidget!,
            ],
          ],
        ),
      ),
    );
  }
} 
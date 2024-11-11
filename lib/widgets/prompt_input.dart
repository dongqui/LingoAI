import 'package:flutter/material.dart';

class PromptInput extends StatelessWidget {
  final Function(String) onSubmit;

  const PromptInput({
    super.key,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(16, 16, 56, 16),
                labelText: 'Enter prompt',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w700,
                ),
                hintText: 'Write your feedback...',
                hintStyle: TextStyle(
                  color: Colors.white24,
                  fontSize: 16,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              cursorColor: Color(0xFF4D4EE8),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: IconButton(
              onPressed: () {
                // TODO: onSubmit 호출
              },
              icon: const Icon(
                Icons.send_rounded,
                color: Color(0xFF4D4EE8),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

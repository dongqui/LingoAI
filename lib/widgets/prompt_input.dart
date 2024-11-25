import 'package:flutter/material.dart';

class PromptInput extends StatelessWidget {
  final Function() onSubmit;
  final Function(String) onChange;
  const PromptInput({
    super.key,
    required this.onSubmit,
    required this.onChange,
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
            child: TextField(
              maxLines: 4,
              onChanged: onChange,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(16, 16, 56, 16),
                labelText: 'Prompt',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w700,
                ),
                hintText: 'Describe the image you want',
                hintStyle: TextStyle(
                  color: Colors.white24,
                  fontSize: 16,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              cursorColor: const Color(0xFF4D4EE8),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: IconButton(
              onPressed: () {
                onSubmit();
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

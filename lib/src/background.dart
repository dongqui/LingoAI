import 'package:flutter/material.dart';
import 'dart:math';

class BackgroundWidget extends StatefulWidget {
  final Widget? child;

  const BackgroundWidget({super.key, this.child});

  @override
  _BackgroundWidgetState createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Color _startColor = Colors.blue;
  Color _endColor = Colors.purple;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
    _changeBackgroundColor();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changeBackgroundColor() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _startColor = _endColor;
        _endColor = _getRandomColor();
      });
      _changeBackgroundColor();
    });
  }

  Color _getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_startColor, _endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: widget.child ?? const SizedBox.shrink(),
    );
  }
}

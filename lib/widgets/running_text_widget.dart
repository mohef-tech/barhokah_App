import 'dart:async';
import 'package:flutter/material.dart';

class RunningTextWidget extends StatefulWidget {
  final List<String> texts;
  const RunningTextWidget({super.key, required this.texts});

  @override
  State<RunningTextWidget> createState() => _RunningTextWidgetState();
}

class _RunningTextWidgetState extends State<RunningTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;
  double _screenWidth = 0;
  final GlobalKey _textKey = GlobalKey();
  double _textWidth = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startMarquee();
    });
  }

  @override
  void didUpdateWidget(RunningTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.texts != widget.texts) {
      _currentIndex = 0;
      _controller.stop();
      WidgetsBinding.instance.addPostFrameCallback((_) => _startMarquee());
    }
  }

  void _startMarquee() {
    if (!mounted || widget.texts.isEmpty) return;
    _screenWidth = MediaQuery.of(context).size.width;

    // Ukur lebar teks
    final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    _textWidth = renderBox?.size.width ?? _screenWidth * 2;

    // Total jarak: mulai dari kanan layar, berakhir setelah teks keluar kiri
    final totalDistance = _screenWidth + _textWidth;
    final duration = Duration(milliseconds: (totalDistance * 20).toInt());

    _controller.duration = duration;
    _controller.reset();
    _controller.forward().then((_) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.texts.length;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _startMarquee();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.texts.isEmpty) return const SizedBox(height: 44);

    _screenWidth = MediaQuery.of(context).size.width;
    final fontSize = _screenWidth * 0.018;

    return Container(
      height: 44,
      color: Colors.black.withOpacity(0.55),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Posisi: mulai dari kanan (_screenWidth), bergerak ke kiri
          final offset = _screenWidth - (_controller.value * (_screenWidth + _textWidth));
          return Stack(
            children: [
              Positioned(
                left: offset,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    key: _textKey,
                    widget.texts[_currentIndex],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
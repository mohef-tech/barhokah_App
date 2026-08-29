import 'dart:async';
import 'package:flutter/material.dart';

class RunningTextWidget extends StatefulWidget {
  final List<String> texts;
  const RunningTextWidget({super.key, required this.texts});

  @override
  State<RunningTextWidget> createState() => _RunningTextWidgetState();
}

class _RunningTextWidgetState extends State<RunningTextWidget> {
  late ScrollController _scrollController;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startScroll();
  }

  @override
  void didUpdateWidget(RunningTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.texts != widget.texts) {
      _currentIndex = 0;
      _startScroll();
    }
  }

  void _startScroll() {
    _timer?.cancel();
    if (widget.texts.isEmpty) return;

    Future.delayed(const Duration(seconds: 1), () {
      _scrollText();
    });
  }

  void _scrollText() async {
    if (!mounted) return;
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      await _scrollController.animateTo(
        maxScroll,
        duration: Duration(seconds: (maxScroll / 40).round().clamp(5, 30)),
        curve: Curves.linear,
      );
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      _scrollController.jumpTo(0);
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.texts.length;
      });
      await Future.delayed(const Duration(seconds: 1));
      _scrollText();
    } else {
      _timer = Timer(const Duration(seconds: 1), _scrollText);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.texts.isEmpty) {
      return const SizedBox(height: 40);
    }

    final size = MediaQuery.of(context).size;
    final fontSize = size.width * 0.018;

    return Container(
      height: 48,
      color: const Color(0xFF1a1a1a),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Text(
          widget.texts[_currentIndex],
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants.dart';

class CountdownTimer extends StatefulWidget {
  final String endTime;
  const CountdownTimer({super.key, required this.endTime});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateRemaining();
    });
  }

  void _calculateRemaining() {
    final end = DateTime.parse(widget.endTime);
    final now = DateTime.now().toUtc();
    if (mounted) {
      setState(() {
        _remaining = end.isAfter(now) ? end.difference(now) : Duration.zero;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Text(
      '$h:$m:$s',
      style: const TextStyle(
        color: AppConstants.warning,
        fontWeight: FontWeight.w800,
        fontSize: 16,
        letterSpacing: 1,
      ),
    );
  }
}

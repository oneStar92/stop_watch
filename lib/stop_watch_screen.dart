import 'dart:async';

import 'package:flutter/material.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({super.key});

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  Timer? _timer;
  int _time = 0;
  bool _isRunning = false;
  final _lapTimes = <String>[];

  void _tappedRunningButton() {
    _isRunning = !_isRunning;
    if (_isRunning) {
      _start();
    } else {
      _pause();
    }
  }

  void _start() {
    _time = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }

  void _pause() {
    _timer?.cancel();
  }

  void _reset() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
      _lapTimes.clear();
      _time = 0;
    });
  }

  void _recordLapTime(String time) {
    _lapTimes.insert(0, time);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int sec = _time ~/ 100;
    String hundredth = '${_time % 100}'.padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('스톱워치'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sec',
                style: const TextStyle(fontSize: 50),
              ),
              Text(
                hundredth,
              ),
            ],
          ),
          SizedBox(
            width: 100,
            height: 200,
            child: ListView(
              children: _lapTimes.map((e) => Center(child: Text(e))).toList(),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () => _reset(),
                child: const Icon(Icons.refresh),
              ),
              FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () {
                  setState(() {
                    _tappedRunningButton();
                  });
                },
                child: _isRunning ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
              ),
              FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () {
                  setState(() {
                    _recordLapTime('$sec.$hundredth');
                  });
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

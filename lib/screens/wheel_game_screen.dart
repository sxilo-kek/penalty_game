import 'package:flutter/material.dart';

import 'package:penalty_game/kiosk_screen_size.dart';
import 'package:penalty_game/wheel/models/wheel_prize.dart';
import 'package:penalty_game/wheel/wheel_config_loader.dart';
import 'package:penalty_game/wheel/wheel_spin_engine.dart';
import 'package:penalty_game/wheel/widgets/fortune_wheel_carousel.dart';

class WheelGameScreen extends StatefulWidget {
  const WheelGameScreen({super.key});

  @override
  State<WheelGameScreen> createState() => _WheelGameScreenState();
}

class _WheelGameScreenState extends State<WheelGameScreen> {
  WheelConfig? _config;
  WheelSpinEngine? _engine;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final config = await WheelConfigLoader.load();
      if (!mounted) return;
      setState(() {
        _config = config;
        _engine = WheelSpinEngine(config);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: KioskScreenSize.width,
        height: KioskScreenSize.height,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Text(
          'Failed to load wheel: $_error',
          style: const TextStyle(color: Colors.white, fontSize: 48),
        ),
      );
    }
    if (_config == null || _engine == null) {
      return const Center(
        child: SizedBox(
          width: 120,
          height: 120,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 8,
          ),
        ),
      );
    }

    return FortuneWheelCarousel(
      engine: _engine!,
      spinDurationMs: _config!.spinDurationMs,
      minRotations: _config!.minRotations,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:penalty_game/screens/game_screen.dart';
import 'package:penalty_game/screens/guest_screen.dart';
import 'package:penalty_game/screens/wheel_game_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/penalty',
    ),
    GoRoute(
      path: '/penalty',
      builder: (_, __) => const GameScreen(),
    ),
    GoRoute(
      path: '/wheel',
      builder: (_, __) => const WheelGameScreen(),
    ),
    GoRoute(
      path: '/guest',
      builder: (_, __) => const GuestScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri.path}'),
    ),
  ),
);

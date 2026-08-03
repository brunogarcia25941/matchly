import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/matches/presentation/screens/main_navigation_screen.dart';

void main() {
  runApp(const MatchlyApp());
}

class MatchlyApp extends StatelessWidget {
  const MatchlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matchly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationScreen(),
    );
  }
}
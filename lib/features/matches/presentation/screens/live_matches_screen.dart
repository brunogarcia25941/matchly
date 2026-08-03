import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class LiveMatchesScreen extends StatelessWidget {
  const LiveMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'EM DIRETO',
          style: TextStyle(color: AppColors.liveRed, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
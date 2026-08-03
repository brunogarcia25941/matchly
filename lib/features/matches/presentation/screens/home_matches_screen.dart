import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class HomeMatchesScreen extends StatelessWidget {
  const HomeMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'JOGOS PRINCIPAIS',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class StatItem {
  final String title;
  final num homeValue;
  final num awayValue;
  final String? homeDisplay; // Caso queiras formatar diferente (ex: "54%")
  final String? awayDisplay;

  const StatItem({
    required this.title,
    required this.homeValue,
    required this.awayValue,
    this.homeDisplay,
    this.awayDisplay,
  });
}

class MatchStatsTab extends StatelessWidget {
  final List<StatItem> stats;

  const MatchStatsTab({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: stats.length,
      separatorBuilder: (context, index) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        final stat = stats[index];
        return _buildStatRow(stat);
      },
    );
  }

  Widget _buildStatRow(StatItem stat) {
    final total = (stat.homeValue + stat.awayValue);
    final homeRatio = total > 0 ? (stat.homeValue / total) : 0.5;
    final awayRatio = total > 0 ? (stat.awayValue / total) : 0.5;

    final isHomeHigher = stat.homeValue > stat.awayValue;
    final isAwayHigher = stat.awayValue > stat.homeValue;

    return Column(
      children: [
        // 1. Valores e Nome da Estatística
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Valor Casa
            Text(
              stat.homeDisplay ?? stat.homeValue.toString(),
              style: TextStyle(
                color: isHomeHigher ? AppColors.primaryOrange : AppColors.textPrimary,
                fontWeight: isHomeHigher ? FontWeight.w800 : FontWeight.w600,
                fontSize: 14,
              ),
            ),
            // Título
            Text(
              stat.title.toUpperCase(),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            // Valor Fora
            Text(
              stat.awayDisplay ?? stat.awayValue.toString(),
              style: TextStyle(
                color: isAwayHigher ? AppColors.primaryOrange : AppColors.textPrimary,
                fontWeight: isAwayHigher ? FontWeight.w800 : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // 2. Barra Visual Comparativa (Dupla)
        Row(
          children: [
            // Barra da Casa (cresce da direita para a esquerda)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: homeRatio.clamp(0.05, 1.0),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: isHomeHigher ? AppColors.primaryOrange : AppColors.surfaceLight,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(3),
                        bottomLeft: Radius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            // Barra Fora (cresce da esquerda para a direita)
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: awayRatio.clamp(0.05, 1.0),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: isAwayHigher ? AppColors.primaryOrange : AppColors.surfaceLight,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(3),
                        bottomRight: Radius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
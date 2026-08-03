import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';

class StandingItem {
  final int position;
  final String teamName;
  final String logoUrl;
  final int played;
  final int goalDifference;
  final int points;
  final bool isHighlighted;

  const StandingItem({
    required this.position,
    required this.teamName,
    required this.logoUrl,
    required this.played,
    required this.goalDifference,
    required this.points,
    this.isHighlighted = false,
  });
}

class MatchStandingsTab extends StatelessWidget {
  final List<StandingItem> standings;

  const MatchStandingsTab({super.key, required this.standings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cabeçalho da Tabela
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: AppColors.surface,
          child: const Row(
            children: [
              SizedBox(width: 24, child: Text('#', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold))),
              SizedBox(width: 8),
              Expanded(child: Text('EQUIPA', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold))),
              SizedBox(width: 32, child: Text('J', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold))),
              SizedBox(width: 36, child: Text('DG', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold))),
              SizedBox(width: 36, child: Text('PTS', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold))),
            ],
          ),
        ),

        // Lista de Posições
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: standings.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.surfaceLight),
            itemBuilder: (context, index) {
              final item = standings[index];
              return Container(
                color: item.isHighlighted ? AppColors.primaryOrange.withValues(alpha: 0.12) : Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    // Posição
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${item.position}',
                        style: TextStyle(
                          color: item.position <= 3 ? AppColors.primaryOrange : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Emblema e Nome
                    CachedNetworkImage(
                      imageUrl: item.logoUrl,
                      width: 20,
                      height: 20,
                      errorWidget: (context, url, error) => const Icon(Icons.sports_soccer, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.teamName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: item.isHighlighted ? AppColors.primaryOrange : AppColors.textPrimary,
                          fontWeight: item.isHighlighted ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    // Jogos
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${item.played}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ),

                    // Diferença de Golos
                    SizedBox(
                      width: 36,
                      child: Text(
                        '${item.goalDifference > 0 ? "+${item.goalDifference}" : item.goalDifference}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ),

                    // Pontos
                    SizedBox(
                      width: 36,
                      child: Text(
                        '${item.points}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: item.isHighlighted ? AppColors.primaryOrange : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
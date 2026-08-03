import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class PlayerItem {
  final String number;
  final String name;
  final String position; // Ex: "GR", "DEF", "MED", "AAN"

  const PlayerItem({
    required this.number,
    required this.name,
    required this.position,
  });
}

class MatchLineupsTab extends StatelessWidget {
  final String homeFormation;
  final String awayFormation;
  final List<PlayerItem> homeStarting11;
  final List<PlayerItem> awayStarting11;
  final List<PlayerItem> homeSubstitutes;
  final List<PlayerItem> awaySubstitutes;

  const MatchLineupsTab({
    super.key,
    required this.homeFormation,
    required this.awayFormation,
    required this.homeStarting11,
    required this.awayStarting11,
    required this.homeSubstitutes,
    required this.awaySubstitutes,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Destaque de Formações
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Formação Casa', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                  Text(homeFormation, style: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const PhosphorIcon(PhosphorIcons.strategy, color: AppColors.textMuted, size: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Formação Fora', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                  Text(awayFormation, style: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 2. Onzes Titulares (Lado a Lado)
        const Text(
          'TITULARES',
          style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0),
        ),
        const SizedBox(height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titulares Casa
            Expanded(child: _buildPlayerList(homeStarting11, isHome: true)),
            Container(width: 1, height: 320, color: AppColors.surfaceLight, margin: const EdgeInsets.symmetric(horizontal: 12)),
            // Titulares Fora
            Expanded(child: _buildPlayerList(awayStarting11, isHome: false)),
          ],
        ),

        const SizedBox(height: 24),

        // 3. Suplentes
        const Text(
          'SUPLENTES',
          style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0),
        ),
        const SizedBox(height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildPlayerList(homeSubstitutes, isHome: true)),
            Container(width: 1, height: 200, color: AppColors.surfaceLight, margin: const EdgeInsets.symmetric(horizontal: 12)),
            Expanded(child: _buildPlayerList(awaySubstitutes, isHome: false)),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerList(List<PlayerItem> players, {required bool isHome}) {
    return Column(
      children: players.map((player) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              if (!isHome) ...[
                Text(player.number, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: isHome ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              if (isHome) ...[
                const SizedBox(width: 8),
                Text(player.number, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class LeagueItem {
  final int id;
  final String name;
  final String country;
  final String logoUrl;
  final String flagUrl;

  const LeagueItem({
    required this.id,
    required this.name,
    required this.country,
    required this.logoUrl,
    required this.flagUrl,
  });
}

class LeaguesScreen extends StatelessWidget {
  const LeaguesScreen({super.key});

  List<LeagueItem> _getTopLeagues() {
    return const [
      LeagueItem(id: 94, name: 'Liga Portugal', country: 'Portugal', logoUrl: 'https://media.api-sports.io/football/leagues/94.png', flagUrl: 'https://media.api-sports.io/flags/pt.svg'),
      LeagueItem(id: 39, name: 'Premier League', country: 'Inglaterra', logoUrl: 'https://media.api-sports.io/football/leagues/39.png', flagUrl: 'https://media.api-sports.io/flags/gb.svg'),
      LeagueItem(id: 140, name: 'La Liga', country: 'Espanha', logoUrl: 'https://media.api-sports.io/football/leagues/140.png', flagUrl: 'https://media.api-sports.io/flags/es.svg'),
      LeagueItem(id: 2, name: 'UEFA Champions League', country: 'Europa', logoUrl: 'https://media.api-sports.io/football/leagues/2.png', flagUrl: 'https://media.api-sports.io/flags/eu.svg'),
      LeagueItem(id: 135, name: 'Serie A', country: 'Itália', logoUrl: 'https://media.api-sports.io/football/leagues/135.png', flagUrl: 'https://media.api-sports.io/flags/it.svg'),
      LeagueItem(id: 78, name: 'Bundesliga', country: 'Alemanha', logoUrl: 'https://media.api-sports.io/football/leagues/78.png', flagUrl: 'https://media.api-sports.io/flags/de.svg'),
      LeagueItem(id: 61, name: 'Ligue 1', country: 'França', logoUrl: 'https://media.api-sports.io/football/leagues/61.png', flagUrl: 'https://media.api-sports.io/flags/fr.svg'),
      LeagueItem(id: 3, name: 'UEFA Europa League', country: 'Europa', logoUrl: 'https://media.api-sports.io/football/leagues/3.png', flagUrl: 'https://media.api-sports.io/flags/eu.svg'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final topLeagues = _getTopLeagues();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'COMPETIÇÕES',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          const Text(
            'PRINCIPAIS LIGAS',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          ...topLeagues.map((league) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceLight, width: 0.5),
              ),
              child: ListTile(
                tileColor: Colors.transparent,
                leading: Container(
                  width: 36,
                  height: 36,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: league.logoUrl,
                    errorWidget: (context, url, error) => const PhosphorIcon(PhosphorIcons.trophy, color: AppColors.primaryOrange),
                  ),
                ),
                title: Text(
                  league.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  league.country,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                trailing: const PhosphorIcon(PhosphorIcons.caretRight, color: AppColors.textMuted, size: 16),
                onTap: () {
                  // Futuramente: Abrir ecrã com classificação/jogos desta liga específica
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
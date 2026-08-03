import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; 
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/date_selector_bar.dart';
import '../widgets/featured_match_card.dart';
import '../widgets/match_tile_card.dart';

class HomeMatchesScreen extends StatelessWidget {
  const HomeMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Row(
          children: [
            Text(
              'MATCHLY',
              style: TextStyle(
                color: AppColors.primaryOrange,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const PhosphorIcon(PhosphorIcons.magnifyingGlass),
            onPressed: () {},
            color: AppColors.textPrimary,
          ),
          IconButton(
            icon: const PhosphorIcon(PhosphorIcons.bell),
            onPressed: () {},
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Barra de Seleção de Datas
          DateSelectorBar(
            onDateSelected: (selectedDate) {},
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 12, bottom: 4),
                  child: Text(
                    'DESTAQUE DA COMUNIDADE',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

                // Cartão Premium
                const FeaturedMatchCard(
                  leagueName: 'Liga Portugal • Jornada 28',
                  homeTeam: 'Sporting CP',
                  awayTeam: 'SL Benfica',
                  homeLogoUrl: 'https://media.api-sports.io/football/teams/228.png',
                  awayLogoUrl: 'https://media.api-sports.io/football/teams/211.png',
                  matchTime: '20:30',
                  bgImageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?auto=format&fit=crop&w=1000&q=80',
                ),

                const SizedBox(height: 16),

                // Cabeçalho de Liga (Liga Portugal)
                _buildLeagueHeader('LIGA PORTUGAL', 'https://media.api-sports.io/football/leagues/94.png'),

                const MatchTileCard(
                  homeTeam: 'FC Porto',
                  awayTeam: 'SC Braga',
                  homeLogoUrl: 'https://media.api-sports.io/football/teams/212.png',
                  awayLogoUrl: 'https://media.api-sports.io/football/teams/217.png',
                  homeScore: '2',
                  awayScore: '1',
                  timeOrMinute: "68'",
                  status: MatchStatus.live,
                  isFavorite: true,
                ),

                const MatchTileCard(
                  homeTeam: 'Vitoria SC',
                  awayTeam: 'Moreirense',
                  homeLogoUrl: 'https://media.api-sports.io/football/teams/224.png',
                  awayLogoUrl: 'https://media.api-sports.io/football/teams/226.png',
                  homeScore: '0',
                  awayScore: '0',
                  timeOrMinute: '18:00',
                  status: MatchStatus.scheduled,
                ),

                const SizedBox(height: 16),

                // Cabeçalho de Liga (Premier League)
                _buildLeagueHeader('PREMIER LEAGUE', 'https://media.api-sports.io/football/leagues/39.png'),

                const MatchTileCard(
                  homeTeam: 'Arsenal',
                  awayTeam: 'Chelsea',
                  homeLogoUrl: 'https://media.api-sports.io/football/teams/42.png',
                  awayLogoUrl: 'https://media.api-sports.io/football/teams/49.png',
                  homeScore: '3',
                  awayScore: '1',
                  timeOrMinute: 'FT',
                  status: MatchStatus.finished,
                ),

                const MatchTileCard(
                  homeTeam: 'Manchester City',
                  awayTeam: 'Liverpool',
                  homeLogoUrl: 'https://media.api-sports.io/football/teams/50.png',
                  awayLogoUrl: 'https://media.api-sports.io/football/teams/40.png',
                  homeScore: null,
                  awayScore: null,
                  timeOrMinute: '20:00',
                  status: MatchStatus.scheduled,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeagueHeader(String name, String logoUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: logoUrl,
            width: 18,
            height: 18,
            errorWidget: (context, url, error) => const PhosphorIcon(PhosphorIcons.trophy, size: 16, color: AppColors.primaryOrange),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const Spacer(),
          const PhosphorIcon(PhosphorIcons.caretRight, size: 14, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
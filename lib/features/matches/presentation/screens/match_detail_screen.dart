import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/match_timeline_tab.dart';
import '../widgets/match_stats_tab.dart';
import '../widgets/match_lineups_tab.dart';
import '../widgets/match_standings_tab.dart';

class MatchDetailScreen extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String homeLogoUrl;
  final String awayLogoUrl;
  final String? homeScore;
  final String? awayScore;
  final String leagueName;
  final String matchStatusOrTime;

  const MatchDetailScreen({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogoUrl,
    required this.awayLogoUrl,
    this.homeScore,
    this.awayScore,
    required this.leagueName,
    required this.matchStatusOrTime,
  });

  // Eventos de exemplo para simular o jogo
  List<TimelineEvent> _getMockEvents() {
    return const [
      TimelineEvent(
        minute: "68'",
        type: TimelineEventType.goal,
        playerName: 'Viktor Gyökeres',
        secondaryPlayerName: 'Trincão',
        isHomeTeam: true,
      ),
      TimelineEvent(
        minute: "54'",
        type: TimelineEventType.yellowCard,
        playerName: 'Menezes',
        isHomeTeam: false,
      ),
      TimelineEvent(
        minute: "45'",
        type: TimelineEventType.goal,
        playerName: 'Rafa Silva',
        isHomeTeam: false,
      ),
      TimelineEvent(
        minute: "38'",
        type: TimelineEventType.substitution,
        playerName: 'Inácio',
        secondaryPlayerName: 'Diomande',
        isHomeTeam: true,
      ),
      TimelineEvent(
        minute: "12'",
        type: TimelineEventType.goal,
        playerName: 'Pedro Gonçalves',
        secondaryPlayerName: 'Hjulmand',
        isHomeTeam: true,
      ),
    ];
  }

  List<StatItem> _getMockStats() {
    return const [
      StatItem(title: 'Golos Esperados (xG)', homeValue: 2.15, awayValue: 0.85),
      StatItem(
        title: 'Posse de Bola',
        homeValue: 58,
        awayValue: 42,
        homeDisplay: '58%',
        awayDisplay: '42%',
      ),
      StatItem(title: 'Remates Totais', homeValue: 14, awayValue: 6),
      StatItem(title: 'Remates à Baliza', homeValue: 6, awayValue: 2),
      StatItem(title: 'Grandes Oportunidades', homeValue: 4, awayValue: 1),
      StatItem(title: 'Cantos', homeValue: 8, awayValue: 3),
      StatItem(title: 'Faltas', homeValue: 11, awayValue: 15),
      StatItem(title: 'Passes Certos', homeValue: 480, awayValue: 340),
      StatItem(title: 'Cartões Amarelos', homeValue: 1, awayValue: 3),
    ];
  }

  List<PlayerItem> _getMockHome11() {
    return const [
      PlayerItem(number: '1', name: 'Israel', position: 'GR'),
      PlayerItem(number: '3', name: 'St. Juste', position: 'DEF'),
      PlayerItem(number: '25', name: 'Inácio', position: 'DEF'),
      PlayerItem(number: '26', name: 'Diomande', position: 'DEF'),
      PlayerItem(number: '21', name: 'Catamo', position: 'MED'),
      PlayerItem(number: '42', name: 'Hjulmand', position: 'MED'),
      PlayerItem(number: '23', name: 'Bragança', position: 'MED'),
      PlayerItem(number: '20', name: 'Nuno Santos', position: 'MED'),
      PlayerItem(number: '17', name: 'Trincão', position: 'AVA'),
      PlayerItem(number: '9', name: 'Gyökeres', position: 'AVA'),
      PlayerItem(number: '8', name: 'Pote', position: 'AVA'),
    ];
  }

  List<PlayerItem> _getMockAway11() {
    return const [
      PlayerItem(number: '1', name: 'Trubin', position: 'GR'),
      PlayerItem(number: '8', name: 'Aursnes', position: 'DEF'),
      PlayerItem(number: '66', name: 'António Silva', position: 'DEF'),
      PlayerItem(number: '30', name: 'Otamendi', position: 'DEF'),
      PlayerItem(number: '5', name: 'Morato', position: 'DEF'),
      PlayerItem(number: '61', name: 'Florentino', position: 'MED'),
      PlayerItem(number: '87', name: 'Neves', position: 'MED'),
      PlayerItem(number: '11', name: 'Di María', position: 'AVA'),
      PlayerItem(number: '27', name: 'Rafa', position: 'AVA'),
      PlayerItem(number: '20', name: 'Mário', position: 'AVA'),
      PlayerItem(number: '19', name: 'Tengstedt', position: 'AVA'),
    ];
  }

  List<StandingItem> _getMockStandings() {
    return const [
      StandingItem(position: 1, teamName: 'Sporting CP', logoUrl: 'https://media.api-sports.io/football/teams/228.png', played: 27, goalDifference: 48, points: 71, isHighlighted: true),
      StandingItem(position: 2, teamName: 'SL Benfica', logoUrl: 'https://media.api-sports.io/football/teams/211.png', played: 27, goalDifference: 39, points: 67, isHighlighted: true),
      StandingItem(position: 3, teamName: 'FC Porto', logoUrl: 'https://media.api-sports.io/football/teams/212.png', played: 27, goalDifference: 31, points: 58),
      StandingItem(position: 4, teamName: 'SC Braga', logoUrl: 'https://media.api-sports.io/football/teams/217.png', played: 27, goalDifference: 18, points: 53),
      StandingItem(position: 5, teamName: 'Vitoria SC', logoUrl: 'https://media.api-sports.io/football/teams/224.png', played: 27, goalDifference: 12, points: 50),
      StandingItem(position: 6, teamName: 'Moreirense', logoUrl: 'https://media.api-sports.io/football/teams/226.png', played: 27, goalDifference: 2, points: 42),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const PhosphorIcon(
              PhosphorIcons.caretLeft,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            leagueName.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const PhosphorIcon(
                PhosphorIcons.star,
                color: AppColors.textPrimary,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const PhosphorIcon(
                PhosphorIcons.bell,
                color: AppColors.textPrimary,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            // Placar do Jogo
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              color: AppColors.background,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: homeLogoUrl,
                          height: 54,
                          width: 54,
                          errorWidget: (context, url, error) =>
                              const PhosphorIcon(
                                PhosphorIcons.soccerBall,
                                size: 50,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          homeTeam,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          (homeScore != null && awayScore != null)
                              ? '$homeScore - $awayScore'
                              : matchStatusOrTime,
                          style: const TextStyle(
                            color: AppColors.primaryOrange,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            matchStatusOrTime,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: awayLogoUrl,
                          height: 54,
                          width: 54,
                          errorWidget: (context, url, error) =>
                              const PhosphorIcon(
                                PhosphorIcons.soccerBall,
                                size: 50,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          awayTeam,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // TabBar
            Container(
              color: AppColors.surface,
              child: const TabBar(
                indicatorColor: AppColors.primaryOrange,
                labelColor: AppColors.primaryOrange,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorWeight: 3,
                tabs: [
                  Tab(text: 'Resumo'),
                  Tab(text: 'Estatísticas'),
                  Tab(text: 'Onzes'),
                  Tab(text: 'Tabela'),
                ],
              ),
            ),

            // Conteúdo dos Separadores
            Expanded(
              child: TabBarView(
                children: [
                  MatchTimelineTab(events: _getMockEvents()),
                  MatchStatsTab(stats: _getMockStats()),
                  MatchLineupsTab(
                    homeFormation: '3-4-3',
                    awayFormation: '4-2-3-1',
                    homeStarting11: _getMockHome11(),
                    awayStarting11: _getMockAway11(),
                    homeSubstitutes: _getMockHome11().sublist(0, 5),
                    awaySubstitutes: _getMockAway11().sublist(0, 5),
                  ),
                  MatchStandingsTab(standings: _getMockStandings()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

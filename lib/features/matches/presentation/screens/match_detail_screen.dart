import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/match_model.dart';
import '../../data/services/football_api_service.dart';
import '../widgets/match_timeline_tab.dart';
import '../widgets/match_stats_tab.dart';
import '../widgets/match_lineups_tab.dart';
import '../widgets/match_standings_tab.dart';

class MatchDetailScreen extends StatefulWidget {
  final MatchModel match;

  const MatchDetailScreen({super.key, required this.match});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  final FootballApiService _apiService = FootballApiService();
  bool _isLoadingEvents = true;
  List<TimelineEvent> _realEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchMatchDetails();
  }

  /// Procura os eventos reais do jogo à API
  Future<void> _fetchMatchDetails() async {
    try {
      final events = await _apiService.getMatchEvents(
        widget.match.id,
        widget.match.homeTeamId,
        homeTeamName: widget.match.homeTeam, 
      );
      if (mounted) {
        setState(() {
          _realEvents = events;
          _isLoadingEvents = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingEvents = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLive = [
      '1H',
      '2H',
      'HT',
      'ET',
      'P',
      'LIVE',
    ].contains(widget.match.statusShort);
    final isFinished = ['FT', 'AET', 'PEN'].contains(widget.match.statusShort);

    String statusOrTime = isLive
        ? (widget.match.elapsedMinute ?? 'LIVE')
        : isFinished
        ? 'FT'
        : "${widget.match.matchDate.hour.toString().padLeft(2, '0')}:${widget.match.matchDate.minute.toString().padLeft(2, '0')}";

    return DefaultTabController(
      length: 2,
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
            widget.match.leagueName.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Placar Dinâmico
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
                          imageUrl: widget.match.homeLogo,
                          height: 54,
                          width: 54,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.match.homeTeam,
                          textAlign: TextAlign.center,
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
                          (widget.match.homeGoals != null &&
                                  widget.match.awayGoals != null)
                              ? '${widget.match.homeGoals} - ${widget.match.awayGoals}'
                              : statusOrTime,
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
                            statusOrTime,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
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
                          imageUrl: widget.match.awayLogo,
                          height: 54,
                          width: 54,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.match.awayTeam,
                          textAlign: TextAlign.center,
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
            // Separadores
            Container(
              color: AppColors.surface,
              child: const TabBar(
                indicatorColor: AppColors.primaryOrange,
                labelColor: AppColors.primaryOrange,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: [
                  Tab(text: 'Resumo / Eventos'),
                  Tab(text: 'Estatísticas'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _isLoadingEvents
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryOrange,
                          ),
                        )
                      : MatchTimelineTab(events: _realEvents),
                  const Center(
                    child: Text(
                      'Estatísticas disponíveis no plano Pro da API',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

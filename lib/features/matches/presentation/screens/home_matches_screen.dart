import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/match_model.dart';
import '../../data/services/football_api_service.dart';
import '../widgets/date_selector_bar.dart';
import '../widgets/match_tile_card.dart';
import '../widgets/match_skeleton_loader.dart';

class HomeMatchesScreen extends StatefulWidget {
  const HomeMatchesScreen({super.key});

  @override
  State<HomeMatchesScreen> createState() => _HomeMatchesScreenState();
}

class _HomeMatchesScreenState extends State<HomeMatchesScreen> {
  final FootballApiService _apiService = FootballApiService();
  
  bool _isLoading = false;
  bool _hasFetched = false; // Controlo manual de chamadas
  String? _errorMessage;
  Map<String, List<MatchModel>> _groupedMatches = {};
  DateTime _selectedDate = DateTime.now();

  // Método manual de carregamento para economizar a API Key
  Future<void> _fetchMatchesForDate(DateTime date, {bool forceFetch = false}) async {
    // Se não for pedido forçado e já tivermos dados, evitamos nova chamada à API
    if (!forceFetch && _hasFetched && _selectedDate == date) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedDate = date;
    });

    try {
      final dateFormatted = DateFormat('yyyy-MM-dd').format(date);
      final fetchedMatches = await _apiService.getMatchesByDate(dateFormatted);

      // Agrupa os jogos por nome da Liga
      final Map<String, List<MatchModel>> grouped = {};
      for (var match in fetchedMatches) {
        if (!grouped.containsKey(match.leagueName)) {
          grouped[match.leagueName] = [];
        }
        grouped[match.leagueName]!.add(match);
      }

      if (mounted) {
        setState(() {
          _groupedMatches = grouped;
          _isLoading = false;
          _hasFetched = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar jogos. Verifique a API Key ou a ligação.';
          _isLoading = false;
        });
      }
    }
  }

  MatchStatus _getMatchStatus(String statusShort) {
    if (['1H', '2H', 'HT', 'ET', 'P', 'LIVE'].contains(statusShort)) {
      return MatchStatus.live;
    } else if (['FT', 'AET', 'PEN'].contains(statusShort)) {
      return MatchStatus.finished;
    }
    return MatchStatus.scheduled;
  }

  @override
  Widget build(BuildContext context) {
    final leaguesList = _groupedMatches.keys.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'MATCHLY',
          style: TextStyle(
            color: AppColors.primaryOrange,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          // Botão manual para disparar o pedido à API
          IconButton(
            icon: const PhosphorIcon(PhosphorIcons.cloudArrowDown),
            tooltip: 'Buscar Jogos Reais (API)',
            onPressed: () => _fetchMatchesForDate(_selectedDate, forceFetch: true),
            color: AppColors.primaryOrange,
          ),
          IconButton(
            icon: const PhosphorIcon(PhosphorIcons.magnifyingGlass),
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
            onDateSelected: (selectedDate) {
              setState(() {
                _selectedDate = selectedDate;
                _hasFetched = false; // Reinicia para permitir novo fetch manual no dia
              });
            },
          ),

          Expanded(
            child: _isLoading
                ? const SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: MatchSkeletonLoader(),
                    ),
                  )
                : !_hasFetched
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const PhosphorIcon(
                              PhosphorIcons.soccerBall,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Jogos para ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryOrange,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => _fetchMatchesForDate(_selectedDate, forceFetch: true),
                              icon: const PhosphorIcon(PhosphorIcons.cloudArrowDown, color: Colors.white, size: 18),
                              label: const Text(
                                'CARREGAR DA API',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _errorMessage != null
                        ? Center(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: AppColors.textSecondary),
                            ),
                          )
                        : leaguesList.isEmpty
                            ? const Center(
                                child: Text(
                                  'Nenhum jogo agendado para esta data.',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 24, top: 12),
                                itemCount: leaguesList.length,
                                itemBuilder: (context, leagueIndex) {
                                  final leagueName = leaguesList[leagueIndex];
                                  final matches = _groupedMatches[leagueName]!;
                                  final leagueLogo = matches.first.leagueLogo;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Cabeçalho da Liga
                                      _buildLeagueHeader(leagueName, leagueLogo),

                                      // Jogos pertencentes a esta Liga
                                      ...matches.map((match) {
                                        final status = _getMatchStatus(match.statusShort);

                                        String timeOrMinute;
                                        if (status == MatchStatus.live) {
                                          timeOrMinute = match.elapsedMinute ?? 'LIVE';
                                        } else if (status == MatchStatus.finished) {
                                          timeOrMinute = 'FT';
                                        } else {
                                          timeOrMinute = DateFormat('HH:mm').format(match.matchDate);
                                        }

                                        return MatchTileCard(
                                          homeTeam: match.homeTeam,
                                          awayTeam: match.awayTeam,
                                          homeLogoUrl: match.homeLogo,
                                          awayLogoUrl: match.awayLogo,
                                          homeScore: match.homeGoals?.toString(),
                                          awayScore: match.awayGoals?.toString(),
                                          timeOrMinute: timeOrMinute,
                                          status: status,
                                        );
                                      }),

                                      const SizedBox(height: 16),
                                    ],
                                  );
                                },
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
            errorWidget: (context, url, error) => const PhosphorIcon(
              PhosphorIcons.trophy,
              size: 16,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name.toUpperCase(),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const PhosphorIcon(PhosphorIcons.caretRight, size: 14, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
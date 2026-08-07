import 'dart:async';
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
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, List<MatchModel>> _groupedMatches = {};
  DateTime _selectedDate = DateTime.now();
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    // Carrega os jogos imediatamente ao abrir o ecrã
    _fetchMatchesForDate(_selectedDate);

    // Atualiza automaticamente em segundo plano a cada 10 segundos
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchMatchesForDate(_selectedDate, isSilentRefresh: true);
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel(); // Cancela o timer para libertar memória
    super.dispose();
  }

  Future<void> _fetchMatchesForDate(
    DateTime date, {
    bool isSilentRefresh = false,
  }) async {
    if (!isSilentRefresh) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _selectedDate = date;
      });
    }

    try {
      final dateFormatted = DateFormat('yyyy-MM-dd').format(date);
      final fetchedMatches = await _apiService.getMatchesByDate(dateFormatted);

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
        });
      }
    } catch (e) {
      if (mounted && !isSilentRefresh) {
        setState(() {
          _errorMessage = 'Falha ao ligar ao servidor Matchly.';
          _isLoading = false;
        });
      }
    }
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
              _fetchMatchesForDate(selectedDate);
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
                          _buildLeagueHeader(leagueName, leagueLogo),
                          ...matches.map(
                            (match) => MatchTileCard(match: match),
                          ),
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
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/match_model.dart';
import '../../data/services/football_api_service.dart';
import '../widgets/match_tile_card.dart';
import '../widgets/match_skeleton_loader.dart';

class LiveMatchesScreen extends StatefulWidget {
  const LiveMatchesScreen({super.key});

  @override
  State<LiveMatchesScreen> createState() => _LiveMatchesScreenState();
}

class _LiveMatchesScreenState extends State<LiveMatchesScreen> {
  final FootballApiService _apiService = FootballApiService();
  bool _isLoading = false;
  bool _hasFetched = false;
  String? _errorMessage;
  Map<String, List<MatchModel>> _groupedMatches = {};

  Future<void> _fetchLiveMatches() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final liveMatches = await _apiService.getLiveMatches();

      final Map<String, List<MatchModel>> grouped = {};
      for (var match in liveMatches) {
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
          _errorMessage = 'Erro ao carregar jogos ao vivo.';
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
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.liveRed,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'EM DIRETO',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const PhosphorIcon(PhosphorIcons.cloudArrowDown),
            tooltip: 'Atualizar Direto',
            onPressed: _fetchLiveMatches,
            color: AppColors.liveRed,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
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
                    PhosphorIcons.broadcast,
                    size: 56,
                    color: AppColors.liveRed,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Procurar jogos a decorrer agora',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.liveRed,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _fetchLiveMatches,
                    icon: const PhosphorIcon(
                      PhosphorIcons.play,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      'VER JOGOS AO VIVO',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
                'Nenhum jogo a decorrer neste momento.',
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
                    ...matches.map((match) {
                      return MatchTileCard(match: match);
                    }),
                    const SizedBox(height: 16),
                  ],
                );
              },
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

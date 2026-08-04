import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../matches/data/models/match_model.dart';
import '../../../matches/data/services/football_api_service.dart';
import '../../../matches/presentation/widgets/match_tile_card.dart';
import '../../../matches/presentation/widgets/match_standings_tab.dart';

class LeagueDetailScreen extends StatefulWidget {
  final int leagueId;
  final String leagueName;
  final String logoUrl;

  const LeagueDetailScreen({
    super.key,
    required this.leagueId,
    required this.leagueName,
    required this.logoUrl,
  });

  @override
  State<LeagueDetailScreen> createState() => _LeagueDetailScreenState();
}

class _LeagueDetailScreenState extends State<LeagueDetailScreen> {
  final FootballApiService _apiService = FootballApiService();
  bool _isLoading = true;
  List<StandingItem> _standings = [];
  List<MatchModel> _leagueMatches = [];

  @override
  void initState() {
    super.initState();
    _loadLeagueData();
  }

  Future<void> _loadLeagueData() async {
    setState(() => _isLoading = true);
    try {
      // Procura dados reais da Liga (Classificação e Jogos da época atual)
      final standingsData = await _apiService.getStandingsByLeague(widget.leagueId);
      final matchesData = await _apiService.getMatchesByLeague(widget.leagueId);

      if (mounted) {
        setState(() {
          _standings = standingsData;
          _leagueMatches = matchesData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const PhosphorIcon(PhosphorIcons.caretLeft, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              CachedNetworkImage(imageUrl: widget.logoUrl, width: 22, height: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.leagueName.toUpperCase(),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.primaryOrange,
            labelColor: AppColors.primaryOrange,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'Classificação'),
              Tab(text: 'Jogos'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange))
            : TabBarView(
                children: [
                  MatchStandingsTab(standings: _standings),
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: _leagueMatches.length,
                    itemBuilder: (context, index) {
                      return MatchTileCard(match: _leagueMatches[index]);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
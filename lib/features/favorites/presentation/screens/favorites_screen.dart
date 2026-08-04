import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../matches/data/models/match_model.dart';
import '../../../matches/presentation/widgets/match_tile_card.dart';
import '../../data/services/favorites_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<MatchModel> _favoriteMatches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await FavoritesService.getFavoriteMatches();
    
    if (mounted) {
      setState(() {
        _favoriteMatches = favorites;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'JOGOS FAVORITOS',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const PhosphorIcon(PhosphorIcons.arrowsClockwise),
            onPressed: _loadFavorites,
            color: AppColors.primaryOrange,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange))
          : _favoriteMatches.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PhosphorIcon(
                        PhosphorIcons.star,
                        size: 56,
                        color: AppColors.textMuted.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ainda não segues nenhum jogo.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Clica na estrela de um jogo para o teres sempre à mão!',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: AppColors.primaryOrange,
                  onRefresh: _loadFavorites,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: _favoriteMatches.length,
                    itemBuilder: (context, index) {
                      final match = _favoriteMatches[index];
                      return MatchTileCard(
                        key: ValueKey(match.id),
                        match: match,
                        onFavoriteToggle: _loadFavorites,
                      );
                    },
                  ),
                ),
    );
  }
}
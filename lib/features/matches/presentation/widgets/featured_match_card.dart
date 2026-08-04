import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../screens/match_detail_screen.dart';
import '../../data/models/match_model.dart';

class FeaturedMatchCard extends StatefulWidget {
  final String leagueName;
  final String homeTeam;
  final String awayTeam;
  final String homeLogoUrl;
  final String awayLogoUrl;
  final String matchTime;
  final String bgImageUrl;

  const FeaturedMatchCard({
    super.key,
    required this.leagueName,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogoUrl,
    required this.awayLogoUrl,
    required this.matchTime,
    required this.bgImageUrl,
  });

  @override
  State<FeaturedMatchCard> createState() => _FeaturedMatchCardState();
}

class _FeaturedMatchCardState extends State<FeaturedMatchCard> {
  int? _votedOption; // 0 = Casa, 1 = Empate, 2 = Fora

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // 1. Imagem de Fundo
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: widget.bgImageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: AppColors.surface),
                errorWidget: (context, url, error) =>
                    Container(color: AppColors.surface),
              ),
            ),

            // 2. Overlay com Gradiente
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.85),
                      Colors.black.withValues(alpha: 0.40),
                      Colors.black.withValues(alpha: 0.90),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // 3. Conteúdo Clicável (Abre os detalhes do jogo)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Cria um objeto temporário para o jogo em destaque
                    final featuredMatch = MatchModel(
                      id: 1, // Ou o ID da API
                      leagueName: widget.leagueName,
                      leagueLogo: '',
                      homeTeam: widget.homeTeam,
                      awayTeam: widget.awayTeam,
                      homeLogo: widget.homeLogoUrl,
                      awayLogo: widget.awayLogoUrl,
                      statusShort: 'NS',
                      matchDate: DateTime.now(),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MatchDetailScreen(match: featuredMatch),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.leagueName.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.star_border,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                          ],
                        ),

                        const Spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: widget.homeLogoUrl,
                                    height: 42,
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.sports_soccer,
                                          size: 40,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.homeTeam,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight.withValues(
                                  alpha: 0.8,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Text(
                                widget.matchTime,
                                style: const TextStyle(
                                  color: AppColors.primaryOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: widget.awayLogoUrl,
                                    height: 42,
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.sports_soccer,
                                          size: 40,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.awayTeam,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // 4. Botões de Votação (Impedem a navegação ao votar)
                        Row(
                          children: [
                            _buildVoteButton(0, widget.homeTeam),
                            const SizedBox(width: 8),
                            _buildVoteButton(1, 'Empate'),
                            const SizedBox(width: 8),
                            _buildVoteButton(2, widget.awayTeam),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildVoteButton(int index, String label) {
    final isSelected = _votedOption == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _votedOption = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 32,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryOrange
                : Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primaryOrange : Colors.white12,
            ),
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

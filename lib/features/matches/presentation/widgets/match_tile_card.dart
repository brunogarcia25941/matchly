import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../screens/match_detail_screen.dart';

enum MatchStatus { scheduled, live, finished }

class MatchTileCard extends StatefulWidget {
  final String homeTeam;
  final String awayTeam;
  final String homeLogoUrl;
  final String awayLogoUrl;
  final String? homeScore;
  final String? awayScore;
  final String timeOrMinute; // Ex: "15:00", "74'", "FT"
  final MatchStatus status;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const MatchTileCard({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogoUrl,
    required this.awayLogoUrl,
    this.homeScore,
    this.awayScore,
    required this.timeOrMinute,
    required this.status,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  State<MatchTileCard> createState() => _MatchTileCardState();
}

class _MatchTileCardState extends State<MatchTileCard> {
  late bool _favorite;

  @override
  void initState() {
    super.initState();
    _favorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final isLive = widget.status == MatchStatus.live;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchDetailScreen(
              homeTeam: widget.homeTeam,
              awayTeam: widget.awayTeam,
              homeLogoUrl: widget.homeLogoUrl,
              awayLogoUrl: widget.awayLogoUrl,
              homeScore: widget.homeScore,
              awayScore: widget.awayScore,
              leagueName: 'Liga Portugal',
              matchStatusOrTime: widget.timeOrMinute,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLive
                ? AppColors.liveRed.withValues(alpha: 0.3)
                : AppColors.surfaceLight,
            width: isLive ? 1 : 0.5,
          ),
        ),
        child: Row(
          children: [
            // 1. Estado / Hora / Minuto
            SizedBox(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.timeOrMinute,
                    style: TextStyle(
                      color: isLive
                          ? AppColors.liveRed
                          : AppColors.textSecondary,
                      fontWeight: isLive ? FontWeight.bold : FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  if (isLive) ...[
                    const SizedBox(height: 2),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.liveRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Divisor Vertical Fino
            Container(
              height: 36,
              width: 1,
              color: AppColors.surfaceLight,
              margin: const EdgeInsets.only(right: 12),
            ),

            // 2. Equipas e Nomes
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Equipa Casa
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.homeLogoUrl,
                        width: 20,
                        height: 20,
                        errorWidget: (context, url, error) =>
                            const PhosphorIcon(
                              PhosphorIcons.soccerBall,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.homeTeam,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.homeScore != null)
                        Text(
                          widget.homeScore!,
                          style: TextStyle(
                            color: isLive
                                ? AppColors.primaryOrange
                                : AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Equipa Fora
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.awayLogoUrl,
                        width: 20,
                        height: 20,
                        errorWidget: (context, url, error) =>
                            const PhosphorIcon(
                              PhosphorIcons.soccerBall,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.awayTeam,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.awayScore != null)
                        Text(
                          widget.awayScore!,
                          style: TextStyle(
                            color: isLive
                                ? AppColors.primaryOrange
                                : AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // 3. Botão Favorito (Estrela)
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _favorite = !_favorite;
                });
                if (widget.onFavoriteToggle != null) widget.onFavoriteToggle!();
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: PhosphorIcon(
                  _favorite ? PhosphorIcons.starFill : PhosphorIcons.star,
                  color: _favorite
                      ? AppColors.primaryOrange
                      : AppColors.textMuted,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

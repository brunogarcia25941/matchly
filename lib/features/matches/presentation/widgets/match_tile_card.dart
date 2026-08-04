import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/match_model.dart';
import '../screens/match_detail_screen.dart';
import '../../../favorites/data/services/favorites_service.dart';

enum MatchStatus { scheduled, live, finished }

class MatchTileCard extends StatefulWidget {
  final MatchModel match;
  final VoidCallback? onFavoriteToggle;

  const MatchTileCard({super.key, required this.match, this.onFavoriteToggle});

  @override
  State<MatchTileCard> createState() => _MatchTileCardState();
}

class _MatchTileCardState extends State<MatchTileCard> {
  bool _favorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final isFav = await FavoritesService.isMatchFavorite(widget.match.id);
    if (mounted) {
      setState(() {
        _favorite = isFav;
      });
    }
  }

  MatchStatus _calculateStatus() {
    final s = widget.match.statusShort;
    if (['1H', '2H', 'HT', 'ET', 'P', 'LIVE'].contains(s))
      return MatchStatus.live;
    if (['FT', 'AET', 'PEN'].contains(s)) return MatchStatus.finished;
    return MatchStatus.scheduled;
  }

  @override
  Widget build(BuildContext context) {
    final status = _calculateStatus();
    final isLive = status == MatchStatus.live;

    String timeOrMinute;
    if (isLive) {
      timeOrMinute = widget.match.elapsedMinute ?? 'LIVE';
    } else if (status == MatchStatus.finished) {
      timeOrMinute = 'FT';
    } else {
      timeOrMinute =
          "${widget.match.matchDate.hour.toString().padLeft(2, '0')}:${widget.match.matchDate.minute.toString().padLeft(2, '0')}";
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchDetailScreen(match: widget.match),
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
            // 1. Hora / Minuto
            SizedBox(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timeOrMinute,
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
            Container(
              height: 36,
              width: 1,
              color: AppColors.surfaceLight,
              margin: const EdgeInsets.only(right: 12),
            ),
            // 2. Equipas
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.match.homeLogo,
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
                          widget.match.homeTeam,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.match.homeGoals != null)
                        Text(
                          '${widget.match.homeGoals}',
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
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.match.awayLogo,
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
                          widget.match.awayTeam,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.match.awayGoals != null)
                        Text(
                          '${widget.match.awayGoals}',
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
            // 3. Estrela de Jogo Favorito
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                try {
                  final isNowFav = await FavoritesService.toggleFavoriteMatch(
                    widget.match,
                  );
                  if (mounted) {
                    setState(() {
                      _favorite = isNowFav;
                    });
                  }
                  if (widget.onFavoriteToggle != null)
                    widget.onFavoriteToggle!();
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: AppColors.primaryOrange,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
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

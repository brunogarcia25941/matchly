import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';

enum TimelineEventType { goal, yellowCard, redCard, substitution, varDecision }

class TimelineEvent {
  final String minute;
  final TimelineEventType type;
  final String playerName;
  final String? secondaryPlayerName; // Ex: quem deu a assistência ou quem saiu
  final bool isHomeTeam;

  const TimelineEvent({
    required this.minute,
    required this.type,
    required this.playerName,
    this.secondaryPlayerName,
    required this.isHomeTeam,
  });
}

class MatchTimelineTab extends StatelessWidget {
  final List<TimelineEvent> events;

  const MatchTimelineTab({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Text(
          'Sem eventos registados',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildTimelineRow(event);
      },
    );
  }

  Widget _buildTimelineRow(TimelineEvent event) {
    return Row(
      children: [
        // Lado Esquerdo (Equipa Casa)
        Expanded(
          child: event.isHomeTeam
              ? _buildEventContent(event, CrossAxisAlignment.end, TextAlign.right)
              : const SizedBox.shrink(),
        ),

        // Centro (Minuto do Jogo)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white10),
          ),
          child: Text(
            event.minute,
            style: const TextStyle(
              color: AppColors.primaryOrange,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Lado Direito (Equipa Fora)
        Expanded(
          child: !event.isHomeTeam
              ? _buildEventContent(event, CrossAxisAlignment.start, TextAlign.left)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildEventContent(TimelineEvent event, CrossAxisAlignment alignment, TextAlign textAlign) {
    return Row(
      mainAxisAlignment: event.isHomeTeam ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!event.isHomeTeam) _getEventIcon(event.type),
        if (!event.isHomeTeam) const SizedBox(width: 8),

        Flexible(
          child: Column(
            crossAxisAlignment: alignment,
            children: [
              Text(
                event.playerName,
                textAlign: textAlign,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (event.secondaryPlayerName != null) ...[
                const SizedBox(height: 2),
                Text(
                  event.type == TimelineEventType.substitution
                      ? 'Entrou: ${event.secondaryPlayerName}'
                      : 'Ast: ${event.secondaryPlayerName}',
                  textAlign: textAlign,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),

        if (event.isHomeTeam) const SizedBox(width: 8),
        if (event.isHomeTeam) _getEventIcon(event.type),
      ],
    );
  }

  Widget _getEventIcon(TimelineEventType type) {
    switch (type) {
      case TimelineEventType.goal:
        return const PhosphorIcon(PhosphorIcons.soccerBallFill, color: Colors.white, size: 18);
      case TimelineEventType.yellowCard:
        return Container(
          width: 12,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFFFFCC00),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      case TimelineEventType.redCard:
        return Container(
          width: 12,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.liveRed,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      case TimelineEventType.substitution:
        return const PhosphorIcon(PhosphorIcons.arrowsLeftRight, color: AppColors.greenSuccess, size: 18);
      case TimelineEventType.varDecision:
        return const PhosphorIcon(PhosphorIcons.television, color: AppColors.primaryOrange, size: 18);
    }
  }
}
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';

class MatchDetailScreen extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final String homeLogoUrl;
  final String awayLogoUrl;
  final String? homeScore;
  final String? awayScore;
  final String leagueName;
  final String matchStatusOrTime;

  const MatchDetailScreen({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogoUrl,
    required this.awayLogoUrl,
    this.homeScore,
    this.awayScore,
    required this.leagueName,
    required this.matchStatusOrTime,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const PhosphorIcon(PhosphorIcons.caretLeft, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            leagueName.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const PhosphorIcon(PhosphorIcons.star, color: AppColors.textPrimary),
              onPressed: () {},
            ),
            IconButton(
              icon: const PhosphorIcon(PhosphorIcons.bell, color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            // 1. Cabeçalho com Placar do Jogo
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              color: AppColors.background,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Equipa Casa
                  Expanded(
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: homeLogoUrl,
                          height: 54,
                          width: 54,
                          errorWidget: (context, url, error) => const PhosphorIcon(PhosphorIcons.soccerBall, size: 50),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          homeTeam,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Resultado / Estado
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          (homeScore != null && awayScore != null)
                              ? '$homeScore - $awayScore'
                              : matchStatusOrTime,
                          style: const TextStyle(
                            color: AppColors.primaryOrange,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            matchStatusOrTime,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Equipa Fora
                  Expanded(
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: awayLogoUrl,
                          height: 54,
                          width: 54,
                          errorWidget: (context, url, error) => const PhosphorIcon(PhosphorIcons.soccerBall, size: 50),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          awayTeam,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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

            // 2. TabBar de Navegação Interna
            Container(
              color: AppColors.surface,
              child: const TabBar(
                indicatorColor: AppColors.primaryOrange,
                labelColor: AppColors.primaryOrange,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorWeight: 3,
                tabs: [
                  Tab(text: 'Resumo'),
                  Tab(text: 'Estatísticas'),
                  Tab(text: 'Onzes'),
                  Tab(text: 'Tabela'),
                ],
              ),
            ),

            // 3. Conteúdo dos Separadores
            const Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('Resumo do Jogo', style: TextStyle(color: AppColors.textPrimary))),
                  Center(child: Text('Estatísticas (xG, Posse, Remates)', style: TextStyle(color: AppColors.textPrimary))),
                  Center(child: Text('Onzes Iniciais e Suplentes', style: TextStyle(color: AppColors.textPrimary))),
                  Center(child: Text('Classificação em Direto', style: TextStyle(color: AppColors.textPrimary))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
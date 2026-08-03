import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import 'home_matches_screen.dart';
import 'live_matches_screen.dart';
import '../../../leagues/presentation/screens/leagues_screen.dart';
import '../../../favorites/presentation/screens/favorites_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeMatchesScreen(),
    LiveMatchesScreen(),
    LeaguesScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.surfaceLight, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primaryOrange,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIcons.soccerBall),
              activeIcon: PhosphorIcon(PhosphorIcons.soccerBallFill),
              label: 'Jogos',
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIcons.broadcast),
              activeIcon: PhosphorIcon(
                PhosphorIcons.broadcastFill,
                color: AppColors.liveRed,
              ),
              label: 'Ao Vivo',
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIcons.trophy),
              activeIcon: PhosphorIcon(PhosphorIcons.trophyFill),
              label: 'Ligas',
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIcons.star),
              activeIcon: PhosphorIcon(PhosphorIcons.starFill),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIcons.user),
              activeIcon: PhosphorIcon(PhosphorIcons.userFill),
              label: 'Conta',
            ),
          ],
        ),
      ),
    );
  }
}

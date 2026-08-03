import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'features/matches/presentation/screens/main_navigation_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Garante que o binding do Flutter está inicializado
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env"); // Carrega as variáveis de ambiente
  
  // Inicializa os dados de data para o idioma Português
  await initializeDateFormatting('pt_PT', null);

  runApp(const MatchlyApp());
}

class MatchlyApp extends StatelessWidget {
  const MatchlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matchly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationScreen(),
    );
  }
}
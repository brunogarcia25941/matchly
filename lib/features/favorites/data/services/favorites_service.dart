import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../matches/data/models/match_model.dart';

class FavoritesService {
  static const String _keyFavoriteMatches = 'favorite_matches_data';

  /// Guarda ou remove um jogo completo dos favoritos
  static Future<bool> toggleFavoriteMatch(MatchModel match) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> currentList = prefs.getStringList(_keyFavoriteMatches) ?? [];

    List<MatchModel> matches = currentList
        .map((item) => MatchModel.fromMap(json.decode(item)))
        .toList();

    final existsIndex = matches.indexWhere((m) => m.id == match.id);

    if (existsIndex >= 0) {
      matches.removeAt(existsIndex);
    } else {
      matches.add(match);
    }

    final updatedJsonList = matches.map((m) => json.encode(m.toMap())).toList();
    await prefs.setStringList(_keyFavoriteMatches, updatedJsonList);

    return existsIndex < 0; // Retorna true se foi adicionado, false se foi removido
  }

  /// Procura todos os jogos guardados nos favoritos
  static Future<List<MatchModel>> getFavoriteMatches() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> currentList = prefs.getStringList(_keyFavoriteMatches) ?? [];

    return currentList
        .map((item) => MatchModel.fromMap(json.decode(item)))
        .toList();
  }

  /// Verifica se um jogo está na lista de favoritos pelo ID
  static Future<bool> isMatchFavorite(int matchId) async {
    final matches = await getFavoriteMatches();
    return matches.any((m) => m.id == matchId);
  }
}
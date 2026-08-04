import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../presentation/widgets/match_standings_tab.dart';
import '../../presentation/widgets/match_timeline_tab.dart';

class FootballApiService {
  static const String _baseUrl = 'https://v3.football.api-sports.io';

  static String get _apiKey => dotenv.env['FOOTBALL_API_KEY'] ?? '';

  static Map<String, String> get _headers => {
    'x-apisports-key': _apiKey,
    'x-rapidapi-host': 'v3.football.api-sports.io',
  };

  /// Procura os jogos para uma data específica (Formato YYYY-MM-DD)
  Future<List<MatchModel>> getMatchesByDate(String dateFormatted) async {
    final url = Uri.parse('$_baseUrl/fixtures?date=$dateFormatted');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['response'] ?? [];

        return results
            .map((jsonItem) => MatchModel.fromJson(jsonItem))
            .toList();
      } else {
        throw Exception(
          'Erro ao carregar jogos da API: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Falha de rede ou API: $e');
    }
  }

  /// Procura todos os jogos que estão a decorrer em tempo real (Ao Vivo)
  Future<List<MatchModel>> getLiveMatches() async {
    final url = Uri.parse('$_baseUrl/fixtures?live=all');

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['response'] ?? [];

        return results
            .map((jsonItem) => MatchModel.fromJson(jsonItem))
            .toList();
      } else {
        throw Exception(
          'Erro ao carregar jogos ao vivo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Falha de rede ou API: $e');
    }
  }

  List<StandingItem> _parseStandings(List standingsJson) {
    return standingsJson.map((item) {
      return StandingItem(
        position: item['rank'],
        teamName: item['team']['name'],
        logoUrl: item['team']['logo'],
        played: item['all']['played'],
        goalDifference: item['goalsDiff'],
        points: item['points'],
      );
    }).toList();
  }

  /// 1. Procura a classificação oficial da época
  Future<List<StandingItem>> getStandingsByLeague(int leagueId) async {
    // Épocas a testar: 2025 (atual europeia) e 2024
    for (int season in [2025, 2024]) {
      final url = Uri.parse('$_baseUrl/standings?league=$leagueId&season=$season');
      try {
        final response = await http.get(url, headers: _headers);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List standingsJson = data['response']?[0]?['league']?['standings']?[0] ?? [];
          if (standingsJson.isNotEmpty) {
            return _parseStandings(standingsJson);
          }
        }
      } catch (_) {}
    }
    return [];
  }

  /// 2. Procura a lista de jogos de uma liga
  Future<List<MatchModel>> getMatchesByLeague(int leagueId) async {
    for (int season in [2025, 2024]) {
      final url = Uri.parse('$_baseUrl/fixtures?league=$leagueId&season=$season');
      try {
        final response = await http.get(url, headers: _headers);
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> results = data['response'] ?? [];
          if (results.isNotEmpty) {
            return results.map((jsonItem) => MatchModel.fromJson(jsonItem)).toList();
          }
        }
      } catch (_) {}
    }
    return [];
  }

  /// 3. Procura os eventos comparando o ID ou o Nome da equipa
  Future<List<TimelineEvent>> getMatchEvents(
    int fixtureId,
    int? homeTeamId, {
    String? homeTeamName,
  }) async {
    final url = Uri.parse('$_baseUrl/fixtures/events?fixture=$fixtureId');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List eventsJson = data['response'] ?? [];
        return eventsJson.map((item) {
          final typeStr = item['type'];
          TimelineEventType type = TimelineEventType.goal;
          if (typeStr == 'Card' && item['detail'] == 'Yellow Card') type = TimelineEventType.yellowCard;
          if (typeStr == 'Card' && item['detail'] == 'Red Card') type = TimelineEventType.redCard;
          if (typeStr == 'subst') type = TimelineEventType.substitution;
          if (typeStr == 'Var') type = TimelineEventType.varDecision;

          final eventTeamId = item['team']?['id'];
          final eventTeamName = item['team']?['name'] ?? '';

          // Lógica de identificação da equipa da casa:
          // 1. Por ID se ambos existirem
          // 2. Por nome se o ID falhar
          bool isHome = false;
          if (homeTeamId != null && eventTeamId != null) {
            isHome = (eventTeamId == homeTeamId);
          } else if (homeTeamName != null && homeTeamName.isNotEmpty) {
            isHome = eventTeamName.toLowerCase().contains(homeTeamName.toLowerCase());
          }

          return TimelineEvent(
            minute: "${item['time']['elapsed']}'",
            type: type,
            playerName: item['player']['name'] ?? 'Jogador',
            secondaryPlayerName: item['assist']?['name'],
            isHomeTeam: isHome,
          );
        }).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Procura um único jogo pelo seu ID para atualizar o estado real
  Future<MatchModel?> getMatchById(int matchId) async {
    final url = Uri.parse('$_baseUrl/fixtures?id=$matchId');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['response'] ?? [];
        if (results.isNotEmpty) {
          return MatchModel.fromJson(results.first);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

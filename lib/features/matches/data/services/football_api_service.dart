import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match_model.dart';
import '../../presentation/widgets/match_standings_tab.dart';
import '../../presentation/widgets/match_timeline_tab.dart';

class FootballApiService {
  static const String _baseUrl = 'https://matchly-api-8odk.onrender.com/api';

  /// Procura os jogos para a data selecionada no servidor
  Future<List<MatchModel>> getMatchesByDate(String dateFormatted) async {
    final url = Uri.parse('$_baseUrl/matches?date=$dateFormatted');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['data'] ?? [];
        return results
            .map((jsonItem) => MatchModel.fromJson(jsonItem))
            .toList();
      } else {
        throw Exception(
          'Erro ao carregar jogos do servidor: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Falha de rede ou servidor: $e');
    }
  }

  /// Procura os jogos ao vivo (lê da cache do servidor)
  Future<List<MatchModel>> getLiveMatches() async {
    final url = Uri.parse('$_baseUrl/matches');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['data'] ?? [];

        // Filtra em memória os jogos que estão a decorrer
        final liveMatches = results.where((item) {
          final status = item['fixture']?['status']?['short'];
          return ['1H', '2H', 'HT', 'ET', 'P', 'LIVE'].contains(status);
        }).toList();

        return liveMatches
            .map((jsonItem) => MatchModel.fromJson(jsonItem))
            .toList();
      } else {
        throw Exception(
          'Erro ao carregar jogos ao vivo: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Falha de rede ou servidor: $e');
    }
  }

  /// Procura a classificação oficial de uma liga guardada no servidor
  Future<List<StandingItem>> getStandingsByLeague(int leagueId) async {
    final url = Uri.parse('$_baseUrl/standings/$leagueId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List standingsJson = data['data'] ?? [];
        if (standingsJson.isNotEmpty) {
          return _parseStandings(standingsJson);
        }
      }
      return [];
    } catch (_) {
      return [];
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

  /// Procura a lista de jogos de uma liga específica a partir da cache do servidor
  Future<List<MatchModel>> getMatchesByLeague(int leagueId) async {
    final url = Uri.parse('$_baseUrl/matches');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['data'] ?? [];
        
        final leagueMatches = results.where((item) {
          return item['league']?['id'] == leagueId;
        }).toList();

        return leagueMatches.map((jsonItem) => MatchModel.fromJson(jsonItem)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Procura os eventos de um jogo específico
  Future<List<TimelineEvent>> getMatchEvents(
    int fixtureId,
    int? homeTeamId, {
    String? homeTeamName,
  }) async {
    // Como desativámos os eventos on-demand para garantir o limite de 80 pedidos/dia,
    // retorna lista vazia por agora sem consumir a API externa.
    return [];
  }

  /// Procura um único jogo pelo seu ID atualizando a partir da lista em memória
  Future<MatchModel?> getMatchById(int matchId) async {
    final url = Uri.parse('$_baseUrl/matches');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['data'] ?? [];
        
        final matchJson = results.firstWhere(
          (item) => item['fixture']?['id'] == matchId,
          orElse: () => null,
        );

        if (matchJson != null) {
          return MatchModel.fromJson(matchJson);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
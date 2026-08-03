import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

        return results.map((jsonItem) => MatchModel.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Erro ao carregar jogos da API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha de rede ou API: $e');
    }
  }
}
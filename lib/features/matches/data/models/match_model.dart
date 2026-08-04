class MatchModel {
  final int id;
  final String leagueName;
  final String leagueLogo;
  final String homeTeam;
  final String awayTeam;
  final String homeLogo;
  final String awayLogo;
  final int? homeGoals;
  final int? awayGoals;
  final String statusShort;
  final String? elapsedMinute;
  final DateTime matchDate;

  MatchModel({
    required this.id,
    required this.leagueName,
    required this.leagueLogo,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogo,
    required this.awayLogo,
    this.homeGoals,
    this.awayGoals,
    required this.statusShort,
    this.elapsedMinute,
    required this.matchDate,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    final fixture = json['fixture'];
    final league = json['league'];
    final teams = json['teams'];
    final goals = json['goals'];
    final status = fixture['status'];

    return MatchModel(
      id: fixture['id'],
      leagueName: league['name'] ?? '',
      leagueLogo: league['logo'] ?? '',
      homeTeam: teams['home']['name'] ?? '',
      awayTeam: teams['away']['name'] ?? '',
      homeLogo: teams['home']['logo'] ?? '',
      awayLogo: teams['away']['logo'] ?? '',
      homeGoals: goals['home'],
      awayGoals: goals['away'],
      statusShort: status['short'] ?? 'NS',
      elapsedMinute: status['elapsed'] != null ? "${status['elapsed']}'" : null,
      matchDate: DateTime.parse(fixture['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'leagueName': leagueName,
      'leagueLogo': leagueLogo,
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeLogo': homeLogo,
      'awayLogo': awayLogo,
      'homeGoals': homeGoals,
      'awayGoals': awayGoals,
      'statusShort': statusShort,
      'elapsedMinute': elapsedMinute,
      'matchDate': matchDate.toIso8601String(),
    };
  }

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      id: map['id'],
      leagueName: map['leagueName'] ?? '',
      leagueLogo: map['leagueLogo'] ?? '',
      homeTeam: map['homeTeam'] ?? '',
      awayTeam: map['awayTeam'] ?? '',
      homeLogo: map['homeLogo'] ?? '',
      awayLogo: map['awayLogo'] ?? '',
      homeGoals: map['homeGoals'],
      awayGoals: map['awayGoals'],
      statusShort: map['statusShort'] ?? 'NS',
      elapsedMinute: map['elapsedMinute'],
      matchDate: DateTime.parse(map['matchDate']),
    );
  }
}
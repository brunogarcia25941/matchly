import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../matches/data/models/match_model.dart';
import '../../../matches/data/services/football_api_service.dart';

class FavoritesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FootballApiService _apiService = FootballApiService();

  static CollectionReference? _getUserFavoritesCollection() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore.collection('users').doc(user.uid).collection('favorite_matches');
  }

  /// Adiciona ou remove um jogo dos Favoritos no Firestore
  static Future<bool> toggleFavoriteMatch(MatchModel match) async {
    final collection = _getUserFavoritesCollection();
    if (collection == null) {
      throw 'Necessário iniciar sessão para guardar favoritos.';
    }

    final docRef = collection.doc(match.id.toString());
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
      return false; // Foi removido
    } else {
      await docRef.set({
        'matchId': match.id,
        'addedAt': FieldValue.serverTimestamp(),
      });
      return true; // Foi adicionado
    }
  }

  /// Procura os Favoritos da conta
  static Future<List<MatchModel>> getFavoriteMatches() async {
    final collection = _getUserFavoritesCollection();
    if (collection == null) return [];

    try {
      final snapshot = await collection.get();
      if (snapshot.docs.isEmpty) return [];

      List<MatchModel> updatedMatches = [];
      for (var doc in snapshot.docs) {
        final matchId = doc['matchId'] as int;
        final freshMatch = await _apiService.getMatchById(matchId);
        if (freshMatch != null) {
          updatedMatches.add(freshMatch);
        }
      }
      return updatedMatches;
    } catch (_) {
      return [];
    }
  }

  /// Verifica se um jogo está nos favoritos
  static Future<bool> isMatchFavorite(int matchId) async {
    final collection = _getUserFavoritesCollection();
    if (collection == null) return false;

    try {
      final doc = await collection.doc(matchId.toString()).get();
      return doc.exists;
    } catch (_) {
      return false;
    }
  }
}
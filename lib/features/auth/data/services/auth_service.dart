import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/security/secure_storage_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Obtém o utilizador atual
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream para ouvir alterações no estado da sessão
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Registo com E-mail e Password (com validação robusta)
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Envia e-mail de verificação para garantir que o e-mail existe
      await credential.user?.sendEmailVerification();

      // Persiste o token de ID de forma cifrada no Keystore
      final token = await credential.user?.getIdToken();
      if (token != null) {
        await SecureStorageService.saveTokens(
          accessToken: token,
          refreshToken: credential.user?.refreshToken ?? '',
        );
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Login com E-mail e Password
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final token = await credential.user?.getIdToken();
      if (token != null) {
        await SecureStorageService.saveTokens(
          accessToken: token,
          refreshToken: credential.user?.refreshToken ?? '',
        );
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Envio de e-mail para recuperação de password (Reset)
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Terminar Sessão (Logout Seguro)
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await SecureStorageService.clearSession();
  }

  /// Tratamento de exceções com mensagens amigáveis e seguras
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou palavra-passe incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail já se encontra registado.';
      case 'weak-password':
        return 'A palavra-passe deve ter pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'O formato do e-mail introduzido é inválido.';
      case 'too-many-requests':
        return 'Demasiadas tentativas falhadas. Tente mais tarde.';
      default:
        return 'Ocorreu um erro de autenticação (${e.code}).';
    }
  }
}
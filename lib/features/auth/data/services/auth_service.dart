import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/security/secure_storage_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Login / Registo com a Conta Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // 1. Inicia o fluxo de seleção de conta Google no telemóvel
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw 'Login cancelado pelo utilizador.';
      }

      // 2. Obtém os detalhes da autenticação Google (Tokens)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Cria a credencial para o Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Autentica no Firebase com a credencial do Google
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      // 5. Guarda o token de forma segura no Keystore Android
      final token = await userCredential.user?.getIdToken();
      if (token != null) {
        await SecureStorageService.saveTokens(
          accessToken: token,
          refreshToken: userCredential.user?.refreshToken ?? '',
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserCredential> registerWithEmail({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.sendEmailVerification();
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

  Future<UserCredential> loginWithEmail({required String email, required String password}) async {
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

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut(); 
    await _firebaseAuth.signOut();
    await SecureStorageService.clearSession();
  }

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
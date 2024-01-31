import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? _user;

  static User? get currentUser => _user;

  static FirebaseAuth get authInstance => _auth;

  static void initAuthState() {
    _auth.authStateChanges().listen((event) {
      _user = event;
    });
  }

  static Future<void> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      await _auth.signInWithProvider(googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }
}

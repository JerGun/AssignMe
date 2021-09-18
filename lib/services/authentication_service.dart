import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<String?> signUpWithEmail(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      e.code == 'weak-password'
          ? print('The password provided is too weak.')
          : e.code == 'email-already-in-use'
              ? print('The account already exists for that email.')
              : print(e.message);
    }
  }

  Future<String?> signInWithEmail(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOutWithEmail() async {
    await _firebaseAuth.signOut();
  }

  Future signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return ;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOutWithGoogle() async {
    await googleSignIn.disconnect();
    _firebaseAuth.signOut();
  }
}

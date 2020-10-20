import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  FirebaseAuthService(this._firebaseAuth);
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Stream<User> get authStateChange => _firebaseAuth.authStateChanges();
  User get currentUser => _firebaseAuth.currentUser;
  User _user;

  Future<User> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        _user = userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    return _user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    final User user = userCredential.user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    return user;
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    print("user Signed out");
  }
}

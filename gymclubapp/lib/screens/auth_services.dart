import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get authState => auth.authStateChanges();

  User? getUser() {
    return auth.currentUser;
  }
}

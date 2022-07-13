import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laborator_sma/lib/src/models/app_user.dart';

import 'failures/failures.dart';


class FirebaseAuthRepository {
  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  Future<void> logOut() async {
    try {
      await Future.wait(
        <Future<void>>[
          _firebaseAuth.signOut(),
        ],
      );
    } catch (_) {
      throw LogOutFailure();
    }
  }

  Future<void> logInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> signUpWithEmailAndPassword(
      {required String email,
        required String password,
        }) async {
    UserCredential userCredential;
    AppUser appUser;

    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      appUser = AppUser(
          id: userCredential.user!.uid,
          email: userCredential.user!.email,);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Stream<AppUser> get user {
    return _firebaseAuth
        .authStateChanges()
        .map((firebase_auth.User? firebaseUser) {
      final AppUser user =
      firebaseUser == null ? AppUser.empty : firebaseUser.toUser;
      return user;
    });
  }

  AppUser get currentUser {
    final firebase_auth.User? firebaseUser = _firebaseAuth.currentUser;
    final AppUser user =
    firebaseUser == null ? AppUser.empty : firebaseUser.toUser;
    return user;
  }
}

extension on firebase_auth.User {
  AppUser get toUser {
    return AppUser(id: uid, email: email);
  }
}

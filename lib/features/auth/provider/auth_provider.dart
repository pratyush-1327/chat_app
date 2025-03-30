import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider {
  final FirebaseAuth _auth;
  AuthProvider(this._auth);

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile in Firestore
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': email.split('@')[0], // Default name based on email
          'email': email,
          'imageUrl': '', // Empty by default
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return userCredential;
    } catch (e) {
      return null;
    }
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final AuthProviderProvider = Provider<AuthProvider>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthProvider(firebaseAuth);
});

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  final authRepo = ref.watch(AuthProviderProvider);
  return AuthNotifier(authRepo);
});

class AuthNotifier extends StateNotifier<User?> {
  final AuthProvider _authRepository;
  AuthNotifier(this._authRepository) : super(null) {
    _authRepository.authStateChanges.listen((user) => state = user);
  }

  Future<UserCredential?> signUp(String email, String password) async {
    final userCredential = await _authRepository.signUp(email, password);
    if (userCredential != null) {
      state = userCredential.user;
    }
    return userCredential;
  }

  Future<UserCredential?> signIn(String email, String password) async {
    final userCredential = await _authRepository.signIn(email, password);
    if (userCredential != null) {
      state = userCredential.user;
    }
    return userCredential;
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = null;
  }
}

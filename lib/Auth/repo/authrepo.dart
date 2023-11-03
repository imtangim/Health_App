import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health_app/extra/failure.dart';
import 'package:health_app/extra/firebase_provider.dart';
import 'package:health_app/extra/typedef.dart';
import 'package:health_app/model/usermodel.dart';
import 'package:fpdart/fpdart.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepo(
    firestore: ref.read(fireStoreProvider),
    auth: ref.read(authProviedr),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepo {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepo(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  CollectionReference get _user => _firestore.collection("users");

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      userCredential = await _auth.signInWithCredential(credential);

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? "No Name",
          email: userCredential.user!.email ?? "No email",
          uid: userCredential.user!.uid,
          profilePic:
              "https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671116.jpg?w=996&t=st=1698985200~exp=1698985800~hmac=42f3e487ea2b4d469f2c53b896ed476427d5a9b2e9bce5edc4ddbeb257ad877a",
          body_temp: 0,
          hearth_rate: 0,
        );
        await _user.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _user.doc(uid).snapshots().map(
          (event) => UserModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  void updateUserData(String uid, double bodyTemp, int heartRate) {
    _user
        .doc(uid)
        .update({
          'body_temp': bodyTemp,
          'hearth_rate': heartRate,
        })
        .then((_) {})
        .catchError((error) {});
  }

  void logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/utils/userModel.dart';
import 'package:http/http.dart' as http;

import '../widget/my_bottom_bar.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  registerUser(
      String userid, String userMail, String photoUrl, String name) async {
    final _fireStore = FirebaseFirestore.instance;

    await _fireStore
        .collection('users')
        .orderBy('displayName', descending: true)
        .get()
        .then((value) async {
      String displayName =
          value.docs.first.data()['displayName'] ?? "000000000";
      int count = int.parse(displayName.substring(3, displayName.length));
      int values = count + 1;
      String d = "MCS${values.toString().padLeft(9, '0')}";
      FirebaseAuth.instance.currentUser!.updateDisplayName(d);

      users = Users(
          uid: this._auth.currentUser!.uid,
          fullName: name ?? " ",
          email: userMail ?? " ",
          city: " ",
          country: " ",
          mobNum: " ",
          invitationId: " ",
          isPremium: false,
          freeCourses: [],
          purchasedCourses: [],
          videosWatched: [],
          pass: " ",
          dob: " ",
          gender: " ",
          profileImage: photoUrl,
          premiumTill: " ",
          displayName: d,
          id: d,
          joiningDate: "${DateTime.now()}");
      var response = await http.get(Uri.parse(
          "https://moneysagaconsultancy.com/api/api/insert?user_id=$d&name=$name&referal_id="
          "&position=left"));

      log("Api response2: ${response.statusCode}");
      print(
          '=========================================================================');
      print(users.fullName);
      print(FirebaseAuth.instance.currentUser!.uid);
      print(users.toMap());

      Map<String, dynamic> mp = users.toMap();

      await _fireStore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(mp, SetOptions(merge: true));

      Map<String, dynamic> mpi = {
        'appNotif': false,
        'vidAlert': false,
        'appRate': 0.0,
        'rateCourse': 0.0,
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('profile')
          .doc('myProfile')
          .set(
            mpi,
          );
    });
  }

  registerFBUser(String userid, String userMail, String photoUrl, String name,
      String dob, String gender) async {
    final _fireStore = FirebaseFirestore.instance;
    await _fireStore
        .collection('users')
        .orderBy('displayName', descending: true)
        .get()
        .then((value) async {
      String displayName =
          value.docs.first.data()['displayName'] ?? "000000000";
      int count = int.parse(displayName.substring(3, displayName.length));
      int values = count + 1;
      String d = "MCS${values.toString().padLeft(9, '0')}";
      FirebaseAuth.instance.currentUser!.updateDisplayName(d);

      users = Users(
          uid: this._auth.currentUser!.uid,
          fullName: name ?? " ",
          email: userMail ?? " ",
          city: " ",
          country: " ",
          mobNum: " ",
          invitationId: " ",
          isPremium: false,
          freeCourses: [],
          purchasedCourses: [],
          videosWatched: [],
          pass: '',
          dob: dob,
          gender: gender,
          profileImage: photoUrl,
          premiumTill: '',
          displayName: d,
          id: d,
          joiningDate: "${DateTime.now()}");
      var response = await http.get(Uri.parse(
          "https://moneysagaconsultancy.com/api/api/insert?user_id=$d&name=$name&referal_id="
          "&position=left"));

      log("Api response3: ${response.statusCode}");

      await _fireStore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(users.toMap());
    });
  }

  signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await _auth.signInWithCredential(authCredential).then((value) {
          String userid = _auth.currentUser!.uid;
          String userMail = _auth.currentUser!.email ?? 'email';
          String userPhoto = googleSignInAccount.photoUrl ??
              'https://www.clipartmax.com/png/full/144-1442578_flat-person-icon-download-dummy-man.png';
          String userName = googleSignInAccount.displayName ?? 'user';
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then(((value) {
            if (!(value.exists)) {
              registerUser(userid, userMail, userPhoto, userName);
            }
          }));

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: ((context) => const MyBottomBar())));
        });
        print(googleSignInAccount.displayName);
        print('==========================');
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      throw e;
    }
  }

  //getting UID
  Future<String> getCurrentUID() async {
    return (await _auth.currentUser!).uid;
  }

  signInWithFaceboook() async {
    // print('fb ====================================');
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      await _auth.signInWithCredential(facebookAuthCredential);
      String userid = _auth.currentUser!.uid;
      String userMail = facebookAuthCredential.providerId;
      String userPhoto = '';
      String userName = '';
      registerUser(userid, userMail, userPhoto, userName);
    } on FirebaseAuthException catch (e) {
      print(e);
      throw e;
    }
  }

  signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<UserCredential> signInWithFacebook() async {
    Map<String, dynamic>? _userData;
    print(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');

    // Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']);

    // Create a credential from the access token
    final OAuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    // Once signed in, return the UserCredential

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

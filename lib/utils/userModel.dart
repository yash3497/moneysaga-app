import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/views/home/home_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Users {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  String fullName, uid, city, country, email, mobNum, invitationId, pass;

  String profileImage, gender, dob, premiumTill, displayName, id, joiningDate;
  final bool isPremium;
  final List purchasedCourses, freeCourses, videosWatched;

  Users({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.pass,
    required this.profileImage,
    required this.city,
    required this.country,
    required this.mobNum,
    required this.invitationId,
    required this.gender,
    required this.dob,
    required this.isPremium,
    required this.freeCourses,
    required this.purchasedCourses,
    required this.videosWatched,
    required this.premiumTill,
    required this.displayName,
    required this.id,
    required this.joiningDate,
  });

  factory Users.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Users(
        city: doc.data()!['city'] ?? "",
        country: doc.data()!['country'] ?? "",
        email: doc.data()!['email'] ?? "",
        freeCourses: doc.data()!['freeCourses'] ?? [],
        fullName: doc.data()!['fullName'] ?? "",
        profileImage: doc.data()!['profileImage'] ?? "",
        isPremium: doc.data()!['isPremium'] ?? false,
        mobNum: doc.data()!['mobNum'] ?? "",
        purchasedCourses: doc.data()!['purchasedCourses'] ?? [],
        uid: doc.data()!['uid'] ?? "",
        dob: doc.data()!['dob'] ?? "",
        gender: doc.data()!['gender'] ?? "",
        videosWatched: doc.data()!['videosWatched'] ?? [],
        invitationId: doc.data()!['invitationId'] ?? "",
        pass: doc.data()!['pass'] ?? "",
        premiumTill: doc.data()!['premiumTill'] ?? "",
        displayName: doc.data()!['displayName'] ?? "",
        id: doc.data()!['id'] ?? "",
        joiningDate: doc.data()!['joiningDate'] ?? "");
  }

  addEmployee(Users employeeData) async {
    String uid = employeeData.uid;
    await _db.collection("users/$uid").add(employeeData.toMap());
  }

  setProfileImage(String img) async {
    this.profileImage = img;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(users.uid)
        .set({'profileImage': img}, SetOptions(merge: true));
  }

  setGenderDOB(String dob, String gender) async {
    this.gender = gender;
    this.dob = dob;
    final _fireStore = FirebaseFirestore.instance;
    await _fireStore.collection("users").doc(users.uid).update({
      'dob': dob,
      'gender': gender,
    });
  }

  setCountry(String c) async {
    this.country = c;
  }

  setBoughtPack(Map<String, dynamic> plan, String paymentId) async {
    this.purchasedCourses.add(plan['title']);
    await FirebaseFirestore.instance
        .collection('payments')
        .doc(users.uid)
        .collection('paymentHistory')
        .doc((DateTime.now().millisecondsSinceEpoch / 1000).ceil().toString())
        .set({
      'planName': plan['title'],
      'priceINR': plan['discPrice'],
      'priceUSD': plan['usd'],
      'paymentId': paymentId,
      'time': (DateTime.now().millisecondsSinceEpoch / 1000).ceil(),
    });
    var x = await FirebaseFirestore.instance
        .collection('users')
        .doc(users.uid)
        .get();
    List list = x.data()!['purchasedCourses'];
    if (!list.contains(plan['title'])) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(users.uid)
          .update({
        'purchasedCourses': FieldValue.arrayUnion([plan['db']]),
        'isPremium': true
      });
    }
  }

  updateEmployee(Users employeeData) async {
    await _db
        .collection("Employees")
        .doc(employeeData.uid)
        .update(employeeData.toMap());
  }

  Future<void> deleteEmployee(String documentId) async {
    await _db.collection("Employees").doc(documentId).delete();
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
      'city': city,
      'country': country,
      'mobNum': mobNum,
      'invitationId': invitationId,
      'isPremium': isPremium,
      'freeCourses': freeCourses,
      'purchasedCourses': purchasedCourses,
      'videosWatched': videosWatched,
      'pass': pass,
      'gender': gender,
      'dob': dob,
      'premiumTill': premiumTill,
      'displayName': displayName,
      'id': id,
      'joiningDate': joiningDate,
    };
  }
}

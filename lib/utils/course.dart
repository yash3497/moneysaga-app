// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseContent {
  String description,
      url,
      title,
      language,
      priceINR,
      priceUSD,
      level,
      totalLectures;

  CourseContent({
    required this.url,
    required this.description,
    required this.title,
    required this.language,
    required this.priceINR,
    required this.priceUSD,
    required this.level,
    required this.totalLectures,
  });

  factory CourseContent.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return CourseContent(
      description: doc.data()!['description'],
      language: doc.data()!['language'],
      level: doc.data()!['level'],
      priceINR: doc.data()!['priceINR'].toString(),
      priceUSD: doc.data()!['priceUSD'].toString(),
      title: doc.data()!['title'],
      totalLectures: doc.data()!['totalLectures'].toString(),
      url: doc.data()!['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'url': url,
      'title': title,
      'level': level,
      'language': language,
      'priceINR': priceINR,
      'priceUSD': priceUSD,
      'totalLectures': totalLectures,
    };
  }
}

class LectureContent {
  String description, url, title, language, level, courseName, docName, rank;

  LectureContent({
    required this.url,
    required this.description,
    required this.title,
    required this.language,
    required this.level,
    required this.courseName,
    required this.docName,
    required this.rank,
  });

  factory LectureContent.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return LectureContent(
      description: doc.data()!['description'],
      language: doc.data()!['language'],
      level: doc.data()!['level'],
      title: doc.data()!['title'],
      url: doc.data()!['url'],
      courseName: doc.data()!['courseName'],
      docName: doc.data()!['docName'],
      rank: doc.data()!['rank'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'url': url,
      'title': title,
      'level': level,
      'language': language,
      'courseName': courseName,
      'docName': docName,
      'rank': rank,
    };
  }
}

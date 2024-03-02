import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magnus_app/utils/constant.dart';
import 'package:magnus_app/utils/course.dart';

Future<void> getFreeCourses() async {
  freeCourseDetails.clear();
  var docu = await FirebaseFirestore.instance
      .doc('freeCourses/v0w1gnT5nu8PWMXIKpIa')
      .get();

  var i = docu.data();
  var k = i?.values.first;

  List courseData = [];
  // print('$k');

  for (int i = 0; i < 1; i++) {
    int l = i + 1;
    // print('$l');
    var docu = await FirebaseFirestore.instance
        .doc('freeCourses/v0w1gnT5nu8PWMXIKpIa/courses$l/courseDetail')
        .get();
    // var snapshot =
    //     await FirebaseFirestore.instance.collectionGroup('courses$l').get();
    List<dynamic>? x = docu.data()?.values.toList();
    // print('$x');

    freeCourseDetails.add(x);

    var totalLectures = freeCourseDetails[i][2];
    freeCourseLectureList.clear();
    // print('========= $totalLectures');
    for (int z = 0; z < totalLectures; z++) {
      int a = z + 1;
      var docu = await FirebaseFirestore.instance
          .doc(
              'freeCourses/v0w1gnT5nu8PWMXIKpIa/courses$l/courseDetail/lectures/lecture$a')
          .get();
      List<dynamic>? y = docu.data()?.values.toList();

      freeCourseLectureList.add(y!);
    }
  }
    // print('------------------');
    // print('----------- course---- $freeCourseDetails');
    // print('----------- lecture $freeCourseLectureList');
}


Future<void> getPremiumCourses() async {
  var docu = await FirebaseFirestore.instance
      .doc('premiumCourses/v0w1gnT5nu8PWMXIKpIa')
      .get();

  var i = docu.data();
  var k = i?.values.first;

  List courseData = [];

  for (int i = 0; i < k; i++) {
    int l = i + 1;
    print('-------------------');
    var docu = await FirebaseFirestore.instance
        .doc('premiumCourses/2RPpH5VbPkwA1V5XoVxh/pCourse$l/courseDetail')
        .get();
    // var snapshot =
    //     await FirebaseFirestore.instance.collectionGroup('courses$l').get();
    List<dynamic>? x = docu.data()?.values.toList();

    premiumCourseDetails.clear();
    premiumCourseDetails.add(x);

    int totalLectures = premiumCourseDetails[i][0];
    premiumCourseLectureList.clear();
    for (int z = 0; z < totalLectures; z++) {
      int a = z + 1;
      var docu = await FirebaseFirestore.instance
          .doc(
              'premiumCourses/v0w1gnT5nu8PWMXIKpIa/pCourses$l/courseDetail/lectures/lecture$a')
          .get();
      List<dynamic>? y = docu.data()?.values.toList();

      premiumCourseLectureList.add(y!);
    }
    print('------------------');
    print('-----------prem Course $premiumCourseDetails');
    print('-----------prem Course $premiumCourseLectureList');
  }
}

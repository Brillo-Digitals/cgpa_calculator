import 'package:cgpa_calculator/data/notifier.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kbColor = Color.fromARGB(255, 128, 127, 127);
const Color kButtonColor = Color.fromRGBO(107, 182, 170, 1);
const Color kPrimaryColor = Color.fromRGBO(38, 78, 119, 1);
const Color kUnfocusedColor = Color.fromARGB(255, 230, 230, 230);
const TextStyle kmText = TextStyle(
  color: Colors.black87,
  fontWeight: FontWeight.w700,
  fontSize: 15,
);

const TextStyle ksText = TextStyle(
  color: Color.fromARGB(188, 0, 0, 0),
  fontWeight: FontWeight.w500,
  fontSize: 13,
);

TextStyle ktitleStyle = TextStyle(
  color: Colors.black54,
  fontSize: 13,
  fontWeight: FontWeight.w700,
);
List gradeList = ["A", "B", "C", "D", "E", "F"];
List revGradeList = ["F", "E", "D", "C", "B", "A"];
List gpaClassWords = [
  "First Class",
  "Second Class Upper",
  "Second Class Lower",
  "Third Class",
  "Fail",
];

String calcClass(double gpa) {
  String gpaClass = "";
  if (gpa > gpaClassList.value[0]) {
    gpaClass = gpaClassWords[0];
  } else if (gpa > gpaClassList.value[0]) {
    gpaClass = gpaClassWords[1];
  } else if (gpa > gpaClassList.value[1]) {
    gpaClass = gpaClassWords[2];
  } else if (gpa > gpaClassList.value[2]) {
    gpaClass = gpaClassWords[3];
  } else {
    gpaClass = gpaClassWords[4];
  }
  return gpaClass;
}

class MainCard extends StatelessWidget {
  const MainCard({super.key, required this.statement, required this.gpa});

  final String gpa;
  final String statement;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: kButtonColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                gpa,
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              Text(
                statement,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double calcGPA(List courseList) {
  int totalUnit = 0;
  int tlu = 0;
  if (courseList.isNotEmpty) {
    for (List course in courseList) {
      int nUnit = int.parse(course[1]);
      int nGrade = calcGrade(course[2]);
      totalUnit += nUnit;
      tlu += (nUnit * nGrade);
    }
  }
  double ngpa = tlu / totalUnit;
  double gpa = double.parse(ngpa.toStringAsFixed(2));
  return gpa;
}

int calcCumTLU(List courseList) {
  int tlu = 0;
  if (courseList.isNotEmpty) {
    for (List course in courseList) {
      int nUnit = int.parse(course[1]);
      tlu += nUnit;
    }
  }
  return tlu;
}

int calcGradePoint(List courseList) {
  int tGrade = 0;
  if (courseList.isNotEmpty) {
    for (List course in courseList) {
      int nUnit = int.parse(course[1]);
      int nGrade = calcGrade(course[2]);
      tGrade += (nUnit * nGrade);
    }
  }
  return tGrade;
}

List<List> gpaRep = [
  ["11", "12"],
  ["21", "22"],
  ["31", "32"],
  ["41", "42"],
  ["51", "52"],
];
List<String> levelList = [
  "100 Level",
  "200 Level",
  "300 Level",
  "400 Level",
  "500 Level",
];
List<String> semesterList = ["1st Semester", "2nd Semester"];

String getGpaRep(String level, int semester) {
  int levelNo = int.parse(level[0]);
  String rep = gpaRep[levelNo - 1][semester - 1];
  return rep;
}

String getSemester(String rep) {
  int semester = int.parse(rep[1]) - 1;
  return semesterList[semester];
}

String getLevel(String rep) {
  int level = int.parse(rep[0]) - 1;
  return levelList[level];
}

int calcGrade(String grade) {
  int value = 5;
  value = int.parse(gradevalues.value[gradeList.indexOf(grade)]);
  return value;
}

List<List> toMatrixList(List<String> normalList) {
  List<List> matrixList = [];
  for (int i = 0; i < (normalList.length / 3).ceil(); i++) {
    matrixList.add([]);
  }
  if (normalList.isNotEmpty) {
    for (int i = 0; i < normalList.length; i++) {
      int index = (i) ~/ 3;
      matrixList[index].add(normalList[i]);
    }
  }
  return matrixList;
}

List<String> toNormalList(List<List> matrixList) {
  List<String> normalList = [];
  for (List lists in matrixList) {
    for (String item in lists) {
      normalList.add(item);
    }
  }
  return normalList;
}

void createGPA(List<String> courseList, String name) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(name, courseList);
}

Future<List<String>?> readGPA(String name) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String>? gpaList = prefs.getStringList(name);
  return gpaList;
}

void deleteGPA(String name) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(name);
}

Future<List> getallLists() async {
  List allLists = [];
  for (List repList in gpaRep) {
    for (String rep in repList) {
      List<String>? gpa = await readGPA(rep);
      if (gpa != null) {
        allLists.addAll(toMatrixList(gpa));
      }
    }
  }
  return allLists;
}

Future<List<List>> getEachGPA() async {
  List<List> allLists = [];
  for (List repList in gpaRep) {
    for (String rep in repList) {
      List<String>? gpaList = await readGPA(rep);
      if (gpaList != null) {
        String tlu = calcCumTLU(toMatrixList(gpaList)).toString();
        String gradePoint = calcGradePoint(toMatrixList(gpaList)).toString();
        String level = getLevel(rep);
        String semester = getSemester(rep);
        double semesterGPA = calcGPA(toMatrixList(gpaList));
        allLists.add([level, semester, semesterGPA, tlu, gradePoint]);
      }
    }
  }
  return allLists;
}

Future<void> createGradeValues(List<String> grades) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('gradevalues', grades);
}

Future<void> createGradeClass(List<String> grades) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('gradeclass', grades);
}

Future<void> createMaxGPA(String gpa) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('maxgpa', gpa);
}

Future<void> readGradeValues() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String>? grades = prefs.getStringList('gradevalues');
  if (grades != null) {
    gpaClassList.value = grades;
  }
}

Future<void> readGradeClass() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String>? grades = prefs.getStringList('gradeclass');
  if (grades != null) {
    gradevalues.value = grades;
  }
}

Future<void> readMaxGPA() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? gpa = prefs.getString('maxgpa');
  if (gpa != null) {
    maxGPA.value = gpa;
  }
}

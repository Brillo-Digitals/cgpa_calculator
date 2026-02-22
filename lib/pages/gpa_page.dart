import 'package:cgpa_calculator/data/constants.dart';
import 'package:cgpa_calculator/data/notifier.dart';
import 'package:flutter/material.dart';

class GpaPage extends StatefulWidget {
  const GpaPage({super.key});

  @override
  State<GpaPage> createState() => _GpaPageState();
}

class _GpaPageState extends State<GpaPage> {
  int selectedIndex = 0;
  List<List> courseList = [];
  List<String> stringCouseList = [];

  String courseGrade = "A";
  double gpa = 0.00;

  // Controllers
  TextEditingController courseController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  //dropdown
  String levelSelectedOption = "100 Level";
  int semesterSelectedOption = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCourses();
    });
  }

  Future<void> _loadCourses() async {
    final sem = choosenSemester.value;
    final rep = getGpaRep(choosenLevel.value, sem);
    final result = await readGPA(rep);
    setState(() {
      if (result != null) {
        courseList =
            (toMatrixList(result) as List<List<dynamic>>?) ?? <List<dynamic>>[];
        gpa = 0.00;
        mainGPA.value = calcGPA(courseList).toString();
      } else {
        courseList = [];
        gpa = 0.00;
        mainGPA.value = "0.00";
      }
    });
  }

  Future<void> _loadData() async {
    allgpaList.value = await getEachGPA();
    List allMatrixList = await getallLists();
    if (allMatrixList.isNotEmpty) {
      totalGradePoint.value = calcGradePoint(allMatrixList);
      totalTLU.value = calcCumTLU(allMatrixList);
    } else {
      totalGradePoint.value = 0;
      totalTLU.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Card(
                child: SizedBox(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Course Details',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20),
                          ValueListenableBuilder(
                            valueListenable: choosenLevel,
                            builder: (context, value, child) {
                              return DropdownButton<String>(
                                value: choosenLevel.value,
                                items: levelList
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                                style: ktitleStyle,
                                onChanged: (value) {
                                  setState(() {
                                    choosenLevel.value = value!;
                                    _loadCourses();
                                  });
                                },
                              );
                            },
                          ),
                          SizedBox(width: 10),
                          ValueListenableBuilder(
                            valueListenable: choosenSemester,
                            builder: (context, value, child) {
                              return RadioGroup<int>(
                                groupValue: choosenSemester.value,
                                onChanged: (value) {
                                  setState(() {
                                    choosenSemester.value = value!;
                                    _loadCourses();
                                  });
                                },
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          child: Radio(
                                            value: 1,

                                            activeColor: Colors.greenAccent,
                                          ),
                                        ),
                                        Text(
                                          '1st Semester',
                                          style: ktitleStyle,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          child: Radio(value: 2),
                                        ),
                                        Text(
                                          '2nd Semester',
                                          style: ktitleStyle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              controller: courseController,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                labelText: "Course Name",
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: kbColor,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 2.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              controller: unitController,
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                labelText: "Unit",
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: const Color.fromARGB(
                                      31,
                                      157,
                                      157,
                                      157,
                                    ),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 2.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Course Grade : ', style: ktitleStyle),
                        Row(
                          children:
                              List.generate(gradeList.length, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                          courseGrade = gradeList[index];
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: index == selectedIndex
                                              ? kButtonColor
                                              : kUnfocusedColor,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            gradeList[index],
                                            style: TextStyle(
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                                  .expand(
                                    (element) => [element, SizedBox(width: 10)],
                                  )
                                  .toList()
                                ..removeLast(),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          courseList.add([
                            courseController.text,
                            (unitController.text).toString(),
                            courseGrade,
                          ]);
                          courseController.text = "";
                          unitController.text = "";
                        });
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: kButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 40,
                        ),
                        child: Text("Add Course"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: courseList.isNotEmpty
                      ? Column(
                          children: List.generate(courseList.length, (index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(courseList[index][0], style: kmText),
                                    SizedBox(width: 5),
                                    Text(
                                      "(${courseList[index][1]} Unit)",
                                      style: ksText,
                                    ),
                                    SizedBox(width: 5),
                                    Text(courseList[index][2], style: ksText),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      courseList.removeAt(index);
                                    });
                                  },
                                  icon: Icon(Icons.delete, color: kbColor),
                                ),
                              ],
                            );
                          }),
                        )
                      : Center(
                          child: Text(
                            "No Course Registed yet !!!",
                            style: ksText,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 10),
            MainCard(
              statement:
                  double.parse(mainGPA.value) == 0.00 ||
                      double.parse(mainGPA.value).isNaN
                  ? 'Not yet Calculated'
                  : 'current GPA (${calcClass(double.parse(mainGPA.value))})',
              gpa: ("${mainGPA.value}/${maxGPA.value}"),
            ),
            SizedBox(height: 10),
            FilledButton(
              onPressed: () {
                setState(() {
                  if (courseList.isNotEmpty) {
                    gpa = calcGPA(courseList);
                    mainGPA.value = gpa.toString();
                    String rep = getGpaRep(
                      choosenLevel.value,
                      choosenSemester.value,
                    );
                    stringCouseList = toNormalList(courseList);
                    createGPA(stringCouseList, rep);
                    _loadData();
                  }
                });
              },
              style: FilledButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
              ),
              child: Text(
                'CALCULATE/ADD GPA',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

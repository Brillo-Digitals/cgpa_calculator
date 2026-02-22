import 'package:cgpa_calculator/data/constants.dart';
import 'package:cgpa_calculator/data/notifier.dart';
import 'package:flutter/material.dart';

class GradingSystemPage extends StatefulWidget {
  const GradingSystemPage({super.key});

  @override
  State<GradingSystemPage> createState() => _GradingSystemPageState();
}

class _GradingSystemPageState extends State<GradingSystemPage> {
  TextEditingController maxGPAController = TextEditingController();
  List<TextEditingController> gradeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  List<TextEditingController> classControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  List myClassListLast = [maxGPA.value];
  @override
  void initState() {
    super.initState();
    _loadGradeController();
  }

  void _loadGradeController() {
    // for (int i = 0; i < gradeControllers.length; i++) {
    //   gradeControllers[i].text = gradevalues.value[i];
    // }
    for (int i = 0; i < classControllers.length - 1; i++) {
      myClassListLast.add(
        (double.parse(gpaClassList.value[i]) - 0.01).toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text(
                    "Grading System",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Maximum GPA: "),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              try {
                                myClassListLast[0] = value;
                              } catch (e) {
                                // Handle invalid number input
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: const Text(
                                      "Please Input Valid Number",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          });
                        },
                        controller: maxGPAController,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "e.g 5.0 0r 4.0",
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 129, 100, 100),
                            fontSize: 13,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kbColor, width: 2),
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
                      SizedBox(height: 15),
                      Text(
                        "Enter the highest possible GPA at your institution",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Grade Values: ",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children:
                        List.generate(gradeList.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Center(
                                      child: Text(
                                        "${gradeList[index]}: ",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 100,
                                      child: TextField(
                                        maxLength: 2,
                                        controller: gradeControllers[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 17,
                                        ),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 8,
                                          ),
                                          hint: Center(
                                            child: Text(
                                              gradevalues.value[index],
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                          counterText: "",
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: BorderSide(
                                              color: kbColor,
                                              width: 2,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.green,
                                              width: 2.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                            .expand(
                              (element) => [element, SizedBox(height: 15)],
                            )
                            .toList()
                          ..removeLast(),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Grade Class : ",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children:
                        List.generate(gpaClassList.value.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Center(
                                      child: Text(
                                        "${gpaClassWords[index]}: ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          width: 80,
                                          child: TextField(
                                            onChanged: (value) {
                                              setState(() {
                                                if (index <
                                                        myClassListLast.length -
                                                            1 &&
                                                    value.isNotEmpty) {
                                                  try {
                                                    myClassListLast[index + 1] =
                                                        (double.parse(value) -
                                                                0.01)
                                                            .toString();
                                                  } catch (e) {
                                                    // Handle invalid number input
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        content: const Text(
                                                          "Please Input Valid Number",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        duration:
                                                            const Duration(
                                                              seconds: 3,
                                                            ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              });
                                            },
                                            maxLength: 5,
                                            controller: classControllers[index],
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 17,
                                            ),
                                            decoration: InputDecoration(
                                              hintText:
                                                  gpaClassList.value[index],
                                              hintStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 17,
                                              ),
                                              counterText: "",
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: kbColor,
                                                  width: 2,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 2.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text("to", style: kmText),
                                        SizedBox(width: 10),
                                        Container(
                                          height: 40,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: kbColor,
                                              width: 2,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              myClassListLast[index],
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            })
                            .expand(
                              (element) => [element, SizedBox(height: 15)],
                            )
                            .toList()
                          ..removeLast(),
                  ),
                  SizedBox(height: 15),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        List contList = [maxGPAController];
                        for (int i = 0; i < gradeControllers.length; i++) {
                          contList.add(gradeControllers[i]);
                        }
                        for (int i = 0; i < classControllers.length; i++) {
                          contList.add(classControllers[i]);
                        }
                        bool anyEmpty = contList.any(
                          (c) => c.text.trim().isEmpty,
                        );
                        if (anyEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: const Text(
                                "Please Fill all Fields",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        } else {
                          maxGPAController.value.text.isNotEmpty
                              ? maxGPA.value = "${maxGPAController.text}.00"
                              : maxGPA.value = "${5}.00";
                          for (int i = 0; i < gradeControllers.length; i++) {
                            if (gradeControllers[i].value.text.isNotEmpty) {
                              gradevalues.value[i] = gradeControllers[i].text;
                            }
                          }
                          for (int i = 0; i < classControllers.length; i++) {
                            if (classControllers[i].value.text.isNotEmpty) {
                              gpaClassList.value[i] = gradeControllers[i].text;
                            }
                          }
                          createGradeValues(gradevalues.value);
                          createMaxGPA(maxGPA.value);
                          SnackBar(
                            backgroundColor: Colors.greenAccent,
                            content: const Text(
                              "Grading Details Updated Successfully",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            duration: const Duration(seconds: 3),
                          );
                        }
                      });
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Save Grading System',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

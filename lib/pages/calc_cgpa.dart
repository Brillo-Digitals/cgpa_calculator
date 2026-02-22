import 'package:cgpa_calculator/data/constants.dart';
import 'package:cgpa_calculator/data/notifier.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CalcCGPAPage extends StatefulWidget {
  CalcCGPAPage({
    super.key,
    required this.totalGP,
    required this.totalTlu,
    required this.allList,
  });
  late int totalGP;
  late int totalTlu;
  final List allList;

  @override
  State<CalcCGPAPage> createState() => _CalcCGPAPageState();
}

class _CalcCGPAPageState extends State<CalcCGPAPage> {
  String gpa = "0.00";

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
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                // HEADER
                Row(
                  children: [
                    Expanded(flex: 3, child: Text("Level", style: kmText)),
                    SizedBox(width: 10),
                    Expanded(flex: 3, child: Text("Semester", style: kmText)),
                    SizedBox(width: 10),
                    Expanded(flex: 2, child: Text("GPA", style: kmText)),
                  ],
                ),
                SizedBox(height: 15),

                // GPA LIST
                widget.allList.isNotEmpty
                    ? Column(
                        children: List.generate(widget.allList.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    widget.allList[index][0],
                                    style: ksText,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    widget.allList[index][1],
                                    style: ksText,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.allList[index][2].toString(),
                                    style: ksText,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    onPressed: () async {
                                      {
                                        final delete = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Delete Record"),
                                            content: Text(
                                              "Are you sure you want to delete ${widget.allList[index][0]} ${widget.allList[index][1]}? This action cannot be undone.",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(
                                                    context,
                                                  ).pop(false);
                                                },
                                                child: Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(
                                                    context,
                                                  ).pop(true);
                                                },
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (delete == true) {
                                          String sem =
                                              widget.allList[index][1][0];
                                          String level =
                                              widget.allList[index][0][0];
                                          String rep = level + sem;
                                          setState(() {
                                            widget.totalGP -= int.parse(
                                              widget.allList[index][4],
                                            );
                                            widget.totalTlu -= int.parse(
                                              widget.allList[index][3],
                                            );
                                            widget.allList.removeAt(index);
                                          });
                                          deleteGPA(rep);
                                          _loadData();
                                        }
                                      }
                                    },
                                    icon: Icon(Icons.delete, color: kbColor),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: Text("No GPA Added Yet", style: ksText),
                        ),
                      ),

                SizedBox(height: 20),

                // TOTALS
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Quality Point : ${widget.totalGP}",
                          style: kmText,
                        ),
                        Text(
                          "Total Point Unit : ${widget.totalTlu}",
                          style: kmText,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 15),

        MainCard(
          statement: double.parse(gpa) == 0.00
              ? 'Not yet Calculated'
              : calcClass(double.parse(gpa)),
          gpa: '$gpa/${maxGPA.value}',
        ),

        SizedBox(height: 10),

        FilledButton(
          onPressed: () {
            setState(() {
              if (widget.totalTlu > 0 && widget.totalTlu > 0) {
                gpa = (widget.totalGP / widget.totalTlu).toStringAsFixed(2);
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
            'CALCULATE CGPA',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}

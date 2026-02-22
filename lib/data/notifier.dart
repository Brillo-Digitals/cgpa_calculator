import 'package:flutter/material.dart';

ValueNotifier<List<List>> allgpaList = ValueNotifier([]);
ValueNotifier<List<String>> gradevalues = ValueNotifier([
  "5",
  "4",
  "3",
  "2",
  "1",
  "0",
]);
ValueNotifier<List> gpaClassList = ValueNotifier([
  "4.50",
  "3.40",
  "2.50",
  "1.50",
  "0.00",
]);
ValueNotifier<String> maxGPA = ValueNotifier("5.00");
ValueNotifier<int> totalGradePoint = ValueNotifier(0);
ValueNotifier<int> totalTLU = ValueNotifier(0);
ValueNotifier<String> mainGPA = ValueNotifier("0.00");
ValueNotifier<String> choosenLevel = ValueNotifier("100 Level");
ValueNotifier<int> choosenSemester = ValueNotifier(1);
ValueNotifier<bool> showDetails = ValueNotifier(false);

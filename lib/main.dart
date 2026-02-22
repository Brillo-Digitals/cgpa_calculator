import 'package:cgpa_calculator/data/constants.dart';
import 'package:cgpa_calculator/data/notifier.dart';
import 'package:cgpa_calculator/pages/calc_cgpa.dart';
import 'package:cgpa_calculator/pages/gpa_page.dart';
import 'package:cgpa_calculator/pages/grading_system.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Color.fromARGB(255, 211, 211, 211),
      title: 'GPA CALCULATOR',
      theme: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: kPrimaryColor,
          indicatorColor: Colors.white70,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelTextStyle: WidgetStateProperty.all(
            TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List pages = [
    GpaPage(),
    CalcCGPAPage(
      totalGP: totalGradePoint.value,
      totalTlu: totalTLU.value,
      allList: allgpaList.value,
    ),
    GradingSystemPage(),
  ];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    allgpaList.value = await getEachGPA();
    List allMatrixList = await getallLists();
    readMaxGPA();
    readGradeClass();
    readGradeValues();
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
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showDetails.value = true;
              });
            },
            icon: Icon(Icons.info_outline, color: kUnfocusedColor),
          ),
        ],
        backgroundColor: kPrimaryColor,
        title: Center(
          child: Center(
            child: Text(
              'CGPA CALCULATOR',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, 0.4),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(currentIndex),
              child: pages[currentIndex],
            ),
          ),
          showDetails.value == true
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50.0,
                    vertical: 200,
                  ),
                  child: Card(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  showDetails.value = false;
                                });
                              },
                              icon: Icon(Icons.close, color: kPrimaryColor),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                "Developer: Adesiyan Uthman Adeolu",
                                style: kmText,
                              ),
                              SizedBox(height: 10),
                              Text("Phone No: +234 8146269699", style: kmText),
                              SizedBox(height: 10),
                              Text(
                                "Email: uthmanadesiyan112@gmail.com",
                                style: kmText,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(height: 0, width: 0),
        ],
      ),
      bottomNavigationBar: GNav(
        style: GnavStyle.google,
        backgroundColor: kPrimaryColor,
        rippleColor: const Color.fromARGB(41, 248, 248, 248),
        hoverColor: const Color.fromARGB(51, 255, 255, 255),
        haptic: true,
        tabBorderRadius: 15,
        tabActiveBorder: Border.all(
          color: const Color.fromARGB(116, 216, 221, 227),
          width: 1,
        ),
        curve: Curves.easeOutExpo,
        duration: Duration(milliseconds: 500),
        gap: 2,
        iconSize: 20,
        color: kPrimaryColor,
        tabBackgroundColor: const Color.fromARGB(48, 216, 221, 227),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        tabMargin: EdgeInsetsGeometry.fromLTRB(10, 20, 10, 30),
        tabs: [
          GButton(
            icon: Icons.calculate,
            text: 'GPA',
            iconColor: kUnfocusedColor,
            textColor: kUnfocusedColor,
            iconActiveColor: kUnfocusedColor,
            onPressed: () {
              setState(() {
                currentIndex = 0;
              });
            },
          ),
          GButton(
            icon: Icons.school,
            text: 'CGPA',
            iconColor: kUnfocusedColor,
            textColor: kUnfocusedColor,
            iconActiveColor: kUnfocusedColor,
            onPressed: () {
              setState(() {
                currentIndex = 1;
              });
            },
          ),
          GButton(
            icon: Icons.tune,
            text: 'Grading System',
            iconColor: kUnfocusedColor,
            textColor: kUnfocusedColor,
            iconActiveColor: kUnfocusedColor,
            onPressed: () {
              setState(() {
                currentIndex = 2;
              });
            },
          ),
        ],
      ),
    );
  }
}

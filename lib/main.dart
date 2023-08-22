import 'package:flutter/services.dart';

import 'timer.dart' as timer;
import 'globalVariables.dart' as globals;
import 'chronometer.dart' as chronometer;
import 'log_page.dart' as log_page;
import 'package:flutter/material.dart';
// import 'package:wakelock/wakelock.dart';
import 'LogStorage/workouts_storage.dart' as json_storage;
// import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      title: 'Timer App',
      home: SafeArea(
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  String prova = '';
  String file = '';

  Color iconIndicatorColor = const Color.fromARGB(136, 0, 0, 0);
  Color selectedIndicatorColor = Colors.white;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();

    // Map<dynamic, String> m = {};
    // json_storage.WorkoutsStorage().writeToFile(m);
    // json_storage.WorkoutsStorage().deleteFile();

    json_storage.WorkoutsStorage().setUpWorkouts();

    // json_storage.WorkoutsStorage().filePath().then((value) {
    //   file = value.toString();
    // });
    // json_storage.WorkoutsStorage().logFileToJson().then((value) {
    //   prova = value.toString();
    // });
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 40;

    // ignore: non_constant_identifier_names
    final List<Widget> selected_index_page = [
      // TRAINING TIMER PART
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Center(
            child: SizedBox(
              child: Stack(
                // fit: StackFit.expand,
                children: [
                  // Column(
                  //   children: [
                  //     Text("file: $file"),
                  //     Text("cont: $prova"),
                  //   ],
                  // ),
                  timer.BuildGestureDetector(globals.isEditTimerVisible),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.all(7.7),
                      child: IconButton(
                        icon: const Icon(Icons.alarm_add_rounded),
                        tooltip: "Edit timer",
                        iconSize: iconSize,
                        onPressed: () {
                          // modificare timer
                          debugPrint("VISUALIZZARE/NASCONDERE MODIFICA TIMER");
                          setState(
                            () {
                              globals.isEditTimerVisible =
                                  !globals.isEditTimerVisible;
                            },
                          );
                          // debugPrint("isEditTimerVisible: $isEditTimerVisible");
                        },
                        // child: const Icon(Icons.alarm_add_rounded),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.all(7.7),
                      child: IconButton(
                        icon: const Icon(Icons.calendar_month_outlined),
                        iconSize: iconSize,
                        tooltip: "View log page",
                        onPressed: () {
                          debugPrint("Pushare logPage");
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const log_page.LogPage();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 85),
                    child: chronometer.Chronometer(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      StatefulBuilder(
        builder: (BuildContext context, setState) {
          return const Center(child: Text('Work in progress...'));
        },
      ),
    ];
    // Let the screen always on
    // Wakelock.enable();
    final controller = PageController();

    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 255, 204, 49),
      // indexedStack to preserve widget states when spacing through bottomNavBar
      backgroundColor: Color(Colors.blueGrey.value),
      // backgroundColor: Color(Colors.green.value),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, 0),
            radius: 0.8,
            colors: [
              Colors.transparent,
              Colors.transparent,
            ],
            // colors: [Color(0xFFfe8101), Colors.orange],
          ),
        ),
        child: Stack(
          children: [
            PageView(
              controller: controller,
              scrollDirection: Axis.vertical,
              children: [
                selected_index_page[0],
                selected_index_page[1],
              ],
              onPageChanged: (value) {
                setState(() {
                  pageIndex = value;
                  debugPrint("pageIndex: $pageIndex");
                });
              },
            ),
            Container(
              alignment: const Alignment(0, 0.95),
              child: SmoothPageIndicator(
                controller: controller,
                count: selected_index_page.length,
                axisDirection: Axis.vertical,
                effect: const WormEffect(
                  type: WormType.thin,
                  dotHeight: 9,
                  dotWidth: 9,
                  spacing: 25,
                  // strokeWidth: 10,
                  // fixedCenter: false,
                  // activeDotColor: Colors.transparent,
                  activeDotColor: Colors.white,
                  dotColor: Colors.transparent,
                  paintStyle: PaintingStyle.stroke,
                ),
              ),
            ),
            Container(
              alignment: const Alignment(0, 0),
              padding: const EdgeInsets.only(bottom: 7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.timer,
                    color: pageIndex == 0
                        ? selectedIndicatorColor
                        : iconIndicatorColor,
                    size: 25,
                  ),
                  const SizedBox(height: 9),
                  Icon(
                    Icons.water_drop,
                    color: pageIndex == 1
                        ? selectedIndicatorColor
                        : iconIndicatorColor,
                    size: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
        // child: IndexedStack(
        //   index: _selectedIndex,
        //   children: selected_index_page,
        // ),
      ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: Colors.white54,
      //     boxShadow: [
      //       BoxShadow(
      //         blurRadius: 20,
      //         color: Colors.black.withOpacity(0),
      //       )
      //     ],
      //   ),
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      //       child: GNav(
      //         rippleColor: Colors.grey[300]!,
      //         hoverColor: Colors.grey[100]!,
      //         gap: 3,
      //         activeColor: Colors.black,
      //         iconSize: 24,
      //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      //         duration: const Duration(milliseconds: 400),
      //         tabBackgroundColor: Colors.grey[100]!,
      //         color: Colors.black,
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         tabs: const [
      //           GButton(
      //             icon: Icons.timer,
      //             text: 'Timer',
      //           ),
      //           GButton(
      //             icon: Icons.water_drop,
      //             text: 'Water Reminder',
      //           ),
      //         ],
      //         selectedIndex: _selectedIndex,
      //         onTabChange: (index) {
      //           setState(() {
      //             _selectedIndex = index;
      //           });
      //         },
      //       ),
      //     ),
      //   ),
      // ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       label: 'Timer',
      //       icon: Icon(Icons.timer),
      //       backgroundColor: Colors.green,
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Water Reminder',
      //       icon: Icon(Icons.water_drop),
      //       backgroundColor: Colors.blue,
      //     ),
      //   ],
      //   type: BottomNavigationBarType.shifting,
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.yellowAccent,
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      // ),
    );
  }
}

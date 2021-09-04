import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:SignalStrengthChecker/screens/home.dart';
import 'package:SignalStrengthChecker/utils/siminfo.dart';
import 'package:SignalStrengthChecker/utils/location_service.dart';
import 'package:SignalStrengthChecker/utils/theme_changer.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      defaultBrightness: Brightness.dark,
      builder: (context, _brightness) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: _brightness,
          textTheme: TextTheme(
            bodyText2: GoogleFonts.roboto(),
          ),
        ),
        home: SplashScreenPage(),
      ),
    );
  }
}

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenPage> {
  int simCount = 0;
  SimDetails siminfo1, siminfo2;
  LocationService location;

  Future<void> getPermission() async {
    var permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.phone, PermissionGroup.location]);
    return;
  }

  Future<void> initialize() async {
    await getPermission().then((_) async {
      this.location = new LocationService();
      SimUtil simUtil = new SimUtil();
      simUtil.getSimCount().then((int simCount) {
        this.simCount = simCount;
        if (this.simCount >= 1) {
          simUtil.getSimDetails(0).then((Map<String, String> info1) {
            this.siminfo1 = new SimDetails(info1["SIM Operator Name"], info1["SIM Serial Number"]);
            if (this.simCount >= 2) {
              simUtil.getSimDetails(1).then((Map<String, String> info2) {
                this.siminfo2 = new SimDetails(info2["SIM Operator Name"], info2["SIM Serial Number"]);
                Future.delayed(Duration(milliseconds: 5000), () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => MyHomePage(this.simCount, this.siminfo1, this.siminfo2, this.location)
                  ));
                });
              });
            } else {
              Future.delayed(Duration(milliseconds: 5000), () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => MyHomePage(this.simCount, this.siminfo1, this.siminfo2, this.location)
                ));
              });
            }
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (ThemeBuilder.of(context).getCurrentTheme() == Brightness.dark) ? Color(0xFF121212) : Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('logo.png'),
                      width: 180.0,
                      height: 180.0,
                    ),
                    Text(
                      "Signal Strength Checker",
                      style: TextStyle(
                        fontSize: 24.0, 
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Text(
                    "Loading Sim Cards ...",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ), 
      ),
    );
  }
}

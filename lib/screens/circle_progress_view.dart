import 'dart:math';
import 'package:SignalStrengthChecker/models/result.dart';
import 'package:SignalStrengthChecker/utils/api_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:SignalStrengthChecker/utils/siminfo.dart';
import 'package:SignalStrengthChecker/utils/theme_changer.dart';
import 'package:SignalStrengthChecker/utils/location_service.dart';
import 'package:SignalStrengthChecker/utils/strength_guage_canvas.dart';
import 'package:SignalStrengthChecker/utils/database_helper.dart';

// ignore: must_be_immutable
class CircleProgressPage extends StatefulWidget {
  int simIndex = 0;
  SimDetails siminfo;
  LocationService location;

  CircleProgressPage(this.simIndex, this.siminfo, this.location);

  @override
  _CircleProgressState createState() => _CircleProgressState(simIndex, siminfo, location);
}

class _CircleProgressState extends State<CircleProgressPage>
    with TickerProviderStateMixin {
  DatabaseHelper databaseHelper = DatabaseHelper();
  LocationService location;
  AnimationController progressController, buttonController;
  Animation<double> animation, animationButton;
  Tween tween;
  int simIndex = 0;
  SimDetails siminfo;
  double endPos = 0.0;
  bool viewGoButton = true;
  Random rand = new Random();
  String networkType = "-----";
  String avgStrengthString = "-----";

  var data = [0.0];

  var data1 = [0.0];
  var data2 = [for(var i=0; i<=1000; i+=1) 0.0];

  _CircleProgressState(this.simIndex, this.siminfo, this.location);

  Future<double> getStrength() async {
    SimUtil simUtil = new SimUtil();
    int strength = await simUtil.getSignalStrengths(simIndex);
    return strength.toDouble();
  }

  @override
  void initState() {
    super.initState();
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    tween = Tween<double>(begin: 0, end: endPos);
    animation = tween.animate(progressController)
      ..addListener(() {
        setState(() {});
      });

    buttonController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 3500));
    animationButton = Tween<double>(begin: 200, end: 270).animate(buttonController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          buttonController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          buttonController.forward(from: 0.0);
        }
      });
    buttonController.forward();
  }

  Future<void> updateAnimation() async {
    data = [0.0];
    avgStrengthString = "-----";
    networkType = "-----";
    double avgStrength = 0.0;
    double endPosAvg = 0.0;
    for (int i = 1; i <= 1000; i++) {
      double strength = await getStrength();
      if (strength == 0.0) {
        endPos = 0;
      } else {
        if (strength > -90) {
          endPos = (strength + 180) + ((strength + 90) * -0.5);
        } else if (strength <= -90 && strength > -100) {
          endPos = strength + 180;
        } else {
          endPos = 4 * (strength + 121);
        }
        avgStrength += strength;
        endPos = (endPos <= 100) ? endPos : 100;
        endPos = (endPos >= 0) ? endPos : 0;
      }

      if (endPos != 0.0)
        endPos += rand.nextDouble();
      // data.add(endPos);
      data1.add(endPos);
      for (int j = i; j <= 1000; j++) {
        data2[j] = endPos;
      }
      endPosAvg += endPos;

      tween.begin = tween.end;
      progressController.reset();
      tween.end = endPos;
      progressController.forward();
      Future.delayed(Duration(milliseconds: 2000));
    }

    avgStrength /= 1000;
    if (avgStrength == 0.0) {
      avgStrengthString = "No Service";
    } else {
      avgStrengthString = "$avgStrength dBm";
    }

    endPosAvg /= 1000;
    if (endPosAvg < 20) {
      networkType = "Poor";
    } else if (endPosAvg >= 20 && endPosAvg < 40) {
      networkType = "Average";
    } else if (endPosAvg >= 40 && endPosAvg < 70) {
      networkType = "Good";
    } else {
      networkType = "Great";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 100.0,
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child:  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Overall Network Type"),
                        SizedBox(height: 10.0),
                        Text(
                          "$networkType",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child:  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Overall Strength"),
                        SizedBox(height: 10.0),
                        Text(
                          "$avgStrengthString",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            height: 50.0,
            padding: EdgeInsets.all(10.0),
            child: Container(
              child: Stack(
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width - 20.0) * (data1.length / 1001),
                        child: Sparkline(
                          data: data1,
                          sharpCorners: false,
                        ),
                      ),
                      Container(),
                    ],
                  ),
                  Sparkline(
                    data: data2,
                    lineColor: Colors.blue.withOpacity(0.3),
                    sharpCorners: false,
                  ),
                ],
              ),
            ),
          ),
          (viewGoButton) ? Container(
            height: 350.0,
            padding: EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: animationButton.value,
                    width: animationButton.value,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.blue.withOpacity((270 - animationButton.value) / 70),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          this.data1 = [0.0];
                          this.data2 = [for(var i=0; i<=1000; i+=1) 0.0];
                          viewGoButton = false;                    
                        });
                        updateAnimation().then((_) {
                          final Future<Database> databaseFuture = databaseHelper.initializeDatabase();
                          databaseFuture.then((database) {
                            String address = (location.address != null) ? "${location.address?.subLocality?? ''}, ${location.address?.locality?? ''} ${location.address?.postalCode?? ''}" : "Unknown";
                            String latitude = location.position.latitude.toString();
                            String longitude = location.position.longitude.toString();
                            Result r = new Result(networkType, avgStrengthString, data1, siminfo.operator_name, latitude, longitude, address);
                            databaseHelper.insertResult(r);
                            APIService apiService = new APIService();
                            apiService.saveToDatabase(siminfo.operator_name, latitude, longitude, address);
                          });
                          Future.delayed(Duration(seconds: 5)).then((_) {
                            setState(() {
                              viewGoButton = true;
                            });
                          });
                        });
                      },
                      elevation: 2.0,
                      child: Text(
                        "GO",
                        style: TextStyle(fontSize: 50.0),
                      ),
                      padding: EdgeInsets.all(50.0),
                      shape: CircleBorder(),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
          : 
          AnimatedOpacity(
            opacity: viewGoButton ? 0.0 : 1.0,
            duration: Duration(milliseconds: 1000),
            child: Container(
              height: 350.0,
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: CustomPaint(
                  foregroundPainter: CircleProgress(animation.value, (ThemeBuilder.of(context).getCurrentTheme() == Brightness.dark)),
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (endPos > 0) ? Text(
                            "${animation.value.toStringAsFixed(2)}%",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ) : Text(
                            "No Service",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          (endPos < 20) ? Text(
                            "Poor Network",
                            style: TextStyle(fontSize: 15, color: Colors.red),
                          ) : (endPos >= 20 && endPos < 40) ? Text(
                            "Average Network",
                            style:
                                TextStyle(fontSize: 15, color: Colors.yellow),
                          ) : (endPos >= 40 && endPos < 70) ? Text(
                            "Good Network",
                            style: TextStyle(
                                fontSize: 15, color: Colors.greenAccent),
                          ) : Text(
                            "Great Network",
                            style: TextStyle(
                                fontSize: 15, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sim_card, color: (simIndex == 0) ? Colors.orange : Colors.green),
                    Text(
                      "${siminfo.operator_name}",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

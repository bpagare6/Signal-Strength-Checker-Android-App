import 'package:SignalStrengthChecker/models/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

class PreviousResultDetails extends StatelessWidget {
  Result r;
  PreviousResultDetails(this.r);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Details'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 60,
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                "${r.date} ${r.time}", 
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          SizedBox(height: 20.0),
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
                          "${r.avgNetworkType}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
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
                          "${r.avgSignalStrength}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.0),
          Container(
            height: 70.0,
            padding: EdgeInsets.all(10.0),
            child: Sparkline(
              data: r.progressBarData.split('|').map(double.parse).toList(),
              sharpCorners: false,
            ),
          ),
          SizedBox(height: 45.0),
          Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sim_card, color: Colors.orange),
                    Text(
                      "${r.operatorName}",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 45.0),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Text("Latitude: ${r.latitude}")
                      ),
                      Container(
                        child: Text("Longitude: ${r.longitude}")
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.place, color: Colors.red),
                    Text(
                      "${r.address}",
                      style: TextStyle(
                        fontSize: 22.0,
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
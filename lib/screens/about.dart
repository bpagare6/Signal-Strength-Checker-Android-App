import 'package:flutter/material.dart';
import 'package:SignalStrengthChecker/utils/theme_changer.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      backgroundColor: (ThemeBuilder.of(context).getCurrentTheme() == Brightness.dark) ? Color(0xFF303030) : Colors.blueAccent,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 80.0,
              child: Center(
                child: Text("ABOUT US", style: TextStyle(fontSize: 28.0)),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Signal Strength Checker is definitive way to measure your sim card performance. With many people joining us to help us understand how is the connectivity all across the world specifically in India, Signal Strength Checker is the easiest way to check your actual signal strength and performance of your sim card operator.", 
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    "Our mission is to help build better connectivity all across the world. The technology behind our app is built for accurate and unbiased performance testing of different sim providers, which empowers people all over the world to find out areas with low connectivity with the help of data analytics to make better connectivity.",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(height: 120.0),
                  Center(
                    child: Text("© 2020-2021 Signal Strength Checker"),
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
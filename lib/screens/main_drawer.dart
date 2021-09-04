import 'package:flutter/material.dart';
import 'package:SignalStrengthChecker/utils/theme_changer.dart';
import 'package:SignalStrengthChecker/screens/about.dart';
import 'package:SignalStrengthChecker/screens/previous_result.dart';
import 'package:SignalStrengthChecker/screens/privacy_policy.dart';
import 'package:SignalStrengthChecker/screens/term_of_use.dart';
import 'package:SignalStrengthChecker/screens/give_feedback.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: <Widget>[
                  Image(
                    image: AssetImage('logo.png'),
                    width: 100.0,
                    height: 100.0,
                  ),
                  Text("Signal Strength Checker", style: TextStyle(fontSize: 24.0)),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Previous Results", style: TextStyle(fontSize: 18.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => PreviousResults(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var tween = Tween(begin: begin, end: end);
                  var offsetAnimation = animation.drive(tween);
                  
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 300),
              ));
            },
          ),
          ListTile(
            title: Text("About Us", style: TextStyle(fontSize: 18.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => AboutPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var tween = Tween(begin: begin, end: end);
                  var offsetAnimation = animation.drive(tween);
                  
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 300),
              ));
            },
          ),
          Divider(),
          ListTile(
            title: Text("Dark Theme", style: TextStyle(fontSize: 18.0)),
            trailing: Switch(
              value: (ThemeBuilder.of(context).getCurrentTheme() == Brightness.dark),
              onChanged: (status) {
                ThemeBuilder.of(context).changeTheme();
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text("Privacy Policy", style: TextStyle(fontSize: 18.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => PrivacyPolicy(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var tween = Tween(begin: begin, end: end);
                  var offsetAnimation = animation.drive(tween);
                  
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 300),
              ));
            },
          ),
          ListTile(
            title: Text("Terms of Use", style: TextStyle(fontSize: 18.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => TermOfUse(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var tween = Tween(begin: begin, end: end);
                  var offsetAnimation = animation.drive(tween);
                  
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 300),
              ));
            },
          ),
          ListTile(
            title: Text("Give Us Feedback", style: TextStyle(fontSize: 18.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => GiveFeedback(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var tween = Tween(begin: begin, end: end);
                  var offsetAnimation = animation.drive(tween);
                  
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 300),
              ));
            },
          ),
        ],
      ),
    );
  }
}
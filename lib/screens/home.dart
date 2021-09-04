import 'package:flutter/material.dart';
import 'package:SignalStrengthChecker/screens/main_drawer.dart';
import 'package:SignalStrengthChecker/screens/circle_progress_view.dart';
import 'package:SignalStrengthChecker/utils/siminfo.dart';
import 'package:SignalStrengthChecker/utils/theme_changer.dart';
import 'package:SignalStrengthChecker/utils/location_service.dart';

class MyHomePage extends StatefulWidget {
  int simCount = 0;
  SimDetails siminfo1, siminfo2;
  LocationService location;
  MyHomePage(this.simCount, this.siminfo1, this.siminfo2, this.location);

  @override
  _MyHomePageState createState() => _MyHomePageState(simCount, siminfo1, siminfo2, location);
}

class _MyHomePageState extends State<MyHomePage> {
  int simCount = 0;
  int _currentIndex = 0;
  SimDetails siminfo1, siminfo2;
  LocationService location;
  List<Widget> _children = [Container(), Container()];
  CircleProgressPage circleProgressPage1, circleProgressPage2;

  void intializeSim() async {
    if (simCount >= 1) {
      circleProgressPage1 = new CircleProgressPage(0, siminfo1, location);
    }
    if (simCount >= 2) {
      circleProgressPage2 = new CircleProgressPage(1, siminfo2, location);
    }
    _children = [circleProgressPage1, circleProgressPage2];
  }

  _MyHomePageState(int simCount, SimDetails siminfo1, SimDetails siminfo2, LocationService location) {
    this.simCount = simCount;
    this.siminfo1 = siminfo1;
    this.siminfo2 = siminfo2;
    this.location = location;
    intializeSim();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signal Strength Checker'),
      ),
      body: IndexedStack(
        children: <Widget>[
          Column(
            children: [
              (circleProgressPage1 != null) ? circleProgressPage1 : Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.no_sim, 
                      size: 100.0,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Sim Card Not Found!", 
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.place, color: Colors.red),
                      Text(
                        (location.address != null) ? 
                        "${location.address?.subLocality?? ''}, ${location.address?.locality?? ''} ${location.address?.postalCode?? ''}" 
                        : "Loading Location ...",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              (circleProgressPage2 != null) ? circleProgressPage2 : Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.no_sim, 
                      size: 100.0,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Sim Card Not Found!", 
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.place, color: Colors.red),
                      Text(
                        (location.address != null) ? 
                        "${location.address?.subLocality?? ''}, ${location.address?.locality?? ''} ${location.address?.postalCode?? ''}" 
                        : "Loading Location ...",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
        index: _currentIndex,
      ),
      drawer: MainDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: (ThemeBuilder.of(context).getCurrentTheme() == Brightness.dark) ? Color(0xFF212121) : Colors.blue,
        selectedItemColor: (ThemeBuilder.of(context).getCurrentTheme() == Brightness.dark) ? Colors.greenAccent : Colors.white,
        unselectedItemColor: (ThemeBuilder.of(context).getCurrentTheme() == Brightness.dark) ? Colors.grey : Colors.black54,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.sim_card),
            activeIcon: Icon(Icons.sim_card, color: Colors.amber),
            title: Text('Sim Card 1'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sim_card),
            activeIcon: Icon(Icons.sim_card, color: Colors.amber),
            title: Text('Sim Card 2'),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
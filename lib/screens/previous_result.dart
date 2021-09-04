import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:SignalStrengthChecker/models/result.dart';
import 'package:SignalStrengthChecker/utils/database_helper.dart';
import 'package:SignalStrengthChecker/screens/previous_result_details.dart';

class PreviousResults extends StatefulWidget {
  @override
  _PreviousResultsState createState() => _PreviousResultsState();
}

class _PreviousResultsState extends State<PreviousResults> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Result> previousResults;
  int count = 0;

  updateListView() {
    final Future<Database> databaseFuture = databaseHelper.initializeDatabase();
    databaseFuture.then((database) {
      Future<List<Result>> resultListFuture = databaseHelper.getHistoryList();
      resultListFuture.then((resultList) {
        setState(() {
          this.previousResults = resultList;
          this.count = resultList.length;
        });
      });
    });
  }

  navigateToDetail(Result r) {
    Navigator.push(context, PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PreviousResultDetails(r),
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
  }

  ListView getResultListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        print('All Results: ${this.previousResults[0].toString()}');
        return GestureDetector(
          child: Card(
            elevation: 2.0,
            child: ListTile(
              leading: Text(
                "${this.previousResults[position].date}\n${this.previousResults[position].time}", 
                style: TextStyle(fontSize: 12.0),
              ),
              title: Text(
                "${this.previousResults[position].avgSignalStrength}\t(${this.previousResults[position].avgNetworkType})",
                style: TextStyle(fontSize: 16.0),
              ),
              trailing: Icon(Icons.arrow_right, color: Colors.grey),
            ),
          ),
          onTap: () {
            navigateToDetail(this.previousResults[position]);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (previousResults == null) {
      previousResults = List<Result>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Results'),
      ),
      body: getResultListView(),
    );
  }
}
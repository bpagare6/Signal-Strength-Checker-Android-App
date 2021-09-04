import 'dart:async';
import 'package:flutter/services.dart';

class SimDetails {
  String operator_name = "";
  String serial_number = "";

  SimDetails(String operator_name, String serial_number) {
    this.operator_name = operator_name;
    this.serial_number = serial_number;
  }
}

class SimUtil {
  static const MethodChannel platform =
      const MethodChannel("com.bhushan.signalchecker/GetSignalStrength");
  int simCount = 0;

  Future<int> getSignalStrengths(int simNumber) async {
    return await platform.invokeMethod('getSignalStrengths', <String, int>{"simNumber": simNumber});
  }

  Future<int> getSimCount() async {
    simCount = await platform.invokeMethod('getSimCount');
    return simCount;
  }

  Future<Map<String, String>> getSimDetails(int simNumber) async {
    var d = await platform
        .invokeMethod('getSimDetails', <String, int>{"simNumber": simNumber});
    return Map<String, String>.from(d);
  }
}
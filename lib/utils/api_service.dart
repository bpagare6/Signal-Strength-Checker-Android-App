import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:SignalStrengthChecker/utils/location_service.dart';
import 'package:SignalStrengthChecker/utils/siminfo.dart';

class APIService {
  static String serverUrl = "https://signal-strength-dashboard.herokuapp.com";

  saveToDatabase(String operator_name, String latitude, String longitude, String address) async {
    var url = Uri.parse(serverUrl + "/add-signal-strength");
    var body = {
      "operatorName": operator_name,
      "latitude": latitude,
      "longitude": longitude,
      "address": address
    };
    var response = await http.post(url, body: body);
    print('Response status: ${response.statusCode}');
  }
}
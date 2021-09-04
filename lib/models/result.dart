import 'package:intl/intl.dart';

class Result {
  int _id;
  String _date;
  String _time;
  String _avgNetworkType;
  String _avgSignalStrength;
  String _progressBarData;
  String _operatorName;
  String _latitude;
  String _longitude;
  String _address;

  Result(
      String avgNetworkType,
      String avgSignalStrength,
      List<double> progressBarData,
      String operatorName,
      String latitude,
      String longitude,
      String address) {
    this._date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    this._time = DateFormat.Hms().format(DateTime.now());
    this._avgNetworkType = avgNetworkType;
    this._avgSignalStrength = avgSignalStrength;
    this._progressBarData = progressBarData.join("|");
    this._operatorName = operatorName;
    this._latitude = latitude;
    this._longitude = longitude;
    this._address = address;
  }

  Result.withId(
      int id,
      String avgNetworkType,
      String avgSignalStrength,
      List<double> progressBarData,
      String operatorName,
      String latitude,
      String longitude,
      String address) {
    this._id = id;
    this._date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    this._time = DateFormat.Hms().format(DateTime.now());
    this._avgNetworkType = avgNetworkType;
    this._avgSignalStrength = avgSignalStrength;
    this._progressBarData = progressBarData.join("|");
    this._operatorName = operatorName;
    this._latitude = latitude;
    this._longitude = longitude;
    this._address = address;
  }

  // Getter functions
  int get id => _id;
  String get date => _date;
  String get time => _time;
  String get avgNetworkType => _avgNetworkType;
  String get avgSignalStrength => _avgSignalStrength;
  String get progressBarData => _progressBarData;
  String get operatorName => _operatorName;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get address => _address;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null)
      map['id'] = _id;
    map['date'] = _date;
    map['time'] = _time;
    map['avgNetworkType'] = _avgNetworkType;
    map['avgSignalStrength'] = _avgSignalStrength;
    map['progressBarData'] = _progressBarData;
    map['operatorName'] = _operatorName;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['address'] = _address;
  }

  Result.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._date = map['date'];
    this._time = map['time'];
    this._avgNetworkType = map['avgNetworkType'];
    this._avgSignalStrength = map['avgSignalStrength'];
    this._progressBarData = map['progressBarData'];
    this._operatorName = map['operatorName'];
    this._latitude = map['latitude'];
    this._longitude = map['longitude'];
    this._address = map['address'];
  }

  String toString() {
    return "${this._date} ${this._time} ${this._avgNetworkType} ${this._avgSignalStrength} ${this.operatorName} ${this.latitude} ${this._longitude} ${this._address}";
  }
}

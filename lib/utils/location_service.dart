import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Position position;
  StreamSubscription streamSubscription;
  Address address;

  Future<Address> convertCoordinatesToAddress(Coordinates coordinates) async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }

  LocationService() {
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
    streamSubscription = Geolocator().getPositionStream(locationOptions).listen((Position position) {
      this.position = position;

      final coordinates = Coordinates(this.position.latitude, this.position.longitude);
      convertCoordinatesToAddress(coordinates).then((value) => address=value);
    });
  } 
}
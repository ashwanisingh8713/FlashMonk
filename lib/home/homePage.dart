
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/weather_model.dart';
import '../services/weather_api_client.dart';
import '../widget/current_weather.dart';
import '../widget/more_info.dart';

class HomePageWether extends StatefulWidget {
  User user;

  HomePageWether({required this.user}) {
    this.user = user;
  }

  @override
  State<HomePageWether> createState() => _HomePageWetherState();
}

class _HomePageWetherState extends State<HomePageWether> {
  late GoogleMapController _googleMapController;
  late LatLng _center;
  WeatherApiClient weatherapi = WeatherApiClient();
  WeatherModel? data;
  String? locality;

  Future<void> getData(String? location) async {
    data = await weatherapi.getCurrentWeather(location);
  }

  Future<void> getLocationName(double latitude, double longitude) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    locality = placemarks.first.locality;
    print(locality);
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _determinePosition(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final Position position = snapshot.data as Position;

              _center = LatLng(position.latitude, position.longitude);
              getLocationName(position.latitude, position.longitude);
              return Container(
                child: new Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 11.0,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: loadedData()
                      ),
                  ],
                )
              );
            } else if (snapshot.hasError) {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    snapshot.error.toString(),
                  )));
              return Container(
                child: Text(snapshot.error.toString()),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),

    );
  }



  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permissions are permantly denied. we cannot request permissions.");
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            "Location permissions are denied (actual value: $permission).");
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  FutureBuilder<void> loadedData() {
    return FutureBuilder(
      future: getData(""),
      builder: (ctx, snp) {
        if (snp.connectionState == ConnectionState.done) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              currentWeather(
                  onPressed: () {
                    setState(() {
                      loadedData();
                    });
                  },
                  temp: "${data!.temp}",
                  location: "${data!.cityName}",
                  status: "${data!.status}",
                  country: "${data!.country}",
                  user: widget.user),

              moreInfo(
                  wind: "${data!.wind}",
                  humidity: "${data!.humidity}",
                  feelsLike: "${data!.feelsLike}")
            ],
          );
        } else if (snp.connectionState == ConnectionState.waiting) {
          return Center(
            child: CupertinoActivityIndicator(
              radius: 20,
              color: Color.fromARGB(255, 172, 216, 247),
            ),
          );
        }
        return Container();
      },
    );
  }
}

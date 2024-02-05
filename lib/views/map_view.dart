import 'package:flutter/material.dart';
import '../model/ExamTerm.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';


class MapView extends StatefulWidget {
  final double long;
  final double lat;
  final List<ExamTerm> exams;

  MapView(
      {Key? key, required this.long, required this.lat, required this.exams})
      : super(key: key);

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static late LocationData locationData;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    getMarkers();
  }

  static const CameraPosition _Skopje = CameraPosition(
    target: LatLng(42.00430357002759, 21.40871880562107),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CameraPosition>(
        future: getStartLocation(),
        builder:
            (BuildContext context, AsyncSnapshot<CameraPosition> snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              initialCameraPosition: snapshot.data ?? _Skopje,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markers,
              myLocationEnabled: true,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<CameraPosition> getStartLocation() async {
    await getLocation();
    getMarkers();
    if (widget.long != -1 && widget.lat != -1) {
      return CameraPosition(
        zoom: 18,
        target: LatLng(widget.lat, widget.long),
      );
    }
    return CameraPosition(
      zoom: 15,
      target: LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0),
    );
  }

  void getMarkers() {
    markers = {};
    if (widget.long != -1) {
      markers.add(
        Marker(
          markerId: const MarkerId("1"),
          position: LatLng(widget.lat, widget.long),
          infoWindow: const InfoWindow(
            title: "Exam Information",
            snippet: "Add your exam details here",
          ),
        ),
      );
    } else if (widget.exams.isNotEmpty) {
      for (int i = 0; i < widget.exams.length; i++) {
        String formattedDateTime =
        DateFormat('dd-MM-yyyy HH:mm').format(widget.exams[i].dateTime);
        markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(widget.exams[i].lat, widget.exams[i].long),
          infoWindow: InfoWindow(
            title: widget.exams[i].subject,
            snippet: formattedDateTime,
          ),
        ));
      }
    }
  }

  static Future<void> getLocation() async {
    Location location = Location();

    late PermissionStatus permissionGranted;

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("The service isn't enabled.");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("I don't have permissions.");
        return;
      }
    }

    locationData = await location.getLocation();
  }
}
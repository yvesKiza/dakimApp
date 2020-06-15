import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapView extends StatefulWidget {
  final double longitude;
  final double latitude;
  MapView(this.latitude,this.longitude);
  @override
  _MapViewState createState() => _MapViewState();

}
GoogleMapController mapController;

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("map"),
        ),
        body:Container(
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
                onMapCreated: onMapCreated,
                myLocationEnabled: true,
                padding: EdgeInsets.only(top: 200),
                compassEnabled: true,
                tiltGesturesEnabled: true,
                mapType: MapType.hybrid,
                myLocationButtonEnabled: true,
                zoomGesturesEnabled: true,
                indoorViewEnabled: true,
                markers:{Marker(
                  markerId: MarkerId('m1'),
                 
                  position: 
                      LatLng(
                        widget.latitude,
                        widget.longitude,
                      ),
                ),},
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude), zoom: 20.0)),
          ),
         
        ],
      ),
    ));
  }
    void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
  
}


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart' as locate;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:vendorlocator/main.dart';
import 'package:app_settings/app_settings.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vendorlocator/screens/loginScreen.dart';

class MapScreen extends StatefulWidget {
  createAlertDialog(BuildContext context){

  }
  static const String idScreen="mapscreen";
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final locate.Location location=locate.Location();

  bool shouldShow=true;

  Completer<GoogleMapController> _controllergMaps = Completer();
  int i=0;

  late GoogleMapController gMapController;
  late Position currentPosition;
  var geoLocator=Geolocator();
  double bottomPaddingOfMap=0;


  void locatePosition () async{

      Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentPosition=position;
      LatLng latLangPosition=LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition=new CameraPosition(target: latLangPosition,zoom: 80);
      gMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      // getFirestoreData();
      populateClients();


  }
  Future<bool?> showWarning(BuildContext context) async=>showDialog<bool>(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text("Do you want to logout?"),
        actions: [
          ElevatedButton(onPressed: ()=>Navigator.pop(context,false), child: Text('No')),
          ElevatedButton(onPressed: ()=>Navigator.popUntil(context,ModalRoute.withName(Navigator.defaultRouteName)), child: Text('Yes'))
        ],
      )
  );
  void getFirestoreData(){
    markerCollectionReference.get().then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((element) {
        print(element.data());
      });
    }
    );

  }
  Map<MarkerId,Marker> markers=<MarkerId,Marker>{};
  SnackBar instructions = SnackBar(
      content: Text("1. Tap on the map to add a vendor."
      "\n2. Tap on a pin to see vendor details."),
      duration: Duration(seconds: 6),
  );


  List<Marker> myMarker=[];
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        print("back button pressed");
        final shouldPop=await showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
            appBar: AppBar(
              title: Text(
                  "Welcome To VendorLocator!"
              ),
            ),
            body:
            GoogleMap(
              markers:Set<Marker>.of(markers.values),
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              mapType: MapType.hybrid,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller)  {
                  _controllergMaps.complete(controller);
                  gMapController = controller;
                  ScaffoldMessenger.of(context).showSnackBar(instructions);
                  locatePosition();
              },
              onTap: _handleTap,
            ),

      ),
    );
  }


  _handleTap(LatLng tappedPoint){

    final MarkerId tappedmarkerId=MarkerId(tappedPoint.toString());
    print(tappedPoint);
    addMarker(tappedPoint, context).then((value) {
      if(value!=null){
        SnackBar mysnackbar = SnackBar(
            content: Text("Button Tapped Value:$value"));
        ScaffoldMessenger.of(context).showSnackBar(mysnackbar);
        addToFirebase(tappedPoint, value);
        populateClients();
        final tappedmarker= Marker(
            markerId: tappedmarkerId,
            position:tappedPoint,
            draggable: true,
            onDragEnd: (dragEndPosition){
              print(dragEndPosition);
            }
        );
        setState(() {
          markers[tappedmarkerId]=tappedmarker;
        });
      }

    });


  }

  Future addMarker(LatLng tappedPoint, BuildContext context){
    TextEditingController vendorDetails=TextEditingController();
    TextEditingController vendorType=TextEditingController();
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Add Co-ordinates"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${tappedPoint.latitude},${tappedPoint.longitude}",
              style: TextStyle(
              fontSize: 10.0,
            ),
            ),

            TextField(
              decoration: InputDecoration(
                hintText: "(Optional) Vendor Details"
              ),
              controller: vendorDetails,
            ),


          ],
        ),

        actions:<Widget> [
          ElevatedButton(onPressed: (){
            Navigator.of(context).pop(vendorDetails.text.toString());


          }, child: Text("Submit"))
        ],
      );
    });
  }

  Future<void> addToFirebase(LatLng location,String value){
    // Firebase:
    // Map locationDataMap={
    //   "latitude":location.latitude,
    //   "longitude":location.longitude,
    //   "vendor":value,
    //
    // };
    // // markerReference.child(i.toString()).set(locationDataMap);

    // i++;
    // Fluttertoast.showToast(msg: "Vendor Location Added To Firebase");

    //Firestore:
    return markerCollectionReference.add({
      'latitude':location.latitude,
      'longitude':location.longitude,
      // 'type': dropdownValue,
      'vendor':value
    }).then((value) => {
      print("vendor added"),
      Fluttertoast.showToast(msg: "Vendor Location Added To Firebase")
    }).catchError((error)=>print("failed to add vendor"));
  }
  populateClients(){

    markerCollectionReference.get().then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((element) {

        initMarker(element, element.id);

      });

    });

  }
  initMarker(data,dataId){
    var markerIdValue=dataId;
    final MarkerId markerId=MarkerId(markerIdValue);
    final Marker marker=Marker(
        markerId: markerId,
        position:
        LatLng(data['latitude'],data['longitude']),
        infoWindow: InfoWindow(
            title: data['vendor']
        )

    );
    setState(() {
      markers[markerId]=marker;
    });

  }

}




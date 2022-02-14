import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendorlocator/mainapp/MapScreen.dart';
import 'package:vendorlocator/screens/loginScreen.dart';
import 'package:vendorlocator/screens/registrationScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

void main() async{

  // var locationStatus=await Permission.location.status;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Location location=Location();
  PermissionStatus _permissionGranted=await location.requestPermission();
  if(_permissionGranted==PermissionStatus.granted)
    runApp(const MyApp());

  }
DatabaseReference userReference=FirebaseDatabase.instance.ref().child("users");
DatabaseReference markerReference=FirebaseDatabase.instance.ref().child("markers");
CollectionReference markerCollectionReference = FirebaseFirestore.instance.collection("locations");


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title:"VendorLocator",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: LoginScreen(),
    );
  }
}



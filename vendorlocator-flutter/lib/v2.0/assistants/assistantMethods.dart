//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:vendorlocator/assistants/requestAssistant.dart';
// import 'package:vendorlocator/configMaps.dart';
// import 'package:vendorlocator/datahandler/appData.dart';
// import 'package:vendorlocator/models/address.dart';
// import 'package:vendorlocator/models/directionDetails.dart';
//
// class AssistantMethods{
//   static Future<String> searchCoordinateAddress(Position position, context) async{
//
//     String placeAddress="";
//     String url="https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
//
//     String add1,add2,add3,add4;
//     var response=await RequestAssistant.getRequest(url);
//     if(response!="Failed"){
//       // placeAddress=response["results"][1]["formatted_address"];
//       add1=response["results"][0]["address_components"][0]["short_name"];
//       add2=response["results"][0]["address_components"][1]["short_name"];
//       add3=response["results"][0]["address_components"][3]["short_name"];
//       add4=response["results"][0]["address_components"][4]["short_name"];
//       placeAddress=add1+","+add2+","+add3+","+add4;
//       Address userPickUpAddress=new Address(placeAddress, position.latitude, position.longitude);
//       // userPickUpAddress.placeName=placeAddress;
//       // userPickUpAddress.latitude=position.latitude;
//       // userPickUpAddress.longitude=position.longitude;
//       Provider.of<AppData>(context, listen: false).updatePickUpLocation(userPickUpAddress);
//
//
//
//
//
//     }
//     return placeAddress;
//
//   }
//
//   static Future<DirectionDetails?> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async{
//
//     // String directionURL="https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";
//     // String directionURL="https://maps.googleapis.com/maps/api/directions/json?destination=Madrid&origin=Toledo&region=es&key=AIzaSyAv3p99UQiWOYdyw-oeeevbyDT_kPzvnl0";
//     String directionURL="https://maps.googleapis.com/maps/api/directions/json?destination={18.5289383,73.8743719}&origin={37.4219983,-122.084}&key=AIzaSyAv3p99UQiWOYdyw-oeeevbyDT_kPzvnl0";
//     var res= await RequestAssistant.getRequest(directionURL);
//
//     if(res=="Failed"){
//       return null;
//     }
//     DirectionDetails directionDetails=DirectionDetails(
//         res["routes"][0]["legs"][0]["distance"]["value"],
//         res["routes"][0]["legs"][0]["duration"]["value"],
//         res["routes"][0]["legs"][0]["distance"]["text"],
//         res["routes"][0]["legs"][0]["duration"]["text"],
//         res["routes"][0]["overview_polyline"]["points"]
//     );
//     // directionDetails.encodedPoints=res["routes"][0]["overview_polyline"]["points"];
//     //
//     // directionDetails.distanceText=res["routes"][0]["legs"][0]["distance"]["text"];
//     // directionDetails.distanceValue=res["routes"][0]["legs"][0]["distance"]["value"];
//     //
//     // directionDetails.durationText=res["routes"][0]["legs"][0]["duration"]["text"];
//     // directionDetails.durationValue=res["routes"][0]["legs"][0]["duration"]["value"];
//
//     return directionDetails;
//
//
//
//   }
//
// }
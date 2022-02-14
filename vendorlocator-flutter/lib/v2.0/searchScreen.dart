// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:vendorlocator/assistants/requestAssistant.dart';
// import 'package:vendorlocator/configMaps.dart';
// import 'package:vendorlocator/datahandler/appData.dart';
// import 'package:vendorlocator/models/address.dart';
// import 'package:vendorlocator/models/placePredictions.dart';
// import 'package:vendorlocator/widgets/Divider.dart';
// import 'package:vendorlocator/widgets/progressDialog.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);
//
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//
//   TextEditingController pickUpTextEditingController=TextEditingController();
//   TextEditingController dropOffTextEditingController=TextEditingController();
//   List<PlacePredictions> placePredictionList=[];
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     String placeAddress=Provider.of<AppData>(context).pickupLocation.placeName??"";
//     pickUpTextEditingController.text=placeAddress;
//
//
//     return Scaffold(
//       resizeToAvoidBottomInset : false,
//       body: Column(
//         children: [
//           Container(
//             height: 215.0,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                 color: Colors.black,
//                 blurRadius: 6.0,
//                 spreadRadius: 0.5,
//                 offset: Offset(0.7,0.7)
//
//               )
//              ]
//             ),
//             child: Padding(
//               padding: EdgeInsets.only(left: 25.0,top:50.0,right: 25.0,bottom: 20.0),
//               child: Column(
//                 children: [
//                   SizedBox(height: 5.0,),
//                   Stack(
//                     children: [
//                       GestureDetector(
//                         onTap:(){
//                           Navigator.pop(context);
//                         },
//                           child: Icon(Icons.arrow_back)),
//                       Center(
//                         child: Text("Set Drop Off",style: TextStyle(fontSize: 18,fontFamily: "Brand-Bold"),),
//                       )
//                     ],
//                   ),
//                   SizedBox(height: 16.0,),
//                   Row(
//                     children: [
//                       Image.asset("images/pickicon.png",height: 16.0,width: 16.0,),
//                       SizedBox(width: 18.0,),
//                       Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.grey[400],
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.all(3.0),
//                               child: TextField(
//                                 controller: pickUpTextEditingController,
//                                 decoration: InputDecoration(
//                                   hintText: "Pick Up Location",
//                                   fillColor: Colors.grey[400],
//                                   filled: true,
//                                   border: InputBorder.none,
//                                   isDense:true,
//                                   contentPadding: EdgeInsets.only(left: 11.0,top: 8.0, bottom:8.0),
//                                 ),
//                               ),
//                             ),
//
//
//                       ))
//
//
//                     ],
//                   ),
//                   SizedBox(height: 10.0,),
//                   Row(
//                     children: [
//                       Image.asset("images/desticon.png",height: 16.0,width: 16.0,),
//                       SizedBox(width: 18.0,),
//                       Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.grey[400],
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.all(3.0),
//                               child: TextField(
//                                 onChanged: (val){
//                                   findPlace(val);
//                                 },
//                                 controller: dropOffTextEditingController,
//                                 decoration: InputDecoration(
//                                   hintText: "Where To?",
//                                   fillColor: Colors.grey[400],
//                                   filled: true,
//                                   border: InputBorder.none,
//                                   isDense:true,
//                                   contentPadding: EdgeInsets.only(left: 11.0,top: 8.0, bottom:8.0),
//                                 ),
//                               ),
//                             ),
//
//
//                           ))
//
//
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 10,),
//
//           (placePredictionList.length>0)
//               ? Padding(
//             padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: ListView.separated(
//               padding: EdgeInsets.all(0.0),
//               itemBuilder: (context, index)
//               {
//                 return PredictionTile(placePredictions: placePredictionList[index]);
//               },
//               separatorBuilder:(BuildContext context, int index)=>DividerWidget(),
//               itemCount: placePredictionList.length,
//               shrinkWrap: true,
//               physics: ClampingScrollPhysics(),
//
//             ),
//           )
//               :Container(),
//
//         ],
//       ),
//
//     );
//   }
//
//   Future<void> findPlace(String placeName) async {
//     if(placeName.length>1){
//       String autoCompleteURL="https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&radius=500&types=establishment&key=$mapKey";
//       var res=await RequestAssistant.getRequest(autoCompleteURL);
//       if(res=="Failed"){
//         return;
//       }
//       else{
//         var predictions=res["predictions"];
//         var placeList=(predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();
//         setState(() {
//           placePredictionList=placeList;
//         });
//
//       }
//
//     }
//   }
//
//
// }
//
// class PredictionTile extends StatelessWidget {
//   final PlacePredictions placePredictions;
//   const PredictionTile({Key? key,required this.placePredictions}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         primary:Colors.white,
//         onPrimary: Colors.black,
//       ),
//       // style: ButtonStyle(
//       //   backgroundColor: MaterialStateProperty.all(Colors.white),
//       // ),
//       onPressed: () {
//         getPlaceAddress(placePredictions.place_id, context);
//       },
//
//       child: Container(
//         child: Column(
//           children: [
//             SizedBox(width: 10.0,),
//             Row(
//               children: [
//                 Icon(Icons.add_location),
//                 SizedBox(width: 14.0,),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 8.0,),
//                       Text(placePredictions.main_text,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
//                       SizedBox(height:2.0,),
//                       Text(placePredictions.secondary_text,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color:Colors.grey)),
//                       SizedBox(height: 20.0,)
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//             SizedBox(width: 20.0,)
//           ],
//         ),
//
//       ),
//     );
//   }
//   void getPlaceAddress(String placeId, context) async{
//     showDialog(context: context, builder: (BuildContext context)=>ProgressDialog(message: "Setting DropOff, Please Wait..."));
//     String placeDetailURL="https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
//     var res=await RequestAssistant.getRequest(placeDetailURL);
//     Navigator.pop(context);
//
//     if(res=="Failed"){
//       return;
//     }
//     else{
//       Address address=new Address(res["result"]["name"], res["result"]["geometry"]["location"]["lat"],
//           res["result"]["geometry"]["location"]["lng"]);
//       Provider.of<AppData>(context,listen: false).updateDropOffLocationAddress(address);
//       print("This is the drop off location:");
//       print(address.placeName);
//
//
//       Navigator.pop(context,"obtainDirection");
//     }
//   }
// }
//
//

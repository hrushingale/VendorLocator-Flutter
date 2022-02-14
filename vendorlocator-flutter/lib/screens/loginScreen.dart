import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:vendorlocator/main.dart';
import 'package:vendorlocator/mainapp/MapScreen.dart';
import 'package:vendorlocator/screens/registrationScreen.dart';
import 'progressDialog.dart';

class LoginScreen extends StatelessWidget {


  static const String idScreen="login";
  TextEditingController emailText=TextEditingController(text: "vendorlocatorguest@gmail.com");
  TextEditingController passwordText=TextEditingController(text: "vendor@65");
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20,color: Colors.white),shape: new RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(10),
    ),fixedSize: Size(320.0,50.0));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:[
            SizedBox(height: 10.0,),
            Image(
              image: AssetImage("images/vendormainlogo.png"),
              width: 500.0,
              height: 256.0,
              alignment: Alignment.center,
            ),
              SizedBox(height: 1.0,),
              Text("Customer Login", style: TextStyle(fontFamily: "Brand Bold",fontSize: 24.0),textAlign: TextAlign.center,),
              Padding(padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("Guest Login: vendorlocatorguest@gmail.com\nPassword: vendor@65",
                    style: TextStyle(fontFamily: "Brand Bold", color: Colors.black54),

                  ),
                  SizedBox(height: 1.0,),
                  TextField(
                    controller: emailText,


                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Brand Bold"
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        )
                    ),
                    style: TextStyle(fontSize: 14.0,fontFamily: "Brand Bold"),
                  ),
                  SizedBox(height: 1.0,),
                  TextField(
                    controller: passwordText,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Brand Bold"
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        )
                    ),
                    style: TextStyle(fontSize: 14.0,fontFamily: "Brand Bold"),
                  ),
                  SizedBox(height: 60.0,),
                  ElevatedButton(

                    style: style,
                    onPressed: () {
                      // print("logged in");
                      if(!emailText.text.contains("@")){
                        displayToast("Email missing @", context);
                      }
                      else if(passwordText.text.isEmpty){
                        displayToast("Password is mandatory", context);
                      }
                      else{

                        loginAndAuthenticateUser(context);
                      }
                    },
                    child: const Text('LOGIN',style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                    ),

                  ),
                  TextButton(

                    onPressed: () {
                      // print("clicked");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> RegistrationScreen()));

                    },

                    child: Text(
                      "Do not have an account? Register Here!",
                      style: TextStyle(fontFamily: "Brand Bold",color: Colors.black54),
                    ),
                  ),
                ],
              ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(context: context, barrierDismissible: false, builder:(BuildContext context)
    {
      return ProgressDialog(message: "Authenticating, Please Wait...");

    });
    final UserCredential firebaseUser=await firebaseAuth.signInWithEmailAndPassword(
        email: emailText.text, password: passwordText.text).catchError((errMsg){
          Navigator.pop(context);
          displayToast("Error:"+errMsg.toString(), context);
    });
    User? user=firebaseUser.user;

    if(firebaseUser!=null){
      userReference.child(user!.uid).once().then((DatabaseEvent snap){
        if(snap.snapshot.value!=null){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const MapScreen()));
          displayToast("You are logged in!", context);
        }
        else{
          Navigator.pop(context);
          firebaseAuth.signOut();
          displayToast("You are not registered", context);
        }

      });

    }
    else{
      Navigator.pop(context);
      displayToast("error occurred", context);
    }

  }
  displayToast(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}

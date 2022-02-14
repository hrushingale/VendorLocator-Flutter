import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendorlocator/main.dart';
import 'package:vendorlocator/screens/loginScreen.dart';
import 'progressDialog.dart';

class RegistrationScreen extends StatelessWidget {
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  static const String idScreen="register";
  TextEditingController nameText=TextEditingController();
  TextEditingController emailText=TextEditingController();
  TextEditingController phoneText=TextEditingController();
  TextEditingController passwordText=TextEditingController();
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
                width: 512.0,
                height: 320.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text("Sign Up User", style: TextStyle(fontFamily: "Brand Bold",fontSize: 24.0),textAlign: TextAlign.center,),
              Padding(padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(controller:nameText,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name",
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
                      controller:emailText,
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
                      controller:phoneText,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone",
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
                        controller:passwordText,
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
                    SizedBox(height: 30.0,),
                    ElevatedButton(

                      style: style,
                      onPressed: () async {
                        // print("logged in");
                        if(nameText.text.length<3){
                          displayToast("Name must be more than 3 characters", context);
                        }
                        else if(!emailText.text.contains("@")){
                          displayToast("Email missing @", context);
                        }
                        else if(phoneText.text.isEmpty){
                          displayToast("Phone Number is mandatory", context);
                        }
                        else if(passwordText.text.length<6){
                          displayToast("Password must be atleast 5 characters", context);
                        }
                        else{
                          registerNewUser(context);


                        }
                      },
                      child: const Text('REGISTER',style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                      ),

                    ),

                  ],
                ),

              ),
              TextButton(

                onPressed: () {
                  // print("clicked");
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                  // Navigator.pop(context);
                },


                child: Text(
                  "Already have an account? Log In Here!",
                  style: TextStyle(fontFamily: "Brand Bold",color: Colors.black54),
                ),
              )



            ],
          ),
        ),
      ),

    );
  }

  void registerNewUser(BuildContext context) async {
    showDialog(context: context, barrierDismissible: false, builder:(BuildContext context)
    {
      return ProgressDialog(message: "Registering, Please Wait...");
    });
  final UserCredential firebaseUser=await _firebaseAuth.createUserWithEmailAndPassword(email: emailText.text, password: passwordText.text);
  User? user=firebaseUser.user;
  if(firebaseUser!=null){
    
    Map userDataMap={
      "name":nameText.text.trim(),
      "email":emailText.text.trim(),
      "phone":phoneText.text.trim(),
      
    };
    
    
    userReference.child(user!.uid).set(userDataMap);
    displayToast("Congratulations! Account created!", context);
    
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
  }
  else{
    Navigator.pop(context);
    displayToast("New user account has not been created", context);
  }

  }
  displayToast(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}

import 'dart:io';
import 'package:chat_app_firebase/Globals/global_vars.dart';
import 'package:chat_app_firebase/home_screen.dart';
import 'package:chat_app_firebase/sign_up_screen.dart';
import 'package:chat_app_firebase/topbar_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String emailFingerPrint;
  String passwordFingerPrint;
  dynamic loginStatus;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkStatus().then((value) =>  print("LOginStatus////////////////////////////////"+loginStatus.toString()));
  }

  bool _isAuthenticating = false;
  bool _authorized = false;
  bool _secureText = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool formValidationSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TopBarLogin(),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding:
                    // const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    const EdgeInsets.only(
                        left: 20, right: 20, top: 40, bottom: 5),
                child: TextFormField(
                  controller: emailController,
                  autofocus: true,
                  onSaved: (String value) {},
                  // validator: emailValidationMixin,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () => emailController.clear(),
                    ),
                    labelText: 'Email',
                    hintText: 'you@example.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                  controller: passwordController,
                  autofocus: true,
                  // enabled: false,
                  onSaved: (String value) {},
                  // validator: passwordValidationMixin(""),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _secureText ? Icons.remove_red_eye : Icons.security,
                        color: Colors.lightBlue,
                      ),
                      onPressed: () {
                        setState(() {
                          _secureText = !_secureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _secureText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          formValidationSuccess = true;
                        }

                        if (formValidationSuccess == true) {
                          setState(() {
                            isLoading = true;
                          });
                          userLogin();
                        }

                        //
                      },
                      child: !isLoading
                          ? const SizedBox(
                              width: 100,
                              height: 50,
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            )
                          : const CircularProgressIndicator(),
                      color: Colors.blue.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>SignUp()));
                  },
                  child: const Text('do not have an account sing up first',style: TextStyle(color: Colors.green),)),

              // SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }

  // void emailValidationMixin(String value) async {
  //   if (!value.contains('@gmail.com')) {
  //     return "Invalid Email address !";
  //   }
  // }

  // Future passwordValidationMixin(String value) async {
  //   if (value.length < 8) {
  //     return 'Password must be at least 8 characters';
  //   }
  // }

  Future userLogin() async {
    await FirebaseFirestore.instance
        .collection("user")
        .where('email', isEqualTo: emailController.text)
        .where('password', isEqualTo: passwordController.text)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        GlobalVars.loggedInUserId = value.docs[0].id;

        print('print GlobalDocId ${GlobalVars.loggedInUserId}');

        // getingNestedDoc();
        // FlutterSession().set('userId',value.docs[0].id);
        // FlutterSession().set('Email', emailController.text);
        // FlutterSession().set('Password', passwordController.text);
        // emailFingerPrint = emailController.text;
        // passwordFingerPrint = passwordController.text;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));

        // emailFingerPrint=emailController.text;
        // passwordFingerPrint=passwordController.text;

      } else {
        showDialog(
            barrierColor: Colors.red[100],
            context: context,
            builder: (context) {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber.withOpacity(0.3))),
                child: AlertDialog(
                  title: const Text(
                    "Error !",
                    style: TextStyle(color: Colors.red),
                  ),
                  content: const Text("Invalid Login"),
                  backgroundColor: Colors.grey[300],
                  actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text("ok"))
                  ],
                ),
              );
            });
      }
    });
  }


  // Future<bool> onWillPop() {
  //   return showDialog(
  //         barrierColor: Colors.blue.withOpacity(0.4),
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           backgroundColor: Colors.white,
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //           title: Row(
  //             children: [
  //               Container(
  //                 decoration:
  //                     BoxDecoration(borderRadius: BorderRadius.circular(20)),
  //                 child: Icon(
  //                   Icons.add_alert,
  //                   color: Colors.blue,
  //                   size: 30,
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               Text(
  //                 'Are you sure?',
  //                 style: TextStyle(color: Colors.red, fontSize: 20),
  //               ),
  //             ],
  //           ),
  //           content: Padding(
  //             padding: const EdgeInsets.only(left: 40),
  //             child: Text(
  //               'Do you want to exit.',
  //               style: TextStyle(color: Colors.blue),
  //             ),
  //           ),
  //           actions: <Widget>[
  //             FlatButton(
  //               onPressed: () => Navigator.of(context).pop(false),
  //               child: Text('No', style: TextStyle(color: Colors.blue)),
  //             ),
  //             FlatButton(
  //               onPressed: () => exit(0),
  //               child: Text('Yes', style: TextStyle(color: Colors.red)),
  //             ),
  //           ],
  //         ),
  //       ) ??
  //       false;
  // }

  // Future userLoginViaFingerPrint() async {
  //   await FirebaseFirestore.instance
  //       .collection("Users")
  //       .where('Email', isEqualTo: emailController.text)
  //       .where('Password', isEqualTo: passwordController.text)
  //       .get()
  //       .then((value) {
  //     if (value.docs.length > 0) {
  //       FlutterSession().set('Email', emailFingerPrint);
  //       FlutterSession().set('Password', passwordFingerPrint);
  //       FlutterSession().set('status', true).then((value) {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => HomeScreen()));
  //       }
  //           // emailFingerPrint=emailController.text;
  //           // passwordFingerPrint=passwordController.text;

  //           );
  //     } else {
  //       showDialog(
  //           barrierColor: Colors.red[100],
  //           context: context,
  //           builder: (context) {
  //             return Container(
  //               decoration:
  //                   BoxDecoration(border: Border.all(color: Colors.amber[300])),
  //               child: AlertDialog(
  //                 title: Text(
  //                   "Error !",
  //                   style: TextStyle(color: Colors.red),
  //                 ),
  //                 content: Text("Invalid Login"),
  //                 backgroundColor: Colors.grey[300],
  //                 actions: [
  //                   FlatButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                       child: Text("ok"))
  //                 ],
  //               ),
  //             );
  //           });
  //     }
  //   });
  // }

  // Future<void> _autheniticate() async {

  //   try {
  //     setState(() {
  //       _isAuthenticating = true;
  //     });
  //     bool _authenticated = false;

  //     _authenticated = await auth.authenticateWithBiometrics(
  //         localizedReason: 'Please authenticate to Login',
  //         useErrorDialogs: true,
  //         stickyAuth: true);

  //     setState(() {
  //       _authorized = _authenticated;
  //       _isAuthenticating = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isAuthenticating = false;
  //     });
  //     print(e);
  //   }

  //   _authorized
  //       ? Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen()))
  //       : Text("Cant't authenticate finger print");
  // }

  // Future fingerPrintLogin()async{
  //   loginStatus = await FlutterSession().get("status");
  //   loginStatus.toString()=="true" ? _autheniticate():showDialog(
  //       barrierColor: Colors.red[100],
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           decoration:
  //           BoxDecoration(border: Border.all(color: Colors.amber[300])),
  //           child: AlertDialog(
  //             title: Text(
  //               "Error !",
  //               style: TextStyle(color: Colors.red),
  //             ),
  //             content: Text("Please login through Email and Password for one time"),
  //             backgroundColor: Colors.grey[300],
  //             actions: [
  //               FlatButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text("ok"))
  //             ],
  //           ),
  //         );
  //       });
  // }
}

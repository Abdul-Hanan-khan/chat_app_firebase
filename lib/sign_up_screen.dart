// ignore: file_names
// ignore: file_names


import 'package:chat_app_firebase/top_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  CollectionReference ref = FirebaseFirestore.instance.collection("user");

  final formKey = GlobalKey<FormState>();

  bool formValidationSuccess = false;
  bool isLoading=false;

  var fNameCtr = TextEditingController();


  var emailCtr = TextEditingController();
  var passwordCtr = TextEditingController();





  @override
  void initState() {
    // TODO: implement initState
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopBar(),
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //fname
                    Card(
                      elevation: 7,
                      margin:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 4),
                        child: TextFormField(
                          maxLines: 1,
                          controller: fNameCtr,
                          validator: firstNameValidation,
                          decoration: InputDecoration(
                              hintText: " First Name",
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel_outlined),
                                onPressed: () => fNameCtr.clear(),
                              )),
                        ),
                      ),
                    ),
                    //lname
                    //Gender



                    // date of birth

                    //naitonality

                    //mobileno




                    //email;
                    Card(
                      elevation: 7,
                      margin:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 4),
                        child: TextFormField(
                          controller: emailCtr,
                          validator: emailValidation,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: " Email",
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel_outlined),
                                onPressed: () => emailCtr.clear(),
                              )),
                        ),
                      ),
                    ),
                    //passeword
                    Card(
                      elevation: 7,
                      margin:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 4),
                        child: TextFormField(
                          controller: passwordCtr,
                          validator: passwordValidation,
                          decoration: InputDecoration(
                            hintText: " Password",
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.cancel_outlined),
                              onPressed: () => passwordCtr.clear(),
                            ),
                          ),
                          obscureText: true,
                        ),
                      ),
                    ),

                    //sing-up button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            onPressed: () {
                              setState(() {
                                isLoading=true;
                              });
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                formValidationSuccess = true;
                              }


                              if (formValidationSuccess == true) {
                                userSignUp();
                               //
                                 //clearForm();
                              }
                              //
                            },
                            //         onPressed:(){
                            //
                            //       print(fNameCtr.text+"\n"+lNameCtr.text+"\n"+genderSelected+"\n"+birthDateInString+"\n"+nationalityCtr.text+"\n"+mobileNoCtr.text+"\n"+disabilityType+"\n"+emailCtr.text+"\n"+passwordCtr.text+"\n");
                            // },
                            //         onPressed: () {
                            //           ref.add({
                            //             'FirstName': fNameCtr.text,
                            //             'LastName': lNameCtr.text,
                            //             'Gender':genderSelected,
                            //             'DOB':birthDateInString,
                            //             'Nationality':nationalityCtr.text,
                            //             'Phone No':mobileNoCtr.text,
                            //             'Disability Type':disabilityType,
                            //             'Email':emailCtr.text,
                            //             'Password':passwordCtr.text
                            //           }).whenComplete(() => Navigator.pop(context));
                            //         },
                            child: isLoading==false? const SizedBox(
                              width: 100,
                              height: 50,
                              child: Center(
                                child: Text(
                                  "SignUp",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ):CircularProgressIndicator(),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "I already have an Account",
                          style: TextStyle(color: Colors.green),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.blue.withOpacity(0.7),
                                fontSize: 25),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }





  String firstNameValidation(String value) {
    if (value.isEmpty) {
      return 'Please Enter First Name';
    }
  }


  String emailValidation(String value) {
    if (!value.contains('@gmail.com')) {
      return "Invalid Email address !";
    }
  }

  String passwordValidation(String value) {
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
  }

  void clearForm() {
    fNameCtr.clear();
    emailCtr.clear();
    passwordCtr.clear();
  }


  Future userSignUp() async {
    await FirebaseFirestore.instance
        .collection("user")
        .where('email', isEqualTo: emailCtr.text)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        showDialog(
            barrierColor: Colors.red[100],
            context: context,
            builder: (context) {
              return Container(
                decoration:
                BoxDecoration(border: Border.all(color: Colors.amber[300])),
                child: AlertDialog(
                  title:const Text(
                    "Error !",
                    style: TextStyle(color: Colors.red),
                  ),
                  content:const Text("Account exists already"),
                  backgroundColor: Colors.grey[300],
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("ok"))
                  ],
                ),
              );
            });

        setState(() {
          isLoading=false;
        });

      } else {

        ref.doc().set({
          'name': fNameCtr.text.toString(),
          'email': emailCtr.text.toString(),
          'password': passwordCtr.text.toString(),
          'user_id': 'Not assigned yet',
        }).whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginScreen())));

      }
    });
  }
}

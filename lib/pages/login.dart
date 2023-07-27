// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';

import 'package:crypto_tracker/pages/home.dart';
import 'package:crypto_tracker/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var username = TextEditingController();
  var password = TextEditingController();

  late bool passwordVisible;

  late String usernameError;
  late String passError;

  bool isValidUsername = true;
  bool isValidPass = true;

  late var users;


  @override
  void initState(){
    super.initState();
    passwordVisible = true;
    getCurrentUserAndUsers();
  }

  FocusNode myFocusNode1 = FocusNode();
  FocusNode myFocusNode2 = FocusNode();

  void _requestFocus(node){
    setState(() {
      FocusScope.of(context).requestFocus(node);
    });
  }

  void getCurrentUserAndUsers() async{
    var prefs = await SharedPreferences.getInstance();
    if(prefs.getString('currentUser') != null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home(),));
    }
    if(prefs.getString('users') != null){
      var data = jsonDecode(prefs.getString('users')!);
      setState(() {
        users = data;
      });
    }
    else{
      setState(() {
        users = [];
      });
    }
  }

  void login() async{
    var prefs = await SharedPreferences.getInstance();
    
    if(username.text.isEmpty){
      setState(() {
        isValidUsername = false;
        usernameError = 'Please enter the username';
      });
    }
    if(password.text.isEmpty){
      setState(() {
        isValidPass = false;
        passError = 'Please enter the password';
      });
    }

    bool uflag = false;
    bool pflag = false;

    users.forEach((user){
      if(user['username'] == username.text){
        uflag = true;
        if(user['password'] == password.text){
          pflag = true;
          prefs.setString('currentUser', username.text);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const Home(),));
          return;
        }
      }
    });

    if(!uflag){
      setState(() {
        isValidUsername = false;
        usernameError = "This username doesn't exist. Please sign up";
        isValidPass = true;
      });
    }
    else if(!pflag){
      setState(() {
        isValidPass = false;
        passError = 'Invalid Password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        height: 300,
        child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Crypto', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      Text(
                      'Tracker',
                      style: TextStyle(
                        fontFamily: 'Lumano',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(58, 128, 233, 1),
                      ),
                    )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:   [
                          SizedBox(
                            width: 300,
                            child: TextField(
                                    focusNode: myFocusNode1,
                                    controller: username,
                                    maxLength: 30,
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      counterText: '',
                                      labelStyle: TextStyle(
                                      color: myFocusNode1.hasFocus
                                          ? HexColor('#3a80e9')
                                          : Colors.grey),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(color: HexColor('#3a80e9'))
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0)
                                      ),
                                      errorText: isValidUsername ? null : usernameError,
                                    ),
                                    onTap: (){
                                      _requestFocus(myFocusNode1);
                                    },  
                                    onChanged: ((value) {
                                      setState(() {
                                        isValidUsername = true;
                                      });        
                                    }),
                                  ))
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:   [
                          SizedBox(
                            width: 300,
                            child: TextField(
                                    obscureText: passwordVisible,
                                    focusNode: myFocusNode2,
                                    controller: password,
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      counterText: '',
                                      labelStyle: TextStyle(color: myFocusNode2.hasFocus ? HexColor('#3a80e9') : Colors.grey),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(color: HexColor('#3a80e9'))
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0)
                                      ),
                                      suffixIcon: IconButton(
                                      icon: passwordVisible
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility), 
                                      onPressed: () { 
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                       },
                                      ),
                                      errorText: isValidPass ? null : passError,
                                    ),
                                    onTap: (){
                                      _requestFocus(myFocusNode2);
                                    },  
                                    onChanged: (value) {
                                      setState(() {
                                        isValidPass = true;
                                      });
                                    },       
                                  ))
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => login(),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9)),
                            fixedSize: const Size(300, 40),
                          ),
                          child: const Text('Log in')
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup(),));
                      }, child: const Text('Sign up'))
                    ],
                  )
                ]
              )
      ),
    );
  }
}



// ElevatedButton(
//                 onPressed: (){
//                   Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Home(),));
//                   // Navigator.pushReplacementNamed(context, '/home');
//                 },
//                 child:const Text('Go to Home')
//               )
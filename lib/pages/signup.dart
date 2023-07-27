// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:crypto_tracker/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({ Key? key }) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  late bool passwordVisible;
  late bool confirmPasswordVisible;

  var username = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();

  bool isValidUsername = true;
  bool isValidPass = true;
  bool isValidConfirmPass = true;

  late String passError;
  late String confirmPassError;
  late String usernameError;

  // ignore: prefer_typing_uninitialized_variables
  late var users;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    confirmPasswordVisible =true;

    getUsers();
  }

  void checkPassword(pass){
    final passReg = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
    if(passReg.hasMatch(pass)){
      setState(() {
        isValidPass = true;
      });
    }
    else{
      setState(() {
        isValidPass = false;
      });
      if(!RegExp(r'^(?=.*[a-z])').hasMatch(pass)){
        setState(() {
          passError = 'Password has 1 small letter';
        });
      }
      if(!RegExp(r'^(?=.*[A-Z])').hasMatch(pass)){
        setState(() {
          passError = 'Password has 1 capital latter';
        });
      }
      if(!RegExp(r'^(?=.*[@$!%*?&])').hasMatch(pass)){
        setState(() {
          passError = 'Password has 1 special symbol';
        });
      }
      if(!RegExp(r'^(?=.*\d)').hasMatch(pass)){
        setState(() {
          passError = 'Password has 1 digits';
        });
      }
      if(RegExp(r'\s').hasMatch(pass)){
        setState(() {
          passError = 'Password must not have any space';
        });
      }
      if(pass.length < 8){
        setState(() {
          passError = 'Password has atleast 8 character';
        });
      }
    }
    
  }

  void checkConfirmPassword(value){
    if(value != password.text){
      setState(() {
        isValidConfirmPass = false;
        confirmPassError = 'Confirm password is same as password';
      });
    }
    else{
      setState(() {
        isValidConfirmPass = true;
      });
    }
  }

  void checkUsername(value){
    final reg = RegExp(r'^[A-Za-z][A-Za-z0-9_]{5,29}$');

    bool flag = false;

    for (var user in users) {
      if(user['username'] == value){
        flag = true;
        break;
      }
    }

    if(reg.hasMatch(value) && !flag){
      setState(() {
        isValidUsername = true;
      });
    }
    else{
      setState(() {
        isValidUsername = false;
      });
      
      if(value.length < 6){
        setState(() {
          usernameError = "Username contain atleast 6 character";
        });
      }
      if(value.length >30){
        setState(() {
          usernameError = "Username not more than 30 character";
        });
      }
      if(RegExp(r'^(?=.*[@$!%*?&])').hasMatch(value)){
        setState(() {
          usernameError = "Username does not contain special character";
        });
      }
      if(RegExp(r'\s').hasMatch(value)){
        setState(() {
          usernameError = "Username does not contain space";
        });
      }
      if(flag){
        setState(() {
          usernameError = "This Username already exist";
        });
      }
    }
  }

  void getUsers() async{
    var prefs = await SharedPreferences.getInstance();
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

  void signupUser() async{
    var prefs = await SharedPreferences.getInstance();

    if(username.text.isEmpty){
      setState(() {
        isValidUsername = false;
        usernameError = 'Please fill the username';
      });
      return;
    }
    if(password.text.isEmpty){
      setState(() {
        isValidPass = false;
        passError = 'Please enter the password';
      });
      return;
    }
    if(confirmPassword.text.isEmpty){
      setState(() {
        isValidConfirmPass = false;
        confirmPassError = 'Please enter confirm password';
      });
      return;
    }
    
    if(isValidUsername && isValidPass && isValidConfirmPass){

      var user = {
        "username" : username.text,
        "password" : password.text,
      };

      users.add(user);
      // print('signup users $users');

      prefs.setString("users", jsonEncode(users));
      prefs.setString('currentUser', username.text);
      username.text = '';
      password.text = '';
      confirmPassword.text = ''; 

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login(),));


      
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        height: 350,
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
                                    controller: username,
                                    maxLength: 30,
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      counterText: '',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(color: HexColor('#3a80e9'))
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0)
                                      ),
                                      errorText: isValidUsername ? null : usernameError,
                                    ),

                                    onChanged: (value) => checkUsername(value),
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
                                    controller: password,
                                    obscureText: passwordVisible,
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      counterText: '',
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
                                      errorText: isValidPass ? null : passError
                                    ),
                                    onChanged: (value) => checkPassword(value),        
                                  )
                                )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:   [
                          SizedBox(
                            width: 300,
                            child: TextField(
                                    controller: confirmPassword,
                                    obscureText: confirmPasswordVisible,
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                      labelText: 'Confirm Password',
                                      counterText: '',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(color: HexColor('#3a80e9'))
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0)
                                      ),
                                      suffixIcon: IconButton(
                                      icon: confirmPasswordVisible
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility), 
                                      onPressed: () { 
                                          setState(() {
                                            confirmPasswordVisible = !confirmPasswordVisible;
                                          });
                                       },
                                      ),
                                      errorText: isValidConfirmPass ? null : confirmPassError,
                                    ),
                                    onChanged: (value) => checkConfirmPassword(value),      
                                  ))
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => signupUser(),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9)),
                            fixedSize: const Size(300, 40),
                          ),
                          child: const Text('Sign up')
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login(),));
                      }, child: const Text('Log in'))
                    ],
                  )
                ]
              )
      ),
    );
  }
}



// Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const Login(),
//           ),
//           (route) => false
//       );
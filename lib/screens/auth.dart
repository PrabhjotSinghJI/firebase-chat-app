

import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/widgets/user_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();


  var _islogin = true;
  var  _enteredEmail = "";
  var _enteredPassword = "";
  var _enteredUsername = "";
  File? _selectedImage;
  var _isAuthentic = false;


  void _submit() async {
   final isValid = _form.currentState!.validate();

   if (isValid || !_islogin && _selectedImage == null){
     return;
   }



     _form.currentState!.save();

   try {
    if  ( _islogin){
      final userCredential = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);


    }else{
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

         final storageRef = FirebaseStorage.instance.
         ref().
         child('user_images').
         child('${userCredentials.user!.uid}.jpg');
         
       await  storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'username': _enteredUsername,
        'email' : _enteredEmail,
        'image_url' : imageUrl,
      });

    }
    }on FirebaseAuthException catch(error){
     if(error.code == 'email-already-in-use' ){

     }
     ScaffoldMessenger.of(context).clearSnackBars();
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(error.message?? 'Authentication failed.'),
       ),
     );
     setState(() {
       _isAuthentic = false;
     });
   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                child: Image.asset("images/logo.jpg"),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_islogin)
                         UserImagePicker(
                          onPickImage: (pickedImage){
                            _selectedImage = pickedImage;
                          },
                         ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Email Address"
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: ( value ){
                           if (value == null ||
                               value.trim().isEmpty||
                               !value.contains("e")){
                             return " Please enter a valid email address.";
                           }
                           return null;

                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },

                        ),
                        if (_islogin)
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Username'),
                          enableSuggestions: false,
                          validator: (value){
                            if (value == null ||
                                 value.isEmpty||
                            value.trim().length <4){
                              return ' Please enter at least 4 characters.';
                            }
                            return null;
                          },
                          onSaved:(value){
                           _enteredUsername == value!;

                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Password"
                          ),
                         obscureText: true,
                          validator: (value){
                            if (value == null ||
                               value.trim().length < 8 ) {
                            return " password must be at lest 8 characters long ";
                         }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                         const SizedBox(height: 12),
                         if (!_isAuthenticating)
                           CircularProgressIndicator()
                        if (!_isAuthenticating)
                         ElevatedButton(onPressed: _submit,
                           style: ElevatedButton.styleFrom(
                             backgroundColor: Theme.of(context)
                                 .colorScheme
                                 .primaryContainer,
                           ),
                             child: Text(_islogin ? " Login " : " Signup "),
                        ),
                        TextButton(onPressed: (){
                          setState(() {
                            _islogin = _islogin ? false : true;
                          });
                        }
                            , child: Text( _islogin
                              ? "Create an account"
                              : "I already have an account"),
                            )
                      ],
                    )),

                ),
              ),
              )
            ]
          ),
        ),
      ),
    );
  }
}

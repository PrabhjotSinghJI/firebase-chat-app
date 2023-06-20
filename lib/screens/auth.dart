import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
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

  void _submit(){
   final isValid = _form.currentState!.validate();
   if (isValid){
     _form.currentState!.save();

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
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:music_band/AuthenticationService.dart';
import 'package:music_band/PageTransitionRoute.dart';
import 'package:music_band/homescreen.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _login_email;
  TextEditingController _login_pass;
  TextEditingController _register_email;
  TextEditingController _register_pass;
  TextEditingController _register_conpass;
  GlobalKey<FormState> _formKey_login = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey_register = GlobalKey<FormState>();
  bool _isSubmitting = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _login_email = new TextEditingController();
    _login_pass = new TextEditingController();
    _register_email = new TextEditingController();
    _register_pass = new TextEditingController();
    _register_conpass = new TextEditingController();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Band'),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isSubmitting,
        progressIndicator: Center(
          child: SpinKitFadingCircle(
            color: Theme.of(context).primaryColor,
            size: 50.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50.0,
              child:  AppBar(
                bottom: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      text: 'Login',
                    ),
                    Tab(
                      text: 'Register',
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                  children: <Widget>[
                    Container(
                      //height: screenHeight/2,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(8.0),
                      //   color: Colors.blueAccent,
                      // ),
                      child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey_login,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _login_email,
                                      decoration: new InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.redAccent, width: 3.0),
                                        ),
                                        focusedErrorBorder:  OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                        ),
                                        hintText: 'Email',
                                      ),
                                      validator: (val){
                                        if(val.isEmpty){
                                          return 'Please Enter Email';
                                        }else if(!isemailValid(val)){
                                          return 'Please Enter Valid Email';
                                        }
                                        else{
                                          return null;
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:20.0),
                                      child: TextFormField(
                                        controller: _login_pass,
                                        decoration: new InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.redAccent, width: 3.0),
                                          ),
                                          focusedErrorBorder:  OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                          ),
                                          hintText: 'Password',
                                        ),
                                        keyboardType: TextInputType.visiblePassword,
                                        obscureText: true,
                                        validator: (val){
                                          if(val.isEmpty){
                                            return 'Please Enter Password';
                                          }
                                          else{
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.all(25),
                                        child: RaisedButton(
                                          child: Text("Login", style: TextStyle(fontSize: 20),),
                                          onPressed:(){
                                            if(_formKey_login.currentState.validate()){
                                              _loginUser();
                                            }
                                          },
                                          color: Colors.amberAccent,
                                          padding: EdgeInsets.all(8.0),
                                          splashColor: Colors.grey,
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    Container(
                      // height: screenHeight/2,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(8.0),
                      //   color: Colors.orangeAccent,
                      // ),
                      child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey_register,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _register_email,
                                      decoration: new InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.redAccent, width: 3.0),
                                        ),
                                        focusedErrorBorder:  OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                        ),
                                        hintText: 'Email',
                                      ),
                                      validator: (val){
                                        if(val.isEmpty){
                                          return 'Please Enter Email';
                                        }else if(!isemailValid(val)){
                                          return 'Please Enter Valid Email';
                                        }
                                        else{
                                          return null;
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:20.0),
                                      child: TextFormField(
                                        controller: _register_pass,
                                        decoration: new InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.redAccent, width: 3.0),
                                          ),
                                          focusedErrorBorder:  OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                          ),
                                          hintText: 'Password',
                                        ),
                                        keyboardType: TextInputType.visiblePassword,
                                        obscureText: true,
                                        validator: (val){
                                          if(val.isEmpty){
                                            return 'Please Enter Password';
                                          }
                                          else{
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:20.0),
                                      child: TextFormField(
                                        controller: _register_conpass,
                                        decoration: new InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.redAccent, width: 3.0),
                                          ),
                                          focusedErrorBorder:  OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amberAccent, width: 3.0),
                                          ),
                                          hintText: 'Confirm Password',
                                        ),
                                        keyboardType: TextInputType.visiblePassword,
                                        obscureText: true,
                                        validator: (val){
                                          if(_register_pass.text != val){
                                            return 'Your Password not match';
                                          }
                                          else{
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.all(25),
                                        child: RaisedButton(
                                          child: Text("Register", style: TextStyle(fontSize: 20),),
                                          onPressed:(){
                                            if(_formKey_register.currentState.validate()){
                                              _registerUser();
                                            }
                                          },
                                          color: Colors.amberAccent,
                                          padding: EdgeInsets.all(8.0),
                                          splashColor: Colors.grey,
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }

  _registerUser() async {
    setState(() {
      _isSubmitting = true;
    });

    final logMessage = await AuthenticationService(auth).signUp(email: _register_email.text, password: _register_pass.text);

    logMessage == "Signed Up"
        ? _showSuccessSnack(logMessage)
        : _showErrorSnack(logMessage);

    print(logMessage);

    if (logMessage == "Signed Up") {
      setState(() {
        _isSubmitting = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          PageTransitionRoute(
              widget: HomeScreen()),(Route<dynamic> route) => false);
    } else {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  _loginUser() async {
    setState(() {
      _isSubmitting = true;
    });

    final logMessage = await AuthenticationService(auth).signIn(email: _login_email.text, password: _login_pass.text);

    logMessage == "Signed In"
        ? _showSuccessSnack(logMessage)
        : _showErrorSnack(logMessage);

    //print("I am logMessage $logMessage");

    if (logMessage == "Signed In") {
      setState(() {
        _isSubmitting = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          PageTransitionRoute(
              widget: HomeScreen()),(Route<dynamic> route) => false);
    } else {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  _showSuccessSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    // return Fluttertoast.showToast(
    //     msg: message,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.white,
    //     textColor: Colors.black,
    //     fontSize: 16.0
    // );
  }

  _showErrorSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    // return Fluttertoast.showToast(
    //     msg: message,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.white,
    //     textColor: Colors.black,
    //     fontSize: 16.0
    // );
  }

  bool isemailValid(String email){
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }
}


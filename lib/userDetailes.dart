import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:music_band/PageTransitionRoute.dart';
import 'package:music_band/homescreen.dart';
import 'package:phone_number/phone_number.dart';

class UserDetailes extends StatefulWidget {

  String booking_date,booking_email;

  UserDetailes({Key key, @required this.booking_date,@required this.booking_email}) : super(key: key);

  @override
  _UserDetailesState createState() => _UserDetailesState();
}

class _UserDetailesState extends State<UserDetailes> {

  GlobalKey<FormState> _formKey_booking = GlobalKey<FormState>();
  TextEditingController _booking_date;
  TextEditingController _booking_email;
  TextEditingController _booking_name;
  TextEditingController _booking_address;
  TextEditingController _booking_cost;
  TextEditingController _booking_contactNo;
  final dbRef = FirebaseDatabase.instance.reference().child("bookings");
  bool _isProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _booking_date = new TextEditingController();
    _booking_email = new TextEditingController();
    _booking_name = new TextEditingController();
    _booking_address = new TextEditingController();
    _booking_cost = new TextEditingController();
    _booking_contactNo = new TextEditingController();
    _booking_date.text = widget.booking_date;
    _booking_email.text = widget.booking_email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BookYour Band'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey_booking,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _booking_date,
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
                      hintText: 'Date',
                    ),
                    readOnly: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: TextFormField(
                      controller: _booking_email,
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
                      readOnly: true,
                    ),
                  ),
                  Padding(
                    padding: const  EdgeInsets.only(top:20.0),
                    child: TextFormField(
                      controller: _booking_name,
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
                        hintText: 'Name',
                      ),
                      validator: (val){
                        if(val.isEmpty){
                          return 'Please Enter Booking Name';
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
                      controller: _booking_address,
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
                        hintText: 'Address',
                      ),
                      validator: (val){
                        if(val.isEmpty){
                          return 'Please Enter Booking Address';
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
                      controller: _booking_cost,
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
                        hintText: 'Cost',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (val){
                        if(val.isEmpty){
                          return 'Please Enter Booking Cost';
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
                      controller: _booking_contactNo,
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
                        hintText: 'Contact No.',
                      ),
                      
                      keyboardType: TextInputType.phone,
                      validator: (val){
                        if(val.isEmpty){
                          return 'Please Enter Booking Contact No.';
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
                        child: Text("Book Band", style: TextStyle(fontSize: 20),),
                        onPressed:() async {
                          setState(() {
                            _isProgress = true;
                          });
                          if(_formKey_booking.currentState.validate()){
                            if(!await isValidPhoneNumber(_booking_contactNo.text, '+91', 'IN')){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text('Please Provide Valid Mobile Number')));
                            }else{
                              dbRef.push().set({
                                "date": _booking_date.text,
                                "email": _booking_email.text,
                                "name": _booking_name.text,
                                "address": _booking_address.text,
                                "cost": _booking_cost.text,
                                "contactNo": _booking_contactNo.text
                              }).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Successfully Added')));
                                _booking_date.clear();
                                _booking_email.clear();
                                _booking_name.clear();
                                _booking_address.clear();
                                _booking_cost.clear();
                                _booking_contactNo.clear();
                                setState(() {
                                  _isProgress = false;
                                });
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    PageTransitionRoute(
                                        widget: HomeScreen()),(Route<dynamic> route) => false);
                              }).catchError((onError) {
                                setState(() {
                                  _isProgress = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(onError.toString())));
                              });
                            }
                          }
                        },
                        color: Colors.amberAccent,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.grey,
                      )
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  Future<bool> isValidPhoneNumber(String mobileNumber, String countryCodeISO2,String region_code) async {

    String number = countryCodeISO2+mobileNumber;
    print(number);
    print(number+region_code);
    //RegionInfo region = RegionInfo(code: 'US',prefix: 1);
    PhoneNumberUtil plugin = PhoneNumberUtil();
    bool isValid = await plugin.validate(number,region_code);
    print(isValid);
    return isValid;
  }
}

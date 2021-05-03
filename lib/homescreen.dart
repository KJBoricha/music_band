import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:music_band/AuthenticationService.dart';
import 'package:music_band/PageTransitionRoute.dart';
import 'package:music_band/loginpage.dart';
import 'package:music_band/userDetailes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.reference();
  final Future<FirebaseApp> _future = Firebase.initializeApp();
  final dbRef = FirebaseDatabase.instance.reference().child("bookings");
  bool isProgress = false;
  List<Map<dynamic, dynamic>> lists = [];
  DateTime currentdate = DateTime.now();
  String _current_user_email,_booking_date;

  @override
  void initState() {
    // TODO: implement initState
    _current_user_email = auth.currentUser.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Band'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              child: Icon(
                Icons.logout,
                size: 30,
              ),
              onTap: () {
                setState(() {
                  isProgress = true;
                });
                AuthenticationService(auth).signOut();
                setState(() {
                  isProgress = false;
                });
                Navigator.pushAndRemoveUntil(
                    context,
                    PageTransitionRoute(widget: LoginPage()),
                    (Route<dynamic> route) => false);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: Colors.amberAccent,
        onPressed: () async {
          _booking_date = await selectDate(context,currentdate);
          if(_booking_date != null && _booking_date.isNotEmpty){
            if(await isValidDateForBooking()){
              Navigator.push(
                  context,
                  PageTransitionRoute(
                      widget: UserDetailes(booking_date: _booking_date, booking_email: _current_user_email)));
            }else{
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Not Booking Available for Date')));
            }
          }
        },
      ),
      body: ModalProgressHUD(
          inAsyncCall: isProgress,
          progressIndicator: Center(
            child: SpinKitFadingCircle(
              color: Theme.of(context).primaryColor,
              size: 50.0,
            ),
          ),
          child:FutureBuilder(
              future: dbRef
                  .orderByChild('email')
                  .equalTo('$_current_user_email')
                  .once(),
              builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                if(snapshot.data == null){
                  return Center(
                      child: SpinKitFadingCircle(
                        color: Theme.of(context).primaryColor,
                        size: 50.0,
                      ));
                }else if(snapshot.data.value == null){
                  return Container(
                    child: Center(
                        child: Image.asset(
                          'assets/empty.png',
                          width: 200,
                          height: 200,
                        )),
                  );
                }
                else if (snapshot.hasData) {
                  lists.clear();
                  Map<dynamic, dynamic> values = snapshot.data.value;
                  values.forEach((key, values) {
                    lists.add(values);
                  });
                  return new ListView.builder(
                      shrinkWrap: true,
                      itemCount: lists.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 10,
                          color: Colors.yellow[200],
                          shadowColor: Colors.black12,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Date: " + lists[index]["date"]),
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: Text("Email: " + lists[index]["email"]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: Text("Name: " + lists[index]["name"]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: Text("Address: " + lists[index]["address"]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: Text("Cost: " + lists[index]["cost"]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: Text("Contact No: " + lists[index]["contactNo"]),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                } else if (snapshot.hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(snapshot.hasError.toString())));
                }
                return Center(
                    child: SpinKitFadingCircle(
                  color: Theme.of(context).primaryColor,
                  size: 50.0,
                ));
              })),
    );
  }

  Future<String> selectDate(BuildContext context,DateTime currentDate) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: currentDate,
        lastDate: currentDate.add(Duration(days: 6)));
    if (pickedDate != null && pickedDate != currentDate){
      return getDate(pickedDate.toString());
    }
  }

  String getDate(String time){
    int cn_y = Jiffy(time).year;
    int cn_m = Jiffy(time).month;
    int cn_d = Jiffy(time).date;
    return formatDate(DateTime(cn_y,cn_m,cn_d), [d, ' ', M, ' ', yyyy]);
  }

  Future<bool> isValidDateForBooking() async {
    bool isvalid;
    await dbRef.orderByChild('date').equalTo('$_booking_date').once().then((value) => {
      if(value.value != null){
        isvalid = false,
      }else{
        isvalid = true,
      }
    });
    return isvalid;
  }
}

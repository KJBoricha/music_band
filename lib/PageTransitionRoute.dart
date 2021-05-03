import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class PageTransitionRoute extends PageRouteBuilder{
  final Widget widget;

  PageTransitionRoute({this.widget})
      :super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    widget,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        Align(
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        ),
    //   transitionDuration: Duration(seconds: 1),
    // transitionsBuilder: (BuildContext contex,Animation<double> animation,Animation<double> secAnimation,Widget child){
    //     animation = CurvedAnimation(parent: animation,curve: Curves.elasticInOut);
    //     return ScaleTransition(scale:animation,alignment: Alignment.center,child: child,);
    // },
    // pageBuilder: (BuildContext contex,Animation<double> animation,Animation<double> secAnimation){
    //     return widget;
    // }
    );
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailfirebase/firebaseClass/changeNotifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Color appPrimeColor = Color.fromRGBO(78, 227, 236, 1);
// Color appPrimeColor = Color.fromRGBO(88, 129, 241, 1);
Color appPrimeRedColor = Colors.red;
Color appPrimeGreenColor = Colors.green;
Color buttonColor = Color.fromRGBO(252, 81, 133, 1);

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final pageSwap = PageSwap();

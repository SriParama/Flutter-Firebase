import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailfirebase/components/my_textfield.dart';
import 'package:emailfirebase/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';

class EduDetailScreen extends StatefulWidget {
  // GlobleKey _formkey;

  EduDetailScreen({
    super.key,
  });

  @override
  State<EduDetailScreen> createState() => _EduDetailScreenState();
}

class _EduDetailScreenState extends State<EduDetailScreen> {
  final TextEditingController _fnameController = TextEditingController();

  final TextEditingController _lnameController = TextEditingController();

  final TextEditingController _MobNoController = TextEditingController();

  final TextEditingController _genderController = TextEditingController();

  final TextEditingController _dobController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String emailId = '';
  Map<String, dynamic> userDetails = {};

  @override
  void initState() {
    super.initState();
    emailId = firebaseAuth.currentUser!.email.toString();
    getuserDetails();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  getuserDetails() async {
    var details = await firestore.collection('Users').doc(emailId).get();
    userDetails = details.data() as Map<String, dynamic>;

    print('userDetails');
    print(userDetails);
  }

  personalDetails() async {
    if (_formKey.currentState!.validate()) {
      print('before adduserDetails');
      print(userDetails);
      // Map<String, dynamic> user = userDetails['details'][0]['personalDetails'];
      // print('before add users...');
      // print(user);
      Map<String, dynamic> personalDetails = {
        'First_Name': _fnameController.text,
        'Last_Name': _lnameController.text,
        'Mob_No': _MobNoController.text,
        'Gender': _genderController.text,
        'DOB': _dobController.text,
      };
      userDetails['details'][1]['educationDetails'] = personalDetails;
      print('after add users...');
      print(userDetails);
      // userDetails = userDetails;
      await firestore.collection('Users').doc(emailId).update(userDetails);

      // await firestore.collection('Users').doc(emailId).
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30.0,
          ),
          Center(
            child: Text(
              'Education Details',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          MyTextField(
            controller: _fnameController,
            hintText: 'First_Name',
            obscureText: false,
          ),
          SizedBox(
            height: 20.0,
          ),
          MyTextField(
            controller: _lnameController,
            hintText: 'Last_Name',
            obscureText: false,
          ),
          SizedBox(
            height: 20.0,
          ),
          MyTextField(
            controller: _MobNoController,
            hintText: 'Mobile_No',
            obscureText: false,
          ),
          SizedBox(
            height: 20.0,
          ),
          MyTextField(
            controller: _genderController,
            hintText: 'Gender',
            obscureText: false,
          ),
          SizedBox(
            height: 20.0,
          ),
          MyTextField(
            controller: _dobController,
            hintText: 'DOB',
            obscureText: false,
          ),
          SizedBox(
            height: 50.0,
          ),
          MyButton(
            btnColor: appPrimeColor,
            btnText: 'Continue',
            onTap: () {
              personalDetails();
            },
          )
        ],
      ),
    );
  }
}

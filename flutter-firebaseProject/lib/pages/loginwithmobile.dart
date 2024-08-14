import 'package:emailfirebase/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class PhoneNumberAuthScreen extends StatefulWidget {
  @override
  _PhoneNumberAuthScreenState createState() => _PhoneNumberAuthScreenState();
}

class _PhoneNumberAuthScreenState extends State<PhoneNumberAuthScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();

  String? _verificationId;
  bool enableotpField = false;

  Future<void> _verifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      // This callback will be called when auto-retrieval of OTP is completed.
      // For example, phone number has been instantly verified without needing OTP.
      // You can use phoneAuthCredential to sign in the user.
    };

    verificationFailed(FirebaseAuthException authException) {
      // Handle the error
      print(authException.message);
    }

    codeSent(String verificationId, [int? forceResendingToken]) {
      // Save the verification ID somewhere for later usage
      enableotpField = true;
      _verificationId = verificationId;
      setState(() {});
    }

    codeAutoRetrievalTimeout(String verificationId) {
      // Auto-resolution timed out...
    }

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: _phoneNumberController.text,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsCodeController.text,
      );
      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      final User user = userCredential.user!;
      print('User signed in: ${user.uid}');
    } catch (e) {
      print('Failed to sign in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // email textfield
              MyTextField(
                controller: _phoneNumberController,
                hintText: 'Mobile_Number',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              Visibility(
                visible: enableotpField,
                child: MyTextField(
                  controller: _smsCodeController,
                  hintText: 'OTP',
                  obscureText: true,
                ),
              ),

              // forgot password?

              const SizedBox(height: 25),

              // sign in button
              MyButton(
                onTap: enableotpField == true
                    ? _signInWithPhoneNumber
                    : _verifyPhoneNumber,
                btnColor: Colors.blue,
                btnText:
                    enableotpField == true ? 'Sign In' : 'Verify Phone Number',
              ),
              // const SizedBox(height: 25),
              // MyButton(
              //   onTap: _signInWithPhoneNumber,
              //   btnColor: Colors.blue,
              //   btnText: 'Sign In',
              // ),

              // google + apple sign in buttons

              // not a member? register now
            ],
          ),
        ),
      ),
    );

    // Scaffold(
    //   appBar: AppBar(
    //     title: Text('Phone Number Authentication'),
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(20.0),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         TextField(
    //           controller: _phoneNumberController,
    //           decoration: InputDecoration(labelText: 'Phone Number'),
    //         ),
    //         SizedBox(height: 20.0),
    //         ElevatedButton(
    //           onPressed: _verifyPhoneNumber,
    //           child: Text('Verify Phone Number'),
    //         ),
    //         SizedBox(height: 20.0),
    //         TextField(
    //           controller: _smsCodeController,
    //           decoration: InputDecoration(labelText: 'SMS Code'),
    //         ),
    //         SizedBox(height: 20.0),
    //         ElevatedButton(
    //           onPressed: _signInWithPhoneNumber,
    //           child: Text('Sign In'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: PhoneNumberAuthScreen(),
//   ));
// }

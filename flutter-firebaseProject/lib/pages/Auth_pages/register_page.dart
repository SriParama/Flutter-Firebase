import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailfirebase/components/my_button.dart';
import 'package:emailfirebase/components/my_textfield.dart';
import 'package:emailfirebase/components/showSnackbar.dart';
import 'package:emailfirebase/components/square_tile.dart';
import 'package:emailfirebase/pages/Auth_pages/loginScreen.dart';
import 'package:emailfirebase/pages/Dashboard/dashboard.dart';
import 'package:emailfirebase/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController regEmailController = TextEditingController();
  TextEditingController regPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _formKey1 = GlobalKey<FormState>();

  registerNow() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (_formKey1.currentState!.validate()) {
      try {
        print('1');

        if (regPasswordController.text == confirmPasswordController.text) {
          var res = await firebaseAuth.createUserWithEmailAndPassword(
              email: regEmailController.text,
              password: regPasswordController.text);
          print('+++++++++++');
          print(res);
          print(res.additionalUserInfo!.isNewUser);
          // if (res.additionalUserInfo!.isNewUser) {
          Navigator.pop(context);

          showSnackbar(
              context, 'Create New User  Successfully....', appPrimeGreenColor);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(),
              ),
              (route) => false);

          // showDailog('Create New User  Successfully....', appPrimeGreenColor);

          print('Create New User  Successfully....');
        } else {
          Navigator.pop(context);
          showSnackbar(
              context, 'PassWord is miss matched...', appPrimeRedColor);
        }
      } on FirebaseAuthException catch (e) {
        // pop the loading circle
        print('***********');
        print(e);
        print(e.code);
        //          showSnackbar(context, 'PassWord is miss matched...', appPrimeRedColor);
        // Navigator.pop(context);
        // WRONG EMAIL

        if (e.code == 'invalid-email') {
          // show error to user
          // print(e.code);
          showSnackbar(context, e.code, appPrimeRedColor);
        } else if (e.code == 'user-not-found') {
          showSnackbar(context, e.code, appPrimeRedColor);
        }

        // WRONG PASSWORD
        else if (e.code == 'wrong-password') {
          // show error to user
          showSnackbar(context, e.code, appPrimeRedColor);
        } else {
          // Navigator.pop(context);
          // Navigator.pop(context);
          print('hi');
          showSnackbar(context, e.toString(), appPrimeRedColor);
        }
        Navigator.pop(context);
      }
    } else {
      print('isEmpty');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        backgroundColor: appPrimeColor,
        centerTitle: true,
        title: Text(
          'REGISTER NOW',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.90,
          width: MediaQuery.of(context).size.width,
          color: appPrimeColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Form(
                key: _formKey1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 50),
                    Lottie.asset('lib/assets/images/login2.json',
                        height: 250, width: 250),

                    // email textfield
                    MyTextField(
                      prefficsIcons: Icon(Icons.email),
                      controller: regEmailController,
                      hintText: 'example@gmail.com',
                      obscureText: false,
                    ),

                    const SizedBox(height: 20),

                    // password textfield
                    MyTextField(
                      prefficsIcons: Icon(Icons.key),
                      controller: regPasswordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 20),
                    MyTextField(
                      prefficsIcons: Icon(Icons.key),
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 50),

                    // sign in button
                    MyButton(
                      onTap: registerNow,
                      btnColor: buttonColor,
                      btnText: 'SIGN UP',
                    ),

                    const SizedBox(height: 25),
                    // MyButton(
                    //   onTap: registerDialog,
                    //   btnColor: Colors.green,
                    //   btnText: 'Register Now',
                    // ),
                    // const SizedBox(height: 25),

                    // or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // google + apple sign in buttons
                    // SquareTile(
                    //     imagePath: 'lib/assets/images/google.png',
                    //     onclickFuc: () {
                    //       // print('+++++++++++');
                    //       // GoogleSignInAccount? emailuser =
                    //       GoogleSignIn().signIn();
                    //       // var email = emailuser!.email;
                    //       // print(emailuser);
                    //     }
                    //     //  _handleSignIn(),
                    //     ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      // color: buttonColor,
                      child: Image.asset(
                        'lib/assets/images/google.png',
                        scale: 15,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'I have an Account ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                            // registerDialog();
                            // signUpUser();
                            // forgetPassword();
                            // var a = await firebaseAuth
                            //     .createUserWithEmailAndPassword(
                            //         email: 'praveen@gmail.com',
                            //         password: '654321');
                            // // print(a.runtimeType);
                            // print(a);
                            // print('success');
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: buttonColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailfirebase/components/my_button.dart';
import 'package:emailfirebase/components/my_textfield.dart';
import 'package:emailfirebase/components/showSnackbar.dart';
import 'package:emailfirebase/components/square_tile.dart';
import 'package:emailfirebase/pages/Dashboard/dashboard.dart';
import 'package:emailfirebase/pages/home_page.dart';
import 'package:emailfirebase/pages/Auth_pages/register_page.dart';
import 'package:emailfirebase/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _forgotPwdController = TextEditingController();
  String userName = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  void logIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    if (_formKey.currentState!.validate()) {
      try {
        var response = await firebaseAuth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // pop the loading circle
        Navigator.pop(context);
        print("response.user!.email");
        print(response.user!.email);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(),
            ),
            (route) => false);
      } on FirebaseAuthException catch (e) {
        // pop the loading circle
        print('***********');
        print(e.code);
        // Navigator.pop(context);
        // WRONG EMAIL
        if (e.code == 'invalid-email') {
          showSnackbar(context, e.code, appPrimeRedColor);
        } else if (e.code == 'user-not-found') {
          showSnackbar(context, e.code, appPrimeRedColor);
        }
        // WRONG PASSWORD
        else if (e.code == 'wrong-password') {
          // show error to user
          showSnackbar(context, e.code, appPrimeRedColor);
        } else {
          print(e.code);
          print('else code');
          showSnackbar(context, e.code, appPrimeRedColor);
        }
        Navigator.pop(context);
      }
    } else {
      print('isEmpty');
      Navigator.pop(context);
    }

    // try sign in
  }

  forgetPassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    print(emailController.text);
    print(passwordController.text);

    // if (_formKey.currentState!.validate()) {
    try {
      print('1');

      // await firebaseAuth.verifyPasswordResetCode(
      //   AutofillHints.newPassword
      // //   code: ,
      // //  newPassword: '',
      //   // password: passwordController.text,
      // );
      await firebaseAuth.sendPasswordResetEmail(
          email: _forgotPwdController.text);
      // pop the loading circle
      print('Password Changed Successfully....');

      Navigator.pop(context);
      showSnackbar(
          context, 'Password Changed Successfully....', appPrimeGreenColor);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      print('***********');
      print(e);
      print(e.code);
      Navigator.pop(context);
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
        showSnackbar(context, e.code, appPrimeRedColor);
      }
    }
    // } else {
    //   print('isEmpty');
    //   Navigator.pop(context);
    // }
  }

  TextEditingController regEmailController = TextEditingController();
  TextEditingController regPasswordController = TextEditingController();

  void forgotDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // surfaceTintColor: Colors.blue,
          backgroundColor: appPrimeColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FORGET PASSWORD',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onTap: () => Navigator.pop(context),
              )
            ],
          ),
          actions: [
            MyTextField(
              prefficsIcons: Icon(Icons.email),
              controller: _forgotPwdController,
              hintText: 'Email',
              obscureText: false,
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: SizedBox(
                width: 230,
                height: 50,
                child: MyButton(
                    onTap: forgetPassword,
                    btnColor: buttonColor,
                    btnText: 'RESET'),
              ),
            )
          ],

          // title: Center(
          //   child: Text(
          //     msg,
          //     style: TextStyle(color: Colors.white),
          //   ),
          // ),
        );
      },
    );
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
          'LOGIN',
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
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 50),
                    Lottie.asset('lib/assets/images/login2.json',
                        height: 250, width: 250),

                    // email textfield
                    MyTextField(
                      prefficsIcons: Icon(Icons.email),
                      controller: emailController,
                      hintText: 'example@gmail.com',
                      obscureText: false,
                    ),

                    const SizedBox(height: 20),

                    // password textfield
                    MyTextField(
                      prefficsIcons: Icon(Icons.key),
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 15),

                    // forgot password?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Expanded(
                          //   child: TextField(
                          //     controller: _forgotPwdController,
                          //   ),
                          // ),
                          InkWell(
                            onTap: () {
                              forgotDialog();
                              // forgetPassword();
                              //                        await firebaseAuth.signInWithEmailAndPassword(
                              //   email: emailController.text,
                              //   password: passwordController.text,
                              // );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // sign in button
                    MyButton(
                      onTap: logIn,
                      btnColor: buttonColor,
                      btnText: 'LOG IN',
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
                              color: const Color.fromARGB(255, 240, 236, 236),
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
                              color: const Color.fromARGB(255, 240, 236, 236),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // google + apple sign in buttons
                    // SquareTile(
                    //     imagePath: 'lib/assets/images/google.png',
                    //     onclickFuc: () {
                    //       // print('+++++++++++');
                    //       // GoogleSignInAccount? emailuser =
                    //       //     await GoogleSignIn().signIn();
                    //       // emailController.text = emailuser!.email;
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

                    const SizedBox(height: 50),

                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member? ',
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
                                  builder: (context) => SignUpScreen(),
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
                            'Register now',
                            style: TextStyle(
                              color: buttonColor,
                              fontSize: 18,
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

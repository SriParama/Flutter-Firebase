// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:emailfirebase/components/my_button.dart';
// import 'package:emailfirebase/components/my_textfield.dart';
// import 'package:emailfirebase/components/square_tile.dart';
// import 'package:emailfirebase/utils/colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class LoginPage extends StatefulWidget {
//   LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   // text editing controllers
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final _forgotPwdController = TextEditingController();
//   String userName = '';
//   // dynamic data;
//   @override
//   void initState() {
//     // getfirestoreData();
//     print('firebaseAuth.currentUser');

//     // userName = firebaseAuth.currentUser!.email!;
//     print(userName);
//     // TODO: implement initState
//     super.initState();
//   }

//   // getfirestoreData() async {
//   //   var data =
//   //       await FirebaseFirestore.instance.collection('users').doc('sri').get();
//   //   print('sdafdsfdsfds**********');
//   //   print(data.data());
//   // }

//   // List msg = [];

//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   // Future<String> getNotification(
//   //     {required String userName, required List productDetails
//   //     // required bool deviceIsActive,
//   //     }) async {
//   //   // getMessageFromFireBase();
//   //   print('getNotification');
//   //   print('before..............');
//   //   print(msg);

//   //   msg = await getLoginData();

//   //   print('*****after*********');
//   //   print(msg);
//   //   List msgId = [];
//   //   for (var message in msg) {
//   //     msgId.add(message['id']);
//   //   }
//   //   print('Message Id');
//   //   print(msgId);
//   //   if (!msgId.contains(messageId)) {
//   //     msg.add({"userName": userName, 'Details': productDetails,});
//   //   }

//   //   //  bool ismsgId =  msg.;

//   //   print('After Adding notification');
//   //   print(msg);
//   //   String res = 'Some Error Occured';
//   //   try {
//   //     await firestore
//   //         .collection('Users')
//   //         .doc('Notifications')
//   //         .update({"message": msg});
//   //     res = 'success';
//   //     print('After Adding from notification');
//   //     print(msg);
//   //     print('res : $res');
//   //   } catch (e) {
//   //     res = e.toString();
//   //   }
//   //   return res;
//   // }

//   Future<List<Map<String, dynamic>>> getLoginData(String userName) async {
//     List<Map<String, dynamic>> userList = [];

//     try {
//       print('Load 1 ');
//       var collectionRef = firestore.collection('Users');
//       var collectionSnapshot = await collectionRef.get();

//       if (collectionSnapshot.docs.isNotEmpty) {
//         print('Document is not Empty');

//         var docSnapshot = await collectionRef.doc('$userName').get();
//         if (docSnapshot.exists && docSnapshot.data()!.containsKey('details')) {
//           print('Data is Not Empty');
//           userList =
//               List<Map<String, dynamic>>.from(docSnapshot.get('details'));
//           print(userList);
//         } else {
//           print('Setting the messages');
//           await collectionRef.doc('$userName').set({
//             'details': [
//               {'personalDetails': {}},
//               {'educationDetails': {}},
//             ]
//           });
//         }
//       } else {
//         print('else Part');
//         await collectionRef.doc('$userName').set({
//           'details': [
//             {'personalDetails': {}},
//             {'educationDetails': {}},
//           ]
//         });
//         userList = [];
//       }
//     } catch (e) {
//       print('Error loading data from Firestore: $e');
//     }

//     return userList;
//   }

//   // Future<List<Map<String, dynamic>>> getProductDetails() async {
//   //   List<Map<String, dynamic>> productList = [];

//   //   try {
//   //     print('Load 1 ');
//   //     var collectionRef = firestore.collection('Products');
//   //     var collectionSnapshot = await collectionRef.get();

//   //     if (collectionSnapshot.docs.isNotEmpty) {
//   //       print('Document is not Empty');

//   //       var docSnapshot = await collectionRef.doc('Category').get();
//   //       if (docSnapshot.exists && docSnapshot.data()!.containsKey('Items')) {
//   //         print('Data is Not Empty');
//   //         productList =
//   //             List<Map<String, dynamic>>.from(docSnapshot.get('Items'));
//   //         print(productList);
//   //       } else {
//   //         print('Setting the messages');
//   //         await collectionRef.doc('Category').set({'Items': []});
//   //       }
//   //     } else {
//   //       print('else Part');
//   //       await collectionRef.doc('Category').set({'Items': []});
//   //       productList = [];
//   //     }
//   //   } catch (e) {
//   //     print('Error loading data from Firestore: $e');
//   //   }

//   //   return productList;
//   // }

//   // sign user in method  showDailog(e.code, appPrimeRedColor);
//   void signUserIn() async {
//     // show loading circle
//     showDialog(
//       context: context,
//       builder: (context) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//     if (_formKey.currentState!.validate()) {
//       try {
//         await firebaseAuth.signInWithEmailAndPassword(
//           email: emailController.text,
//           password: passwordController.text,
//         );
//         // pop the loading circle
//         Navigator.pop(context);
//       } on FirebaseAuthException catch (e) {
//         // pop the loading circle
//         print('***********');
//         print(e.code);
//         // Navigator.pop(context);
//         // WRONG EMAIL
//         if (e.code == 'invalid-email') {
//           showSnackbar(context, e.code, appPrimeRedColor);
//         } else if (e.code == 'user-not-found') {
//           showSnackbar(context, e.code, appPrimeRedColor);
//         }
//         // WRONG PASSWORD
//         else if (e.code == 'wrong-password') {
//           // show error to user
//           showSnackbar(context, e.code, appPrimeRedColor);
//         } else {
//           showSnackbar(context, e.code, appPrimeRedColor);
//         }
//         Navigator.pop(context);
//       }
//     } else {
//       print('isEmpty');
//       Navigator.pop(context);
//     }

//     // try sign in
//   }

//   void signUpUser() async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//     if (_formKey.currentState!.validate()) {
//       try {
//         await firebaseAuth.createUserWithEmailAndPassword(
//           email: emailController.text,
//           password: passwordController.text,
//         );
//         Navigator.pop(context);
//       } on FirebaseAuthException catch (e) {
//         print(e);
//         Navigator.pop(context);
//         // Navigator.pop(context);
//         // WRONG EMAIL
//         if (e.code == 'invalid-email') {
//           // show error to user
//           // print(e.code);
//           //  Navigator.pop(context);
//           showSnackbar(context, e.code, appPrimeRedColor);
//         } else if (e.code == 'user-not-found') {
//           //  Navigator.pop(context);
//           showSnackbar(context, e.code, appPrimeRedColor);
//         }

//         // WRONG PASSWORD
//         else if (e.code == 'wrong-password') {
//           // show error to user

//           showSnackbar(context, e.code, appPrimeRedColor);
//         } else {
//           showSnackbar(context, e.code, appPrimeRedColor);
//         }
//         // Navigator.pop(context);
//       }
//     } else {
//       print('isEmpty');
//       Navigator.pop(context);
//     }

//     // try sign in
//   }
// //    List<String> scopes = <String>[
// //   'email',
// //   'https://www.googleapis.com/auth/contacts.readonly',
// // ];

//   // final GoogleSignIn _googleSignIn = GoogleSignIn(
//   //     // Optional clientId
//   //     // clientId: 'your-client_id.apps.googleusercontent.com',
//   //     // scopes: scopes,
//   //     );
//   // Future<void> _handleSignIn() async {
//   //   // print('hi');
//   //   try {
//   //     GoogleSignInAccount? emailuser = await _googleSignIn.signIn();
//   //     print(emailuser!.email);
//   //     print("_googleSignIn.clientId");
//   //     print(_googleSignIn.isSignedIn());
//   //   } catch (error) {
//   //     print(error);
//   //   }
//   // }

//   forgetPassword() async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//     print(emailController.text);
//     print(passwordController.text);

//     // if (_formKey.currentState!.validate()) {
//     try {
//       print('1');

//       // await firebaseAuth.verifyPasswordResetCode(
//       //   AutofillHints.newPassword
//       // //   code: ,
//       // //  newPassword: '',
//       //   // password: passwordController.text,
//       // );
//       await firebaseAuth.sendPasswordResetEmail(
//           email: _forgotPwdController.text);
//       // pop the loading circle
//       print('Password Changed Successfully....');

//       Navigator.pop(context);
//       showSnackbar(
//           context, 'Password Changed Successfully....', appPrimeGreenColor);
//     } on FirebaseAuthException catch (e) {
//       // pop the loading circle
//       print('***********');
//       print(e);
//       print(e.code);
//       Navigator.pop(context);
//       // WRONG EMAIL
//       if (e.code == 'invalid-email') {
//         // show error to user
//         // print(e.code);
//         showSnackbar(context, e.code, appPrimeRedColor);
//       } else if (e.code == 'user-not-found') {
//         showSnackbar(context, e.code, appPrimeRedColor);
//       }

//       // WRONG PASSWORD
//       else if (e.code == 'wrong-password') {
//         // show error to user
//         showSnackbar(context, e.code, appPrimeRedColor);
//       } else {
//         showSnackbar(context, e.code, appPrimeRedColor);
//       }
//     }
//     // } else {
//     //   print('isEmpty');
//     //   Navigator.pop(context);
//     // }
//   }

//   TextEditingController regEmailController = TextEditingController();
//   TextEditingController regPasswordController = TextEditingController();

//   registerNew() async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//     print(regEmailController.text);
//     print(passwordController.text);

//     if (_formKey1.currentState!.validate()) {
//       try {
//         print('1');

//         // await firebaseAuth.verifyPasswordResetCode(
//         //   AutofillHints.newPassword
//         // //   code: ,
//         // //  newPassword: '',
//         //   // password: passwordController.text,
//         // );
//         var res = await firebaseAuth.createUserWithEmailAndPassword(
//             email: regEmailController.text,
//             password: regPasswordController.text);
//         print('+++++++++++');
//         print(res);
//         print(res.additionalUserInfo!.isNewUser);
//         // if (res.additionalUserInfo!.isNewUser) {
//         //   Navigator.pop(context);
//         //   Navigator.pop(context);
//         //   await getLoginData(regEmailController.text);
//         //   showSnackbar(
//         //       context, 'Create New User  Successfully....', appPrimeGreenColor);
//         // }
//         // pop the loading circle

//         Navigator.pop(context);
//         Navigator.pop(context);
//         showSnackbar(
//             context, 'Create New User  Successfully....', appPrimeGreenColor);

//         // showDailog('Create New User  Successfully....', appPrimeGreenColor);

//         print('Create New User  Successfully....');
//       } on FirebaseAuthException catch (e) {
//         // pop the loading circle
//         print('***********');
//         print(e);
//         print(e.code);
//         Navigator.pop(context);
//         // WRONG EMAIL

//         if (e.code == 'invalid-email') {
//           // show error to user
//           // print(e.code);
//           showSnackbar(context, e.code, appPrimeRedColor);
//         } else if (e.code == 'user-not-found') {
//           showSnackbar(context, e.code, appPrimeRedColor);
//         }

//         // WRONG PASSWORD
//         else if (e.code == 'wrong-password') {
//           // show error to user
//           showSnackbar(context, e.code, appPrimeRedColor);
//         } else {
//           // Navigator.pop(context);
//           // Navigator.pop(context);
//           print('hi');
//           showSnackbar(context, e.code, appPrimeRedColor);
//         }
//       }
//     } else {
//       print('isEmpty');
//       Navigator.pop(context);
//     }
//   }

//   // wrong email message popup
//   // void showDailog(String msg, Color bgcolor) {
//   //   showDialog(

//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         backgroundColor: bgcolor,
//   //         title: Center(
//   //           child: Text(
//   //             msg,
//   //             style: TextStyle(color: Colors.white),
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   dynamic showSnackbar(BuildContext context, String message, Color color) {
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: const TextStyle(fontSize: 14.0, color: Colors.white),
//           textAlign: TextAlign.left,
//         ),
//         backgroundColor: color,
//         duration: const Duration(seconds: 3),
//         dismissDirection: DismissDirection.up,
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.only(
//             bottom: MediaQuery.of(context).size.height * 0.05,
//             left: 10,
//             right: 10),
//         elevation: 20,
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//         // behavior: SnackBarBehavior.fixed,
//       ),
//     );
//   }

//   void forgotDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           surfaceTintColor: Colors.blue,
//           // backgroundColor: Colors.deepPurple,
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('ForgotPassword'),
//               InkWell(
//                 child: Icon(Icons.close),
//                 onTap: () => Navigator.pop(context),
//               )
//             ],
//           ),
//           actions: [
//             MyTextField(
//               controller: _forgotPwdController,
//               hintText: 'Email',
//               obscureText: false,
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//             MyButton(
//                 onTap: forgetPassword,
//                 btnColor: Colors.orange,
//                 btnText: 'ResetPassword')
//           ],

//           // title: Center(
//           //   child: Text(
//           //     msg,
//           //     style: TextStyle(color: Colors.white),
//           //   ),
//           // ),
//         );
//       },
//     );
//   }

//   registerDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Form(
//           key: _formKey1,
//           child: AlertDialog(
//             surfaceTintColor: Colors.blue,
//             // backgroundColor: Colors.deepPurple,
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Register Now'),
//                 InkWell(
//                   child: Icon(Icons.close),
//                   onTap: () => Navigator.pop(context),
//                 )
//               ],
//             ),
//             actions: [
//               MyTextField(
//                 controller: regEmailController,
//                 hintText: 'Email',
//                 obscureText: false,
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               MyTextField(
//                 controller: regPasswordController,
//                 hintText: 'Password',
//                 obscureText: false,
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               MyButton(
//                   onTap: registerNew,
//                   btnColor: Colors.green,
//                   btnText: 'Register Now')
//             ],

//             // title: Center(
//             //   child: Text(
//             //     msg,
//             //     style: TextStyle(color: Colors.white),
//             //   ),
//             // ),
//           ),
//         );
//       },
//     );
//   }

//   // wrong password message popup
//   // void wrongPasswordMessage() {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return const AlertDialog(
//   //         backgroundColor: Colors.deepPurple,
//   //         title: Center(
//   //           child: Text(
//   //             'Incorrect Password',
//   //             style: TextStyle(color: Colors.white),
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   final _formKey = GlobalKey<FormState>();
//   final _formKey1 = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 50),

//                   // logo
//                   const Icon(
//                     Icons.lock,
//                     size: 100,
//                   ),

//                   const SizedBox(height: 50),

//                   // welcome back, you've been missed!
//                   Text(
//                     'Welcome back you\'ve been missed!',
//                     style: TextStyle(
//                       color: Colors.grey[700],
//                       fontSize: 16,
//                     ),
//                   ),

//                   const SizedBox(height: 25),

//                   // email textfield
//                   MyTextField(
//                     controller: emailController,
//                     hintText: 'Email',
//                     obscureText: false,
//                   ),

//                   const SizedBox(height: 10),

//                   // password textfield
//                   MyTextField(
//                     controller: passwordController,
//                     hintText: 'Password',
//                     obscureText: true,
//                   ),

//                   const SizedBox(height: 10),

//                   // forgot password?
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         // Expanded(
//                         //   child: TextField(
//                         //     controller: _forgotPwdController,
//                         //   ),
//                         // ),
//                         InkWell(
//                           onTap: () {
//                             forgotDialog();
//                             // forgetPassword();
//                             //                        await firebaseAuth.signInWithEmailAndPassword(
//                             //   email: emailController.text,
//                             //   password: passwordController.text,
//                             // );
//                           },
//                           child: Text(
//                             'Forgot Password?',
//                             style: TextStyle(color: Colors.grey[600]),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 25),

//                   // sign in button
//                   MyButton(
//                     onTap: signUserIn,
//                     btnColor: Colors.blue,
//                     btnText: 'Sign In',
//                   ),

//                   const SizedBox(height: 25),
//                   MyButton(
//                     onTap: registerDialog,
//                     btnColor: Colors.green,
//                     btnText: 'Register Now',
//                   ),
//                   const SizedBox(height: 25),

//                   // or continue with
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Divider(
//                             thickness: 0.5,
//                             color: Colors.grey[400],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                           child: Text(
//                             'Or continue with',
//                             style: TextStyle(color: Colors.grey[700]),
//                           ),
//                         ),
//                         Expanded(
//                           child: Divider(
//                             thickness: 0.5,
//                             color: Colors.grey[400],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 50),

//                   // google + apple sign in buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // google button
//                       SquareTile(
//                           imagePath: 'lib/assets/images/google.png',
//                           onclickFuc: () {
//                             // print('+++++++++++');
//                             // GoogleSignInAccount? emailuser =
//                             GoogleSignIn().signIn();
//                             // var email = emailuser!.email;
//                             // print(emailuser);
//                           }
//                           //  _handleSignIn(),
//                           ),

//                       SizedBox(width: 25),

//                       // apple button
//                       // SquareTile(
//                       //     imagePath: 'lib/assets/images/apple.png',
//                       //     onclickFuc: () => _handleSignIn())
//                     ],
//                   ),

//                   const SizedBox(height: 50),

//                   // not a member? register now
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Not a member?',
//                         style: TextStyle(color: Colors.grey[700]),
//                       ),
//                       const SizedBox(width: 4),
//                       InkWell(
//                         onTap: () async {
//                           registerDialog();
//                           // signUpUser();
//                           // forgetPassword();
//                           // var a = await firebaseAuth
//                           //     .createUserWithEmailAndPassword(
//                           //         email: 'praveen@gmail.com',
//                           //         password: '654321');
//                           // // print(a.runtimeType);
//                           // print(a);
//                           // print('success');
//                         },
//                         child: const Text(
//                           'Register now',
//                           style: TextStyle(
//                             color: Colors.blue,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

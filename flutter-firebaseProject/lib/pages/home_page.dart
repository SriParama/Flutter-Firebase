import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailfirebase/components/my_button.dart';
import 'package:emailfirebase/components/my_textfield.dart';
import 'package:emailfirebase/pages/educationalDetails.dart';
import 'package:emailfirebase/pages/personaldetails.dart';
import 'package:emailfirebase/pages/Dashboard/review_page.dart';
import 'package:emailfirebase/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../components/customdropdown.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final user = firebaseAuth.currentUser!;
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _mobNoController = TextEditingController();

  final TextEditingController _dobController = TextEditingController();

  //education details
  final TextEditingController _sslcController = TextEditingController();
  final TextEditingController _hscController = TextEditingController();
  final TextEditingController _ugcourseController = TextEditingController();
  final TextEditingController _ugcgpaController = TextEditingController();
  final TextEditingController _techKnowController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  // sign user out method
  void signUserOut() {
    firebaseAuth.signOut();
  }

  List details = [];
  String emailId = '';
  List<dynamic> genterList = ['Male', 'Female', 'Others'];
  String? _selectedItem;
  late TabController _tabController;
  Map<String, dynamic>? userDetails;
  bool complete = false;
  Color backgroundcolor = Colors.blue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _selectedItem = 'Male';
    emailId = firebaseAuth.currentUser!.email.toString();
    // getLoginData(emailId);
    getuserDetails();
    _tabController = TabController(length: 2, vsync: this);
    print(_tabController.index);

    print(emailId);
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getLoginData(String userName) async {
    List<Map<String, dynamic>> userList = [];

    try {
      print('Load 1 ');
      var collectionRef = firestore.collection('Users');
      var collectionSnapshot = await collectionRef.get();

      if (collectionSnapshot.docs.isNotEmpty) {
        print('Document is not Empty');

        var docSnapshot = await collectionRef.doc('$userName').get();
        if (docSnapshot.exists && docSnapshot.data()!.containsKey('details')) {
          print('Data is Not Empty');
          userList =
              List<Map<String, dynamic>>.from(docSnapshot.get('details'));
          print(userList);
        } else {
          print('Setting the messages');
          await collectionRef.doc('$userName').set({
            'details': [
              {'personalDetails': {}},
              {'educationDetails': {}},
            ]
          });
        }
      } else {
        print('else Part');
        await collectionRef.doc('$userName').set({
          'details': [
            {'personalDetails': {}},
            {'educationDetails': {}},
          ]
        });
        userList = [];
      }
    } catch (e) {
      print('Error loading data from Firestore: $e');
    }

    return userList;
  }

  getuserDetails() async {
    await getLoginData(emailId);
    var details = await firestore.collection('Users').doc(emailId).get();
    print("details");
    print(await details.data());

    userDetails = details.data() as Map<String, dynamic>;

    print('userDetails');
    print(userDetails);
    if (userDetails != null) {
      print('userDetial+++++++');
      // print(DateTime.parse());
      print(userDetails);
      print(userDetails!['details'][0]['personalDetails']['Gender']);

      _fnameController.text =
          userDetails!['details'][0]['personalDetails']['First_Name'];
      _lnameController.text =
          userDetails!['details'][0]['personalDetails']['Last_Name'];
      _mobNoController.text =
          userDetails!['details'][0]['personalDetails']['Mob_No'];
      _dobController.text =
          userDetails!['details'][0]['personalDetails']['DOB'];
      _selectedItem = userDetails!['details'][0]['personalDetails']['Gender'];
      _sslcController.text =
          userDetails!['details'][1]['educationDetails']['SSLC_CGPA'];
      _hscController.text =
          userDetails!['details'][1]['educationDetails']['HSC_CGPA'];
      _ugcourseController.text =
          userDetails!['details'][1]['educationDetails']['UG_COURSE'];
      _ugcgpaController.text =
          userDetails!['details'][1]['educationDetails']['UG_CGPA'];
      _techKnowController.text =
          userDetails!['details'][1]['educationDetails']['Technical_Knowledge'];
      _resumeController.text =
          userDetails!['details'][1]['educationDetails']['Resume'];
      setState(() {});
    } else {
      print('userDetails---------');
    }
  }

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = '${picked.day}-${picked.month}-${picked.year}';
      });
    }
  }

  String _filePath = '';

  Future<void> _pickFile() async {
    String? filePath = await FilePicker.platform.pickFiles().then((result) {
      if (result != null) {
        return result.files.single.path!;
      }
      return null;
    });

    setState(() {
      _filePath = filePath ?? '';
      _resumeController.text = _filePath.split('/').last;
    });
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
        'Mob_No': _mobNoController.text,

        'Gender': _selectedItem,
        // 'Gender': _genderController.text,
        'DOB': _dobController.text,
      };
      userDetails!['details'][0]['personalDetails'] = personalDetails;
      print('after add users...');
      print(userDetails);
      // userDetails = userDetails;
      await firestore.collection('Users').doc(emailId).set(userDetails!);
      setState(() {});
      _tabController.animateTo(1);

      // await firestore.collection('Users').doc(emailId).
    }
  }

  String resumeImage = '';

  educationalDetails() async {
    // if (_formKey.currentState!.validate()) {
    print('before adduserDetails');
    print(userDetails);
    // Map<String, dynamic> user = userDetails['details'][0]['personalDetails'];
    // print('before add users...');
    // print(user);
    if (_filePath.isNotEmpty) {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child(emailId);
      String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);
      try {
        await referenceImageToUpload.putFile(File(_filePath));
        resumeImage = await referenceImageToUpload.getDownloadURL();
        print('resumeImage');
        print(resumeImage);
        // addDataToFirestore(
        //     productnameController.text, quantityController.text, imageUrl);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Details Saved Successed...')));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(),
            ));
      } catch (e) {
        print(e.toString());
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('something happened')));
    }
    Map<String, dynamic> educationDetails = {
      'SSLC_CGPA': _sslcController.text,
      'HSC_CGPA': _hscController.text,
      'UG_COURSE': _ugcourseController.text,
      'UG_CGPA': _ugcgpaController.text,
      // 'Gender': _genderController.text,
      'Technical_Knowledge': _techKnowController.text,
      'Resume': resumeImage
    };

    userDetails!['details'][1]['educationDetails'] = educationDetails;
    print('after add users...');
    print(userDetails);
    // userDetails = userDetails;
    await firestore.collection('Users').doc(emailId).set(userDetails!);

    // await firestore.collection('Users').doc(emailId).
    // }
  }

  // Future<List<Map<String, dynamic>>> getProductDetails() async {
  //   List<Map<String, dynamic>> productList = [];

  //   try {
  //     print('Load 1 ');
  //     var collectionRef = firestore.collection('Products');
  //     var collectionSnapshot = await collectionRef.get();

  //     if (collectionSnapshot.docs.isNotEmpty) {
  //       print('Document is not Empty');

  //       var docSnapshot = await collectionRef.doc('Category').get();
  //       if (docSnapshot.exists && docSnapshot.data()!.containsKey('Items')) {
  //         print('Data is Not Empty');
  //         productList =
  //             List<Map<String, dynamic>>.from(docSnapshot.get('Items'));
  //         print(productList);
  //       } else {
  //         print('Setting the messages');
  //         await collectionRef.doc('Category').set({'Items': []});
  //       }
  //     } else {
  //       print('else Part');
  //       await collectionRef.doc('Category').set({'Items': []});
  //       productList = [];
  //     }
  //   } catch (e) {
  //     print('Error loading data from Firestore: $e');
  //   }

  //   return productList;
  // }
  bool fnameEnable = false;
  @override
  Widget build(BuildContext context) {
    print("_selectedItem");
    print(_selectedItem);
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
            backgroundColor: Colors.grey[900],
            actions: [
              IconButton(
                onPressed: signUserOut,
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child:

                  //  IgnorePointer(
                  //   ignoring: true,
                  //   child: TabBar(
                  //     // onTap: (_) {
                  //     //   // return null;
                  //     //   // value = 0;
                  //     // },
                  //     controller: _tabController,
                  //     tabs: [
                  //       Tab(
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             CircleAvatar(
                  //               child: Icon(Icons.person),
                  //             ),
                  //             // Container(
                  //             //   height: 1.0,
                  //             //   width: 100.0,
                  //             //   color: Colors.grey,
                  //             // ),
                  //             // CircleAvatar(
                  //             //   child: Icon(Icons.school_outlined),
                  //             // ),
                  //             // Container(
                  //             //   height: 1.0,
                  //             //   width: 50.0,
                  //             //   color: Colors.grey,
                  //             // ),
                  //           ],
                  //         ),
                  //       ),
                  //       Tab(
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             CircleAvatar(
                  //               child: Icon(Icons.school_outlined),
                  //             ),
                  //             // Container(
                  //             //   height: 1.0,
                  //             //   width: 100.0,
                  //             //   // color: Colors.grey,
                  //             // ),
                  //             // Text('Education',
                  //             //     style: TextStyle(color: Colors.white)),
                  //             // Container(
                  //             //   height: 1.0,
                  //             //   width: 50.0,
                  //             //   color: Colors.grey,
                  //             // ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                  Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {});
                          _tabController.animateTo(0);
                          print(_tabController.index);
                        },
                        child: CircleAvatar(
                          backgroundColor: _tabController.index == 0
                              ? backgroundcolor
                              : Colors.grey,
                          child: Icon(Icons.person),
                        ),
                      ),
                      Container(
                        height: 1.0,
                        width: 100.0,
                        color: Colors.grey,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {});
                          _tabController.animateTo(1);
                          print(_tabController.index);
                        },
                        child: CircleAvatar(
                          backgroundColor: _tabController.index == 1
                              ? backgroundcolor
                              : Colors.grey,
                          child: Icon(Icons.school_outlined),
                        ),
                      ),
                      // Container(
                      //   height: 1.0,
                      //   width: 50.0,
                      //   color: Colors.grey,
                      // ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Personal',
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        height: 1.0,
                        width: 100.0,
                        // color: Colors.grey,
                      ),
                      Text('Education', style: TextStyle(color: Colors.white)),
                      // Container(
                      //   height: 1.0,
                      //   width: 50.0,
                      //   color: Colors.grey,
                      // ),
                    ],
                  ),
                ],
              ),
            )

            //   Column(
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           InkWell(
            //             onTap: () {

            //             },
            //             child: CircleAvatar(
            //               child: Icon(Icons.person),
            //             ),
            //           ),
            //           Container(
            //             height: 1.0,
            //             width: 100.0,
            //             color: Colors.grey,
            //           ),
            //           CircleAvatar(
            //             child: Icon(Icons.school_outlined),
            //           ),
            //           // Container(
            //           //   height: 1.0,
            //           //   width: 50.0,
            //           //   color: Colors.grey,
            //           // ),
            //         ],
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             'Personal',
            //             style: TextStyle(color: Colors.white),
            //           ),
            //           Container(
            //             height: 1.0,
            //             width: 100.0,
            //             // color: Colors.grey,
            //           ),
            //           Text('Education', style: TextStyle(color: Colors.white)),
            //           // Container(
            //           //   height: 1.0,
            //           //   width: 50.0,
            //           //   color: Colors.grey,
            //           // ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            ),
        body: TabBarView(
          // physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            // PesonalDetailsScreen(),
            // EduDetailScreen(),

            Form(
              key: _formKey,
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: Text(
                      'Personal Details',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,

                        // backgroundImage: NetworkImage(resumeImage, scale: 5),
                        foregroundImage: NetworkImage(resumeImage),
                        backgroundColor: Colors.grey,
                        // child: Image.network(
                        //   resumeImage,
                        //   fit: BoxFit.cover,
                        //   width: 100,
                        //   height: 100,
                        // ),
                      ),
                      Positioned(
                          left: 225,
                          top: 40,
                          child: Icon(
                            Icons.add,
                            size: 25,
                            color: Colors.blue,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  MyTextField(
                    sufficsIcons: _fnameController.text.isNotEmpty
                        ? Icon(
                            Icons.edit,
                            size: 18,
                          )
                        : Icon(
                            Icons.person,
                            size: 18,
                          ),
                    // ontab: () {
                    //   fnameEnable = !fnameEnable;
                    //   print("fnameEnable");
                    //   print(fnameEnable);
                    //   setState(() {});
                    // },
                    // keyboard: fnameEnable,
                    controller: _fnameController,
                    hintText: 'First_Name',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  MyTextField(
                    sufficsIcons: _lnameController.text.isNotEmpty
                        ? Icon(
                            Icons.edit,
                            size: 18,
                          )
                        : Icon(
                            Icons.person,
                            size: 18,
                          ),
                    controller: _lnameController,
                    hintText: 'Last_Name',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  MyTextField(
                    sufficsIcons: _mobNoController.text.isNotEmpty
                        ? Icon(
                            Icons.edit,
                            size: 18,
                          )
                        : Icon(
                            Icons.person,
                            size: 18,
                          ),
                    controller: _mobNoController,
                    hintText: 'Mobile_No',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // CustomDropdown(
                  //   items: const ['Male', 'Female', 'Others'],
                  //   selectItem: 'Male',
                  //   hintText: 'Gender',
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Builder(builder: (context) {
                      print("_selectedItem");
                      print(_selectedItem);
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: 'Gender',
                            hintStyle: TextStyle(color: Colors.grey[500])),
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        validator: (value) {
                          if (value == null) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                        // isDense: true,

                        // alignment: Alignment.center,
                        borderRadius: BorderRadius.circular(5.0),
                        // underline: SizedBox(),

                        //  decoration: InputDecoration(
                        //     enabledBorder: const OutlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.white),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.grey.shade400),
                        //     ),
                        //     fillColor: Colors.grey.shade200,
                        //     filled: true,

                        //     hintStyle: TextStyle(color: Colors.grey[500])),

                        isExpanded: true,

                        // style: TextStyle(textBaseline: TextBaseline.alphabetic),
                        value: _selectedItem,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue!;
                          });
                        },

                        items: <String>['Male', 'Female', 'Others']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            // alignment: Alignment.center,
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      );
                    }),
                  ),

                  // MyTextField(
                  //   controller: _genderController,
                  //   hintText: 'Gender',
                  //   obscureText: false,
                  // ),
                  SizedBox(
                    height: 20.0,
                  ),
                  MyTextField(
                    controller: _dobController,
                    hintText: 'DOB',
                    obscureText: false,
                    ontab: () {
                      print('hi');
                      _selectDate(context);
                    },
                    keyboard: true,
                    sufficsIcons: Icon(Icons.calendar_month),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  MyButton(
                    btnColor: appPrimeColor,
                    btnText: 'Continue',
                    onTap: () {
                      // _tabController.animateTo(1);
                      personalDetails();
                    },
                  )
                ],
              ),
            ),
            ListView(
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
                  sufficsIcons: _sslcController.text.isNotEmpty
                      ? Icon(
                          Icons.edit,
                          size: 18,
                        )
                      : Icon(
                          Icons.person,
                          size: 18,
                        ),
                  controller: _sslcController,
                  hintText: 'SSLC CGPA',
                  obscureText: false,
                ),
                SizedBox(
                  height: 20.0,
                ),
                MyTextField(
                  sufficsIcons: _hscController.text.isNotEmpty
                      ? Icon(
                          Icons.edit,
                          size: 18,
                        )
                      : Icon(
                          Icons.person,
                          size: 18,
                        ),
                  controller: _hscController,
                  hintText: 'HSC CGPA',
                  obscureText: false,
                ),
                SizedBox(
                  height: 20.0,
                ),
                MyTextField(
                  sufficsIcons: _ugcourseController.text.isNotEmpty
                      ? Icon(
                          Icons.edit,
                          size: 18,
                        )
                      : Icon(
                          Icons.person,
                          size: 18,
                        ),
                  controller: _ugcourseController,
                  hintText: 'UG Course Name',
                  obscureText: false,
                ),
                SizedBox(
                  height: 20.0,
                ),
                MyTextField(
                  sufficsIcons: _ugcgpaController.text.isNotEmpty
                      ? Icon(
                          Icons.edit,
                          size: 18,
                        )
                      : Icon(
                          Icons.person,
                          size: 18,
                        ),
                  controller: _ugcgpaController,
                  hintText: 'UG CGPA',
                  obscureText: false,
                ),
                SizedBox(
                  height: 20.0,
                ),
                MyTextField(
                  sufficsIcons: _techKnowController.text.isNotEmpty
                      ? Icon(
                          Icons.edit,
                          size: 18,
                        )
                      : Icon(
                          Icons.person,
                          size: 18,
                        ),
                  controller: _techKnowController,
                  hintText: 'Technical Knowledge',
                  obscureText: false,
                ),
                SizedBox(
                  height: 50.0,
                ),
                MyTextField(
                  controller: _resumeController,
                  hintText: 'RESUME',
                  obscureText: false,
                  ontab: () {
                    print('hi222');
                    // _resumeController.text.isEmpty
                    //     ?
                    _pickFile();
                    // : educationalDetails;
                  },
                  keyboard: true,
                  sufficsIcons: _resumeController.text.isNotEmpty
                      ? Icon(
                          Icons.edit,
                          size: 18,
                        )
                      : Icon(
                          Icons.file_upload,
                          size: 18,
                        ),
                  // sufficsIcons:
                  //     //  _resumeController.text.isEmpty
                  //     //     ?
                  //     Icon(Icons.file_upload)
                  // : Icon(Icons.picture_in_picture),
                ),
                SizedBox(
                  height: 50.0,
                ),
                resumeImage.isEmpty
                    ? SizedBox()
                    : Image.network(
                        resumeImage,
                        fit: BoxFit.contain,
                        width: 100,
                        height: 100,
                      ),
                SizedBox(
                  height: 20.0,
                ),
                MyButton(
                  btnColor: appPrimeColor,
                  btnText: 'Continue',
                  onTap: () {
                    educationalDetails();
                    // personalDetails();
                  },
                ),
              ],
            ),
          ],
        )

        // Center(
        //     child: Text(
        //   "LOGGED IN AS: " + user.email!,
        //   style: TextStyle(fontSize: 20),
        // )),
        );
  }
}

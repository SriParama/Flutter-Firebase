import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailfirebase/components/my_button.dart';
import 'package:emailfirebase/components/my_textfield.dart';
import 'package:emailfirebase/components/showSnackbar.dart';
import 'package:emailfirebase/firebaseClass/firebasemethods.dart';
import 'package:emailfirebase/pages/Dashboard/congratesScreen.dart';
import 'package:emailfirebase/pages/Dashboard/review_page.dart';
import 'package:emailfirebase/utils/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EducationalDetailsScreen extends StatefulWidget {
  // GlobleKey _formkey;

  EducationalDetailsScreen({
    super.key,
  });

  @override
  State<EducationalDetailsScreen> createState() =>
      _EducationalDetailsScreenState();
}

class _EducationalDetailsScreenState extends State<EducationalDetailsScreen> {
  static final TextEditingController _sslcController = TextEditingController();
  static final TextEditingController _hscController = TextEditingController();
  static final TextEditingController _ugcourseController =
      TextEditingController();
  static final TextEditingController _ugcgpaController =
      TextEditingController();
  static final TextEditingController _techKnowController =
      TextEditingController();
  static final TextEditingController _resumeController =
      TextEditingController();

  final _formKey1 = GlobalKey<FormState>();
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
    // var details = await firestore.collection('Users').doc(emailId).get();
    // userDetails = details.data() as Map<String, dynamic>;
    await FirebaseMethods().getLoginData(emailId);
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
      print(userDetails['details'][0]['personalDetails']['Gender']);

      _sslcController.text =
          userDetails['details'][1]['educationDetails']['SSLC_CGPA'];
      _hscController.text =
          userDetails['details'][1]['educationDetails']['HSC_CGPA'];
      _ugcourseController.text =
          userDetails['details'][1]['educationDetails']['UG_COURSE'];
      _ugcgpaController.text =
          userDetails['details'][1]['educationDetails']['UG_CGPA'];
      _techKnowController.text =
          userDetails['details'][1]['educationDetails']['Technical_Knowledge'];
      _resumeController.text =
          userDetails['details'][1]['educationDetails']['Resume'];
      isLoaded = true;
      setState(() {});

      setState(() {});
    } else {
      print('userDetails---------');
    }

    print('userDetails');
    print(userDetails);
  }

  String resumeImage = '';
  String _filePath = '';
  bool isLoaded = false;

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
      isLoaded = true;
    });
  }

  educationalDetails() async {
    // if (_formKey.currentState!.validate()) {
    print('before adduserDetails');
    print(userDetails);
    // Map<String, dynamic> user = userDetails['details'][0]['personalDetails'];
    // print('before add users...');
    // print(user);

    if (_formKey1.currentState!.validate()) {
      if (_filePath.isNotEmpty) {
        try {
          Reference referenceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirImages = referenceRoot.child(emailId);
          String uniqueFileName =
              DateTime.now().microsecondsSinceEpoch.toString();
          Reference referenceImageToUpload =
              referenceDirImages.child(uniqueFileName);
          await referenceImageToUpload.putFile(File(_filePath));
          resumeImage = await referenceImageToUpload.getDownloadURL();
        } catch (e) {
          print(e);
        }
      } else {
        resumeImage = _resumeController.text;
      }

      try {
        print('resumeImage');
        print(resumeImage);
        // addDataToFirestore(
        //     productnameController.text, quantityController.text, imageUrl);
        setState(() {});
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

        await firestore.collection('Users').doc(emailId).set(userDetails);
        showSnackbar(context, 'Educational Details Saved Successfully..',
            appPrimeGreenColor);
        pageSwap.gotoCustomPage(2);
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     backgroundColor: Colors.green,
        //     content: Text('Details Saved Successed...')));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ReviewPage(),
        //     ));
      } catch (e) {
        print(e.toString());
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('something happened')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey1,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            height: 10.0,
          ),
          Text(
            'Upload Resume',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          DottedBorderContainer(
            child: Container(
              width: 200,
              height: 80,
              padding: EdgeInsets.all(5),

              // color: buttonColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // CircleAvatar(
                  //   radius: 40,
                  //   backgroundColor: Colors.grey.shade300,
                  // ),
                  // SizedBox(height: 20),
                  // Text(
                  //   'Upload Resume',
                  //   style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black),
                  // ),
                  // _resumeController.text.isNotEmpty
                  //     ? resumeImage.isEmpty
                  //         ? Expanded(
                  //             child: Image.file(
                  //             File(_filePath),
                  //             fit: BoxFit.fill,
                  //           ))
                  //         : Expanded(
                  //             child: Image.network(
                  //             resumeImage,
                  //             fit: BoxFit.fill,
                  //           ))
                  //     : Text(''),
                  _resumeController.text.isEmpty && !isLoaded
                      ? SizedBox.shrink()
                      : _filePath.isEmpty
                          ? Expanded(
                              child: Image.network(
                                _resumeController.text,
                                fit: BoxFit.fill,
                              ),
                            )
                          : Expanded(
                              child: Image.file(
                                File(_filePath),
                                fit: BoxFit.fill,
                              ),
                            ),
                  SizedBox(width: 10),
                  Expanded(
                    child: IconButton(
                        // color: Colors.green,
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(appPrimeGreenColor)),
                        onPressed: () {
                          _pickFile();
                        },
                        // style: ButtonStyle(
                        //     backgroundColor:
                        //         MaterialStatePropertyAll(Colors.green)),
                        icon: Icon(
                          Icons.upload,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
          ),
          // LayoutBuilder(
          //   builder: (context, constraints) {
          //     return Flex(
          //       direction: Axis.horizontal,
          //       mainAxisSize: MainAxisSize.max,
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: List.generate(
          //           12,
          //           (index) => Container(
          //                 height: 2,
          //                 width: 7,
          //                 decoration: BoxDecoration(color: Colors.grey),
          //               )),
          //     );
          //   },
          // ),
          // Container(
          //   child: Column(
          //     children: [
          //       Icon(Icons.person),
          //       MyButton(onTap: () {}, btnColor: buttonColor, btnText: 'Upload')
          //     ],
          //   ),
          // ),
          // MyTextField(
          //   controller: _resumeController,
          //   hintText: 'RESUME',
          //   obscureText: false,
          //   ontab: () {
          //     print('hi222');
          //     // _resumeController.text.isEmpty
          //     //     ?
          //     _pickFile();
          //     // : educationalDetails;
          //   },
          //   keyboard: true,
          //   sufficsIcons: _resumeController.text.isNotEmpty
          //       ? Icon(
          //           Icons.edit,
          //           size: 18,
          //         )
          //       : Icon(
          //           Icons.file_upload,
          //           size: 18,
          //         ),
          //   // sufficsIcons:
          //   //     //  _resumeController.text.isEmpty
          //   //     //     ?
          //   //     Icon(Icons.file_upload)
          //   // : Icon(Icons.picture_in_picture),
          // ),
          // SizedBox(
          //   height: 20.0,
          // ),
          // resumeImage.isEmpty
          //     ? SizedBox()
          //     : Image.network(
          //         resumeImage,
          //         fit: BoxFit.contain,
          //         width: 100,
          //         height: 100,
          //       ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: SizedBox()),
              // SizedBox.shrink(),
              Expanded(
                child: MyButton(
                  btnColor: buttonColor,
                  btnText: 'Save',
                  onTap: () {
                    // _tabController.animateTo(1);
                    educationalDetails();
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}

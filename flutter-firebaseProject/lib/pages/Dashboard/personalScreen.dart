import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailfirebase/components/customdropdown.dart';
import 'package:emailfirebase/components/my_button.dart';
import 'package:emailfirebase/components/my_textfield.dart';
import 'package:emailfirebase/firebaseClass/firebasemethods.dart';
import 'package:emailfirebase/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PesonalDetailsScreen extends StatefulWidget {
  // GlobleKey _formkey;

  PesonalDetailsScreen({
    super.key,
  });

  @override
  State<PesonalDetailsScreen> createState() => _PesonalDetailsScreenState();
}

class _PesonalDetailsScreenState extends State<PesonalDetailsScreen> {
  final TextEditingController _fnameController = TextEditingController();

  final TextEditingController _lnameController = TextEditingController();

  final TextEditingController _mobNoController = TextEditingController();

  final TextEditingController _genderController = TextEditingController();

  final TextEditingController _dobController = TextEditingController();
  String? _selectedItem;

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
  bool isLoaded = true;
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

      _fnameController.text =
          userDetails['details'][0]['personalDetails']['First_Name'];
      _lnameController.text =
          userDetails['details'][0]['personalDetails']['Last_Name'];
      _mobNoController.text =
          userDetails['details'][0]['personalDetails']['Mob_No'];
      _dobController.text = userDetails['details'][0]['personalDetails']['DOB'];
      _selectedItem = userDetails['details'][0]['personalDetails']['Gender'];
      //  == ''
      //     ? 'Male'
      //     : userDetails['details'][0]['personalDetails']['Gender'];

      print("_selectedI=================tem");
      print(_selectedItem);
      isLoaded = false;
      setState(() {});
      print('userDetails---------');
    }

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
        'Mob_No': _mobNoController.text,
        'Gender': _selectedItem,
        'DOB': _dobController.text,
      };
      userDetails['details'][0]['personalDetails'] = personalDetails;
      print('after add users...');
      print(userDetails);
      // userDetails = userDetails;
      await firestore.collection('Users').doc(emailId).update(userDetails);
      pageSwap.gotoCustomPage(1);

      // await firestore.collection('Users').doc(emailId).
    }
  }

  DateTime? _selectedDate;
  List genderItem = ['Male', 'Female', 'Others'];

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

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30.0,
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
                CustomDropdown(
                  items: genderItem,
                  selectItem: _selectedItem!,
                  hintText: 'Gender',
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedItem = newValue!;
                    });
                  },
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Builder(builder: (context) {
                //     print("_selectedItem");
                //     print(_selectedItem);
                //     return DropdownButtonFormField<String>(
                //       decoration: InputDecoration(
                //           enabledBorder: const OutlineInputBorder(
                //             borderSide: BorderSide(color: Colors.white),
                //           ),
                //           focusedBorder: OutlineInputBorder(
                //             borderSide: BorderSide(color: Colors.grey.shade400),
                //           ),
                //           fillColor: Colors.grey.shade200,
                //           filled: true,
                //           hintText: 'Gender',
                //           hintStyle: TextStyle(color: Colors.grey[500])),
                //       autovalidateMode: AutovalidateMode.onUserInteraction,

                //       validator: (value) {
                //         if (value == null) {
                //           return 'Please select an option';
                //         }
                //         return null;
                //       },
                //       // isDense: true,

                //       // alignment: Alignment.center,
                //       borderRadius: BorderRadius.circular(5.0),
                //       // underline: SizedBox(),

                //       //  decoration: InputDecoration(
                //       //     enabledBorder: const OutlineInputBorder(
                //       //       borderSide: BorderSide(color: Colors.white),
                //       //     ),
                //       //     focusedBorder: OutlineInputBorder(
                //       //       borderSide: BorderSide(color: Colors.grey.shade400),
                //       //     ),
                //       //     fillColor: Colors.grey.shade200,
                //       //     filled: true,

                //       //     hintStyle: TextStyle(color: Colors.grey[500])),

                //       isExpanded: true,

                //       // style: TextStyle(textBaseline: TextBaseline.alphabetic),
                //       value: _selectedItem,
                //       onChanged: (String? newValue) {
                //         setState(() {
                //           _selectedItem = newValue!;
                //         });
                //       },

                //       items: <String>['Male', 'Female', 'Others']
                //           .map<DropdownMenuItem<String>>((String value) {
                //         return DropdownMenuItem<String>(
                //           // alignment: Alignment.center,
                //           value: value,
                //           child: Text(value),
                //         );
                //       }).toList(),
                //     );
                //   }),
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
                // SizedBox(
                //   height: 50.0,
                // ),

                // MyTextField(
                //   controller: _genderController,
                //   hintText: 'Gender',
                //   obscureText: false,
                // ),
                SizedBox(
                  height: 100.0,
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
                          personalDetails();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          );

    Form(
      key: _formKey,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30.0,
          ),
          Center(
            child: Text(
              'Personal Details',
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
            controller: _mobNoController,
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
            btnText: 'Save',
            onTap: () {
              personalDetails();
            },
          )
        ],
      ),
    );
  }
}

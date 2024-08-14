import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailfirebase/components/my_button.dart';
import 'package:emailfirebase/pages/Dashboard/congratesScreen.dart';
import 'package:emailfirebase/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({
    super.key,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String emailId = '';
  @override
  void initState() {
    emailId = firebaseAuth.currentUser!.email.toString();
    getData();
    super.initState();
  }

  Map personalDetails = {};
  Map educationalDetails = {};
  bool isLoaded = true;
  getData() async {
    var details = await firestore.collection('Users').doc(emailId).get();
    print("details");
    print(details.data());
    personalDetails = details.data()!['details'][0]['personalDetails'];
    educationalDetails = details.data()!['details'][1]['educationDetails'];
    setState(() {
      isLoaded = false;
    });
    print(personalDetails);
    print(educationalDetails);
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Personal Details',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        pageSwap.currentPage = 0;
                        setState(() {});
                        print("pageSwap.currentPage");
                        print(pageSwap.currentPage);
                        pageSwap.gotoCustomPage(pageSwap.currentPage);
                      },
                      child: Icon(Icons.edit),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),

                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: ListView.builder(
                      itemCount: personalDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        String key = personalDetails.keys.elementAt(index);
                        dynamic value = personalDetails[key];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                key,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                              Text(
                                value.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }),
                )),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Education Details',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        pageSwap.currentPage = 1;
                        setState(() {});
                        print("pageSwap.currentPage");
                        print(pageSwap.currentPage);
                        pageSwap.gotoCustomPage(pageSwap.currentPage);
                      },
                      child: Icon(Icons.edit),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: ListView.builder(
                      itemCount: educationalDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        String key = educationalDetails.keys.elementAt(index);
                        dynamic value = educationalDetails[key];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                key,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              key == "Resume"
                                  ? Expanded(
                                      child: Text(
                                        value,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Text(
                                      value,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ],
                          ),
                        );
                      }),
                )),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: SizedBox()),
                    // SizedBox.shrink(),
                    Expanded(
                      child: MyButton(
                        btnColor: buttonColor,
                        btnText: 'Done',
                        onTap: () {
                          // _tabController.animateTo(1);
                          // educationalDetails();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CongratesScreen(),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 20,
                // )

                // Container(
                //   padding: EdgeInsets.all(2),
                //   color: Colors.grey,
                //   child: Image.network(
                //     educationalDetails['Resume'],
                //     fit: BoxFit.cover,
                //     width: 100,
                //     height: 100,
                //   ),
                // ),

                // ElevatedButton(onPressed: () {}, child: Text('Logout')),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Text('First Name:',
                //         style: TextStyle(
                //           fontSize: 16,
                //         )),
                //     SizedBox(
                //       width: 50,
                //     ),
                //     Text(
                //       personalDetails['First_Name'],
                //       style: TextStyle(
                //           fontSize: 16, fontWeight: FontWeight.bold),
                //     )
                //   ],
                // )
              ],
            ),
          );
  }
}

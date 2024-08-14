import 'package:emailfirebase/utils/colors.dart';

class FirebaseMethods {
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
              {
                'personalDetails': {
                  "First_Name": "",
                  "Last_Name": "",
                  "DOB": "",
                  "Gender": "",
                  "Mob_No": ""
                }
              },
              {
                'educationDetails': {
                  "HSC_CGPA": "",
                  "UG_CGPA": "",
                  "SSLC_CGPA": "",
                  "UG_COURSE": "",
                  "Resume": "",
                  "Technical_Knowledge": ""
                }
              },
            ]
          });
        }
      } else {
        print('else Part');
        await collectionRef.doc('$userName').set({
          'details': [
            {
              'personalDetails': {
                "First_Name": "",
                "Last_Name": "",
                "DOB": "",
                "Gender": "",
                "Mob_No": ""
              }
            },
            {
              'educationDetails': {
                "HSC_CGPA": "",
                "UG_CGPA": "",
                "SSLC_CGPA": "",
                "UG_COURSE": "",
                "Resume": "",
                "Technical_Knowledge": ""
              }
            },
          ]
        });
        userList = [];
      }
    } catch (e) {
      print('Error loading data from Firestore: $e');
    }

    return userList;
  }
}

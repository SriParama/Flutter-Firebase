import 'dart:io';

import 'package:emailfirebase/firebaseClass/changeNotifier.dart';
import 'package:emailfirebase/pages/Auth_pages/loginScreen.dart';
import 'package:emailfirebase/pages/Dashboard/educationScreen.dart';
import 'package:emailfirebase/pages/Dashboard/personalScreen.dart';
import 'package:emailfirebase/pages/Dashboard/review_page.dart';
import 'package:emailfirebase/utils/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    print('Initstate++++++++++++++++++++++++++++');
    pageSwap.addListener(_update);
    super.initState();
  }

  Future<void> requestPermissions() async {
    await Permission.storage.request();
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Hello World'),
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    final file = File('${directory.path}/example.pdf');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF Saved: ${file.path}')),
    );
  }

  @override
  void dispose() {
    print('33333333#############################################Dispose');
    pageSwap.removeListener(_update);
    // pageSwap.dispose();
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  logout() async {
    try {
      await firebaseAuth.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false);
    } catch (e) {
      print(e);
    }
  }

  Color stepColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => logout(),
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.90,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ElevatedButton(
                //     onPressed: () {
                //       generatePdf();
                //     },
                //     child: Text('PDF')),

                Text(
                  pageSwap.currentPage == 0
                      ? 'Personal Details'
                      : pageSwap.currentPage == 1
                          ? 'Education Details'
                          : pageSwap.currentPage == 2
                              ? 'Review'
                              : '',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            pageSwap.currentPage = 0;

                            print("pageSwap.currentPage");
                            print(pageSwap.currentPage);
                            pageSwap.gotoCustomPage(0);
                            setState(() {});
                          },
                          child: CircleAvatar(
                            backgroundColor: pageSwap.currentPage == 0
                                ? buttonColor
                                : Color.fromARGB(255, 228, 223, 223),
                            child: const Icon(Icons.person),
                          ),
                        ),
                        const Text(
                          'Personal',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Container(
                      height: 1.0,
                      width: 80.0,
                      color: Colors.black,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            pageSwap.currentPage = 1;
                            setState(() {});
                            print("pageSwap.currentPage");
                            print(pageSwap.currentPage);
                            pageSwap.gotoCustomPage(pageSwap.currentPage);
                            // pageSwap.gotoNextPage();
                          },
                          child: CircleAvatar(
                            backgroundColor: pageSwap.currentPage == 1
                                ? buttonColor
                                : Color.fromARGB(255, 228, 223, 223),
                            child: Icon(Icons.school_outlined),
                          ),
                        ),
                        Text(
                          'Education',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Container(
                      height: 1.0,
                      width: 80.0,
                      color: Colors.black,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            pageSwap.currentPage = 2;
                            setState(() {});
                            print("pageSwap.currentPage");
                            print(pageSwap.currentPage);
                            pageSwap.gotoCustomPage(pageSwap.currentPage);
                          },
                          child: CircleAvatar(
                            backgroundColor: pageSwap.currentPage == 2
                                ? buttonColor
                                : Color.fromARGB(255, 228, 223, 223),
                            child: Icon(Icons.done),
                          ),
                        ),
                        Text(
                          'Review',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipPath(
                    clipper: ContainerClip(),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: appPrimeColor,
                        ),
                        child: PageView.builder(
                          controller: pageSwap.controller,
                          onPageChanged: (value) {
                            pageSwap.currentPage = value;
                            setState(() {});
                          },
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: pageList.length,
                          itemBuilder: (context, index) {
                            pageSwap.currentPage = index;

                            return pageList[index];
                          },
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> pageList = [
    PesonalDetailsScreen(),
    EducationalDetailsScreen(),
    ReviewPage()
  ];
}

class ContainerClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double height = size.height;
    double width = size.width;

    path.lineTo(0, height - 50);
    path.lineTo(width / 2.5, height - 50);

    path.quadraticBezierTo(width / 2, height - 50, width / 2, height - 17);
    path.quadraticBezierTo(width / 2, height + 16, width, height);
    // path.lineTo(width, height);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

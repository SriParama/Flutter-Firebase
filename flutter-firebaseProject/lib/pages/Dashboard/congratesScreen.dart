import 'dart:io';
import 'dart:typed_data';

import 'package:emailfirebase/components/showSnackbar.dart';
import 'package:emailfirebase/firebase_config.dart';
import 'package:emailfirebase/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

class CongratesScreen extends StatefulWidget {
  const CongratesScreen({super.key});

  @override
  State<CongratesScreen> createState() => _CongratesScreenState();
}

class _CongratesScreenState extends State<CongratesScreen> {
  downloadFile(title, fileName, context) async {
    try {
      List l = fileName.toString().split(".");
      Directory? dir;
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      } else if (Platform.isAndroid) {
        dir = await getDownloadsDirectory();
        Directory path = Directory("/storage/emulated/0/Download");

        !path.existsSync() ? await path.create(recursive: true) : null;
        dir = path;
        print(dir);
      }
      File file = File("${dir!.path}/$title.${l[l.length - 1]}");

      if (file.existsSync()) {
        for (int i = 1; true; i++) {
          File file1 = File("${dir.path}/$title($i).${l[l.length - 1]}");
          if (!file1.existsSync()) {
            file = file1;
            break;
          }
        }
      }
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
      await file.writeAsBytes(await pdf.save());

// _scheduleNotification();
      PermissionStatus status = await Permission.notification.request();
      if (status.isGranted || Platform.isIOS) {
        // await setupFlutterNotifications();
        // await getNotification(
        //     title: '${file.path}',
        //     body: '${fileName}',
        //     messageId: DateTime.now.toString());
        // ShowPushNotification.showNotification(file.path);
        showSnackbar(context, "downloaded sucessfully path", Colors.green);
      } else {
        showSnackbar(context, "downloaded sucessfully", Colors.green);
      }
    } catch (e) {
      showSnackbar(context, "some thing went wrong", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
                height: 100,
                width: 100,
                child: Lottie.asset('lib/assets/images/congrats.json')),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'CONGRATULATIONS',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 50,
            width: 180,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(buttonColor)),
                onPressed: () {
                  downloadFile('Details', 'pdf', context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Download PDF',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.download,
                      color: Colors.white,
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}

// class CongratesScreen extends StatelessWidget {
//   const CongratesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: DottedBorderContainer(
//             child: Container(
//               width: 200,
//               height: 250,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.grey.shade300,
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Upload Resume',
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {},
//                     style:
//                         ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                     child: Text(
//                       'Upload Resume',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class DottedBorderContainer extends StatelessWidget {
  final Widget child;

  const DottedBorderContainer({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(),
      child: child,
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final double dashWidth = 4;
    final double dashSpace = 3;
    double startX = 0;
    double startY = 0;

    // Draw top border
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }

    startX = 0;
    startY = size.height;

    // Draw bottom border
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height),
          Offset(startX + dashWidth, size.height), paint);
      startX += dashWidth + dashSpace;
    }

    startX = 0;
    startY = 0;

    // Draw left border
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }

    startY = 0;

    // Draw right border
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width, startY),
          Offset(size.width, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// //---------------------------------------------------------------------------------------------

// // class CongratesScreen extends StatelessWidget {
// //   const CongratesScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         body: Center(
// //           child: DottedBorderContainer(
// //             child: Container(
// //               width: 100,
// //               height: 100,
// //               color: Colors.white,
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   // CircleAvatar(
// //                   //   radius: 40,
// //                   //   backgroundColor: Colors.grey.shade300,
// //                   // ),
// //                   // SizedBox(height: 20),
// //                   Text(
// //                     'Upload Resume',
// //                     style: TextStyle(
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.black),
// //                   ),
// //                   // SizedBox(height: 20),
// //                   // ElevatedButton(
// //                   //   onPressed: () {},
// //                   //   style:
// //                   //       ElevatedButton.styleFrom(backgroundColor: Colors.green),
// //                   //   child: Text('Upload Resume'),
// //                   // ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class DottedBorderContainer extends StatelessWidget {
// //   final Widget child;

// //   const DottedBorderContainer({Key? key, required this.child})
// //       : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         Container(
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //           ),
// //           child: child,
// //         ),
// //         Positioned.fill(
// //           child: DottedBorder(),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class DottedBorder extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         // Top border
// //         Row(
// //           children: List.generate(100, (index) {
// //             return Container(
// //               width: 4,
// //               height: 1,
// //               margin: EdgeInsets.only(right: 3),
// //               color: Colors.grey.shade400,
// //             );
// //           }),
// //         ),
// //         // Bottom border
// //         Align(
// //           alignment: Alignment.bottomLeft,
// //           child: Row(
// //             children: List.generate(100, (index) {
// //               return Container(
// //                 width: 4,
// //                 height: 1,
// //                 margin: EdgeInsets.only(right: 3),
// //                 color: Colors.grey.shade400,
// //               );
// //             }),
// //           ),
// //         ),
// //         // Left border
// //         Column(
// //           children: List.generate(100, (index) {
// //             return Container(
// //               width: 1,
// //               height: 4,
// //               margin: EdgeInsets.only(bottom: 3),
// //               color: Colors.grey.shade400,
// //             );
// //           }),
// //         ),
// //         // Right border
// //         Align(
// //           alignment: Alignment.topRight,
// //           child: Column(
// //             children: List.generate(100, (index) {
// //               return Container(
// //                 width: 1,
// //                 height: 4,
// //                 margin: EdgeInsets.only(bottom: 3),
// //                 color: Colors.grey.shade400,
// //               );
// //             }),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

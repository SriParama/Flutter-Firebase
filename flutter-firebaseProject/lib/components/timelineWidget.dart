import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;

  TimelineItem(
      {required this.title, required this.description, required this.time});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: Colors.green,
          ),
          endChild: Container(
            constraints: const BoxConstraints(
              minHeight: 120,
            ),
            color: Colors.lightGreenAccent,
            child: Center(
              child: Text('Event 1'),
            ),
          ),
        ),
        TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isFirst: false,
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: Colors.blue,
          ),
          endChild: Container(
            constraints: const BoxConstraints(
              minHeight: 120,
            ),
            color: Colors.lightBlueAccent,
            child: Center(
              child: Text('Event 2'),
            ),
          ),
        ),
        TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isLast: true,
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: Colors.orange,
          ),
          endChild: Container(
            constraints: const BoxConstraints(
              minHeight: 120,
            ),
            color: Colors.orangeAccent,
            child: Center(
              child: Text('Event 3'),
            ),
          ),
        ),
      ],
    );

    // Row(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: <Widget>[
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         CircleAvatar(
    //           backgroundColor: Colors.blue,
    //           radius: 10.0,
    //         ),
    //         Text(
    //           time,
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //         // SizedBox(height: 8.0),
    //         // Text(
    //         //   title,
    //         //   style: TextStyle(
    //         //     fontWeight: FontWeight.bold,
    //         //     fontSize: 18.0,
    //         //   ),
    //         // ),
    //         // SizedBox(height: 8.0),
    //         // Text(
    //         //   description,
    //         //   style: TextStyle(
    //         //     color: Colors.grey,
    //         //   ),
    //         // ),
    //       ],
    //     ),

    //     // Container(
    //     //   // margin: EdgeInsets.only(right: 20.0),
    //     //   width: 50.0,
    //     //   child: Column(
    //     //     children: <Widget>[
    //     //       CircleAvatar(
    //     //         backgroundColor: Colors.blue,
    //     //         radius: 10.0,
    //     //       ),
    //     //       Column(
    //     //         crossAxisAlignment: CrossAxisAlignment.start,
    //     //         children: <Widget>[
    //     //           Text(
    //     //             time,
    //     //             style: TextStyle(
    //     //               fontWeight: FontWeight.bold,
    //     //             ),
    //     //           ),
    //     //           SizedBox(height: 8.0),
    //     //           Text(
    //     //             title,
    //     //             style: TextStyle(
    //     //               fontWeight: FontWeight.bold,
    //     //               fontSize: 18.0,
    //     //             ),
    //     //           ),
    //     //           SizedBox(height: 8.0),
    //     //           Text(
    //     //             description,
    //     //             style: TextStyle(
    //     //               color: Colors.grey,
    //     //             ),
    //     //           ),
    //     //         ],
    //     //       ),
    //     //       // Container(
    //     //       //   height: 1.0,
    //     //       //   width: 80.0,
    //     //       //   color: Colors.grey,
    //     //       // ),
    //     //     ],
    //     //   ),
    //     // ),
    //     Container(
    //       height: 1.0,
    //       width: 50.0,
    //       color: Colors.grey,
    //     ),
    //     // Expanded(
    //     //   child: Column(
    //     //     crossAxisAlignment: CrossAxisAlignment.start,
    //     //     children: <Widget>[
    //     //       Text(
    //     //         time,
    //     //         style: TextStyle(
    //     //           fontWeight: FontWeight.bold,
    //     //         ),
    //     //       ),
    //     //       SizedBox(height: 8.0),
    //     //       Text(
    //     //         title,
    //     //         style: TextStyle(
    //     //           fontWeight: FontWeight.bold,
    //     //           fontSize: 18.0,
    //     //         ),
    //     //       ),
    //     //       SizedBox(height: 8.0),
    //     //       Text(
    //     //         description,
    //     //         style: TextStyle(
    //     //           color: Colors.grey,
    //     //         ),
    //     //       ),
    //     //     ],
    //     //   ),
    //     // ),
    //   ],
    // );
  }
}

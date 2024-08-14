import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailfirebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:rxdart/rxdart.dart';
import 'package:open_filex/open_filex.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  print('Background Handler');
  await getNotification(
      title: message.notification!.title!,
      body: message.notification!.body!,
      messageId: message.sentTime.toString());
  print('Handling a background message ${message.messageId}');
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);
bool isFlutterLocalNotificationsInitialized = false;
Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

List msg = [];

final FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<String> getNotification(
    {required String title, required String body, required String messageId
    // required bool deviceIsActive,
    }) async {
  // getMessageFromFireBase();
  print('getNotification');
  print('before..............');
  print(msg);

  msg = await load();

  print('*****after*********');
  print(msg);
  List msgId = [];
  for (var message in msg) {
    msgId.add(message['id']);
  }
  print('Message Id');
  print(msgId);
  if (!msgId.contains(messageId)) {
    msg.add({"title": title, 'body': body, 'id': messageId});
  }

  //  bool ismsgId =  msg.;

  print('After Adding notification');
  print(msg);
  String res = 'Some Error Occured';
  try {
    await firestore
        .collection('global_Messages')
        .doc('Notifications')
        .update({"message": msg});
    res = 'success';
    print('After Adding from notification');
    print(msg);
    print('res : $res');
  } catch (e) {
    res = e.toString();
  }
  return res;
}

Future<List<Map<String, dynamic>>> load() async {
  List<Map<String, dynamic>> msg = [];

  try {
    print('Load 1 ');
    var collectionRef = firestore.collection('global_Messages');
    var collectionSnapshot = await collectionRef.get();

    if (collectionSnapshot.docs.isNotEmpty) {
      print('Document is not Empty');

      var docSnapshot = await collectionRef.doc('Notifications').get();
      if (docSnapshot.exists && docSnapshot.data()!.containsKey('message')) {
        print('Data is Not Empty');
        msg = List<Map<String, dynamic>>.from(docSnapshot.get('message'));
        print(msg);
      } else {
        print('Setting the messages');
        await collectionRef.doc('Notifications').set({'message': []});
      }
    } else {
      print('else Part');
      await collectionRef.doc('Notifications').set({'message': []});
      msg = [];
    }
  } catch (e) {
    print('Error loading data from Firestore: $e');
  }

  return msg;
}

Future<void> handleMessage(RemoteMessage message) async {
  final notification = message.notification;
  print('Key **************');
  print(message.data);
  // print(notification!.titleLocArgs);
  // print(notification!.titleLocKey);
  // print(notification!.bodyLocKey);
  // print(notification!.bodyLocArgs);
  print(message.messageId);

  String res = notification!.title!;
  String resbody = notification.body!;
  print(res);
  print(resbody);
  print("********Handle************");
  print(msg);
  await getNotification(
      title: notification.title!,
      body: message.notification!.body!,
      messageId: message.sentTime.toString());
  flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        icon: '@mipmap/ic_launcher',
      ),
    ),
  );
}

// class ShowPushNotification {
//   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   static final onCLickNotification = BehaviorSubject<String>();
//   static Future init() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/launcher_icon');
//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: (id, title, body, payload) => null,
//     );
//     final LinuxInitializationSettings initializationSettingsLinux =
//         LinuxInitializationSettings(defaultActionName: 'Open notification');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsDarwin,
//             linux: initializationSettingsLinux);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (details) {
//       BehaviorSubject<String>()
//         ..add(details.payload!)
//         ..stream.listen((value) async {
//           OpenFilex.open(value);
// // final status = await Permission.manageExternalStorage.request();
// // if (status.isGranted) {
// // // var result = await OpenFile.open(value);
// // OpenFilex.open(value);
// // }
//         });
//     });
//   }

//   static Future showNotification(message) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('your channel id', 'your channel name',
//             channelDescription: 'your channel description',
//             importance: Importance.max,
//             priority: Priority.high,
//             icon: '@mipmap/launcher_icon',
//             ticker: 'ticker');
//     const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: DarwinNotificationDetails());

//     if (message is String) {
//       List filedir = message.split("/");
//       await flutterLocalNotificationsPlugin.show(0, "downloaded sucessfully",
//           filedir[filedir.length - 1], notificationDetails,
//           payload: message);
//     } else {
//       message as RemoteMessage;
//       var notification = message!.notification;
//       await flutterLocalNotificationsPlugin.show(notification.hashCode,
//           notification!.title, notification.body, notificationDetails);
//     }
//   }
// }

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //  same way to create notification
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1, // use random generated id , becoz if you create 2 notification with same id 2nd will override 1st one
      channelKey: "basic_channel",
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
    ),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AwesomeNotifications().initialize(
      null, // this is in drawable of your android section, null will use app icon bydefault, if you want to use any other icon
      //  add inn it drawble and give it;s url here like 'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          //android required channel to show notification  , you need at least one channel , channel is basically preconfiguration for your notification like icon, color, sound

          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ]);
  //  to register function for background handle
  //  for background _firebaseMessagingBackgroundHandler function will get called
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

/*
Hey Everyone let's see how to integration firebase messaging - FCM in flutter
so in my last 2 video 
i have already shown you how to integrate firebase and how to create notification using awesome notifications plugin

link of those two video are in description

so we will only see firebase messaging integration
let's start
we will need fcm token to send message

okay we token and also we handle open app case  let's first test this 
getting error 
let's me update firebase core plugin version
yup error in in plugin 
so we got token
let's go to console get test

okay so it's working
but it's only for when app is in foreground
let's see how to habdle background
i;ll restart again 
okay so background is also done
now one of the imp thing is tap/click action 
for that you can refer my last video for notification
it's same 
video is getiing long
so that's all thanks for watching

*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Local Notification'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  getToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    print(token);
    // here i will use firebase console to send message , in actual case you may use backend  , for that send this token to backend and store it
    //  token will be active as long as your app is installed , with few exception
    //  like when use clear app data , so at that time new token will be generated
    //  if time token is generate when you open app
  }

  @override
  void initState() {
    //  this listen will listen all messagin comming from firebase when app is in foreground means app is open

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // message - >  this will contains all data i.e title , body , image , or key-pair value custom field you send from firebase

      //  let's use awesome notification to show notification
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1, // use random generated id , becoz if you create 2 notification with same id 2nd will override 1st one
          channelKey: "basic_channel",
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

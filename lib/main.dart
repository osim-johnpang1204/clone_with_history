import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_fcmMessageHandler);

  runApp(const MyApp());
}

Future<void> _fcmMessageHandler(RemoteMessage message) async {
  print('[John] FCM background:  ${message.notification!.body}');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final XgFlutterPlugin tpush = XgFlutterPlugin();
  late FirebaseMessaging messaging;

  String? token;

  @override
  void initState() {
    super.initState();
    initTecentPlatformState();
    initFirebase();
  }

  Future<void> initFirebase() async {
    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) {
      setState(() {
        token = value;
        textEditingController.text = token!;
      });

      print('[John] FCM token $value');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("[John] FCM message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('[John] FCM Message clicked!');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('[John] FCM Opened App!');
    });
  }

  Future<void> initTecentPlatformState() async {
    /// 开启DEBUG
    tpush.setEnableDebug(true);

    /// 添加回调事件
    tpush.addEventHandler(
      onRegisteredDeviceToken: (String msg) async {
        print("flutter onRegisteredDeviceToken: $msg");
      },
      onRegisteredDone: (String msg) async {
        print("flutter onRegisteredDone: $msg");
      },
      unRegistered: (String msg) async {
        print("flutter unRegistered: $msg");
      },
      onReceiveNotificationResponse: (Map<String, dynamic> msg) async {
        print("flutter onReceiveNotificationResponse $msg");
      },
      onReceiveMessage: (Map<String, dynamic> msg) async {
        print("flutter onReceiveMessage $msg");
      },
      xgPushDidSetBadge: (String msg) async {
        print("flutter xgPushDidSetBadge: $msg");

        /// 在此可设置应用角标
        /// tpush.setAppBadge(0);
      },
      xgPushDidBindWithIdentifier: (String msg) async {
        print("flutter xgPushDidBindWithIdentifier: $msg");
      },
      xgPushDidUnbindWithIdentifier: (String msg) async {
        print("flutter xgPushDidUnbindWithIdentifier: $msg");
      },
      xgPushDidUpdatedBindedIdentifier: (String msg) async {
        print("flutter xgPushDidUpdatedBindedIdentifier: $msg");
      },
      xgPushDidClearAllIdentifiers: (String msg) async {
        print("flutter xgPushDidClearAllIdentifiers: $msg");
      },
      xgPushClickAction: (Map<String, dynamic> msg) async {
        print("flutter xgPushClickAction $msg");
      },
    );

    tpush.configureClusterDomainName("tpns.sgp.tencent.com");
    tpush.startXg("1520011026", "APMPAT8PELL9");
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$token',
              ),
            ),
            TextField(
              controller: textEditingController,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

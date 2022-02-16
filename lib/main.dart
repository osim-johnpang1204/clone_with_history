// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_fcmMessageHandler);

  runApp(const MyApp());
}
//
// Future<void> _fcmMessageHandler(RemoteMessage message) async {
//   print('[John] FCM background:  ${message.notification!.body}');
// }

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
  // late FirebaseMessaging messaging;

  String? token;
  String? tecentToken;

  @override
  void initState() {
    super.initState();
    // initFirebase();
    initTecentPlatformState();
  }

  Future<void> initFirebase() async {
    // messaging = FirebaseMessaging.instance;

    // messaging.getToken().then((value) {
    //   setState(() {
    //     token = value;
    //     textEditingController.text = token!;
    //   });
    //
    //   print('[John] FCM token $value');
    // });

    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   print("[John] FCM message recieved");
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('[John] FCM Message clicked!');
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   print('[John] FCM Opened App!');
    // });
  }

  final XgFlutterPlugin tpush = XgFlutterPlugin();

  Future<void> initTecentPlatformState() async {
    /// 开启DEBUG
    tpush.setEnableDebug(true);
    tpush.configureClusterDomainName("tpns.sgp.tencent.com");
    tpush.startXg("1520011026", "APMPAT8PELL9");
    XgFlutterPlugin.xgApi.enableOtherPush();
    XgFlutterPlugin.xgApi.regPush();
  }

  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();

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
                'FCM: $token',
              ),
            ),
            // TextField(
            //   controller: textEditingController,
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tecent FCM:',
              ),
            ),
            TextField(
              controller: textEditingController2,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          tecentToken = await XgFlutterPlugin.xgApi.getXgToken();
          textEditingController2.text = tecentToken ?? '';
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'package:lab3/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';




class FirebaseApi {
  // create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    //request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch FirebaseCloudMessaging token from this device
    final fCMToken = await _firebaseMessaging.getToken();
    // print the token (normally we would send this to the server)
    print("Token: $fCMToken");

   initPushNotifications();
  }

  // function to handle received messages
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState
        ?.pushNamed('/notification_screen',
        arguments: message);
  }

  // function to initialize background settings
  Future initPushNotifications() async {
    // handle notifications if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
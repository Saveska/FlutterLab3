import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lab3/api/firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab3/views/exam_terms_view.dart';
import 'package:lab3/views/login_view.dart';
import 'package:lab3/views/register_view.dart';
import 'package:lab3/views/verify_email_view.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
      navigatorKey: navigatorKey,
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/exam_terms' : (context) => const ExamTermsView(),
      },
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot){
        switch(snapshot.connectionState) {
          case ConnectionState.done:
           final user = FirebaseAuth.instance.currentUser;
           if(user!=null){
             if(user.emailVerified){
               return const ExamTermsView();
             }else{
               return const VerifyEmailView();
             }
           }else {
             return const LoginView();
           }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}



 

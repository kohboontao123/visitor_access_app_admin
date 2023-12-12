  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
  import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visitor_access_app_admin/class/class.dart';
import 'package:visitor_access_app_admin/reusable_widget/auth.dart';

  import 'screen/home_screen.dart';
  import 'screen/login_screen.dart';


  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    /*WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp( options: const FirebaseOptions(
      apiKey: "AAAA8eTjZ2c:APA91bEW1bmGlZIP59wnFfyVAUCfAb1e-6677HEo7WvVCTMUGrYOgeN18bSyWpiKiSvhsvSnGRNJ7OwNREGUbXK12dPACGrsJ-pihDzV3WHeSmK1r-ANafx0aCiKpLGjYLaazUPZfr3P", // Your apiKey
      appId: "1:1038927226727:android:227c7e95bd5301f59771c2", // Your appId
      messagingSenderId: "1038927226727", // Your messagingSenderId
      projectId: "fypproject-42f8d", // Your projectId
    ));*/
    runApp(const MyApp());
  }

  class MyApp extends StatefulWidget {
    const MyApp({super.key});

    @override
    State<MyApp> createState() => _MyAppState();
  }
  class _MyAppState extends State<MyApp>{
    @override
    void initState(){
      super.initState();
      checkLogin();
    }
    Widget currentPage =LoginScreen();
    AuthClass authclass=AuthClass();
    void checkLogin() async{

      String? token=await authclass.getToken();
      print(token);
      if (token!=null){
        Fluttertoast.showToast(msg:'logging...');
        FirebaseFirestore.instance
            .collection('admin').doc(token).get()
            .then((DocumentSnapshot documentSnapshot) =>{
          AdminClass.uid=documentSnapshot['uid'],
          AdminClass.name=documentSnapshot['name'],
          AdminClass.email=documentSnapshot['email'],
          setState((){
            currentPage=HomeScreen();
          }),


        }).catchError((error) =>
        {
          Fluttertoast.showToast(msg: error.toString()),
        });

      }
    }
  // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home:  currentPage,
              //HomeScreen(),
      );
    }
  }



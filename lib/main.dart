import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_clone/screens/accounts_screen.dart';
import 'package:youtube_clone/screens/get_data_from_db.dart';
import 'package:youtube_clone/screens/homescreen.dart';
import 'package:youtube_clone/screens/search_result_screen.dart';
import 'package:youtube_clone/screens/search_screen.dart';
import 'package:youtube_clone/screens/video_search_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YouTube',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: VideoListScreen(sID: 'UCOhHO2ICt0ti9KAh-QHvttQ',),
      routes: {
        '/mainscreen' : (contex) => VideoListScreen(sID: 'UCOhHO2ICt0ti9KAh-QHvttQ',),
        '/searchresult':(context) => SearchResultScreen(sID: '',cName: '',),
        '/dbscreen' : (context) => GetDataFromDB(),
        '/searchscreen' : (context) => SearchScreen(),
        '/accountscreen' : (context) => AccountsScreen(),
        '/searchvideo' : (context) => VideoSearchScreen(vID: '')
      },
    );
  }
}

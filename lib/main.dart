import 'package:bucketlist/screens/add_screen.dart';
import 'package:bucketlist/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {


    
    return MaterialApp( //về bản chất routes là 1 cái map với cặp key value, với value sẽ nhận 1 callbackfunction context và return về 1 cái trang nào đó
      // routes: { //declare root routes first
      //   "/home":(context){
      //     return MainScreen();
      //   },
      //   "/add":(context) {
      //     return AddBucketListScreen();
      //   }
      // },
      // initialRoute: "/home",
      home:  MainScreen(),
      theme: ThemeData.light(useMaterial3: true),
      
    );
  }
}

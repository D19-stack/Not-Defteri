import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_not_defteri/anaekran.dart';
import 'package:flutter_not_defteri/hesapolustur.dart';
import 'package:flutter_not_defteri/loginislemleri.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
bool karami=false;
SharedPreferences? pref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  pref = await SharedPreferences.getInstance();
if(pref!.getBool("remember")==true){
  await firestore
      .collection("users")
      .doc(pref!.getString("mail"))
      .get()
      .then((value) {
    debugPrint(value.data()!["notlar"].toString());
    for (Map map in value.data()!["notlar"]) {
      debugPrint(map.toString());
      list.add(map);
      debugPrint("fordan sonra liste : ${list.toString()}");
    }
  });
  
}else{
  pref!.setBool("dark", true);
}
runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    karami=pref!.getBool("dark")!;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: karami==true?ThemeMode.dark:ThemeMode.light,
      darkTheme: ThemeData.dark(),
      title: 'Material App',
      home: pref!.getBool("remember") == true
          ? AnaEkran()
          : const LoginIslemleri(),
    );
  }
}

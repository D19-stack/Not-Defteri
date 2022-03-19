import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_not_defteri/hesapolustur.dart';
import 'package:flutter_not_defteri/loginislemleri.dart';
import 'package:flutter_not_defteri/main.dart';
import 'package:flutter_not_defteri/notsyf.dart';

class AnaEkran extends StatefulWidget {
  AnaEkran({Key? key}) : super(key: key);

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

List list = [];

class _AnaEkranState extends State<AnaEkran> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("Karanlık Tema"),
              trailing: Switch(
                value: karami,
                onChanged: (a) {
                  setState(() {
                    karami = a;
                    pref!.setBool("dark", karami);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => MyApp()));
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Çıkış Yap"),
              onTap: () {
                auth.signOut();
                pref!.setBool("remember", false);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginIslemleri()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NotSyf(
                  baslik: "",
                  tarih: "",
                  not: "",
                  renk: Colors.yellowAccent,
                  index: list.isEmpty == true ? 0 : list.length + 1,
                  devamivarmi: true)));
        },
      ),
      appBar: appbar,
      body: list.isNotEmpty
          ? ListView.builder(
              itemBuilder: ((context, index) {
                return childrenDondur(index: index);
              }),
              itemCount: list.length)
          : Container(),
    );
  }

  Widget childrenDondur({required int index}) {
    Color renk = list[index]["renk"] == "postit"
        ? Colors.yellowAccent
        : list[index]["renk"] == "yesil"
            ? Colors.greenAccent
            : Colors.blueAccent;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NotSyf(
                    baslik: list[index]["baslik"].toString(),
                    not: list[index]["not"].toString(),
                    tarih: "Tarih : ${list[index]["tarih"].toString()}",
                    renk: renk,
                    index: index,
                    devamivarmi: false,
                  )));
        },
        child: Container(
            height: 150,
            width: 50,
            decoration: BoxDecoration(
                color: renk,
                border: Border.all(width: 3, color: renk),
                borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              Text(
                list[index]["baslik"].toString(),
                style: const TextStyle(color: Colors.black),
              ),
              Text(
                "Tarih : ${(list[index]["tarih"] as Timestamp).toDate().day.toString() + "/" + (list[index]["tarih"] as Timestamp).toDate().month.toString() + "/" + (list[index]["tarih"] as Timestamp).toDate().year.toString()}",
                style: const TextStyle(color: Colors.black),
              ),
              Text(
                list[index]["not"].toString().length > 99
                    ? list[index]["not"].toString().substring(0, 100)
                    : list[index]["not"].toString(),
                style: const TextStyle(color: Colors.black),
              )
            ])),
      ),
    );
  }
}

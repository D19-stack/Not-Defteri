import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_not_defteri/anaekran.dart';
import 'package:flutter_not_defteri/hesapolustur.dart';
import 'package:flutter_not_defteri/main.dart';

TextEditingController baslikcontroller = TextEditingController();
TextEditingController notcontroller = TextEditingController();
int ilkmi = 0;

class NotSyf extends StatefulWidget {
  String baslik;
  String tarih;
  String not;
  Color renk;
  int index;
  bool devamivarmi;
  NotSyf(
      {required String this.baslik,
      required String this.tarih,
      required String this.not,
      required Color this.renk,
      required int this.index,
      required bool this.devamivarmi,
      Key? key})
      : super(key: key);

  @override
  State<NotSyf> createState() => _NotSyfState();
}

class _NotSyfState extends State<NotSyf> {
  @override
  Widget build(BuildContext context) {
    if (ilkmi == 0) {
      baslikcontroller.text = widget.baslik;
      notcontroller.text = widget.not;
      ilkmi++;
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (widget.devamivarmi == true) {
              list.add({
                "not": notcontroller.text.toString(),
                "baslik": baslikcontroller.text.toString(),
                "tarih": Timestamp.now(),
                "renk": widget.renk == Colors.yellowAccent
                    ? "postit"
                    : widget.renk == Colors.greenAccent
                        ? "yesil"
                        : "mavi"
              });
            } else {
              list.removeAt(widget.index);
              list.add({
                "not": notcontroller.text.toString(),
                "baslik": baslikcontroller.text.toString(),
                "tarih": Timestamp.now(),
                "renk": widget.renk == Colors.yellowAccent
                    ? "postit"
                    : widget.renk == Colors.greenAccent
                        ? "yesil"
                        : "mavi"
              });
            }
            firestore
                .collection("users")
                .doc(pref!.getString("mail"))
                .update({"notlar": list});
            baslikcontroller.clear();
            notcontroller.clear();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => AnaEkran(),
            ));
            ilkmi = 0;
          },
          child: Icon(Icons.save)),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Not Defterim",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                list.removeAt(widget.index);
                await firestore
                    .collection("users")
                    .doc(pref!.getString("mail"))
                    .update({"notlar": list});
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return AnaEkran();
                }));
              },
              icon: Icon(
                Icons.delete,
              ))
        ],
      ),
      body: ListView(
        children: childrendonduttur(),
      ),
    );
  }@override
  void dispose() {
    baslikcontroller.clear();
    notcontroller.clear();
    super.dispose();
  }

  List<Widget> childrendonduttur() {
    return [
      Column(
        children: [
          TextFormField(
            controller: baslikcontroller,
            maxLength: 50,
            decoration: InputDecoration(
                hintText: "Başlık",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
          ),
          Divider(
            height: 30,
          ),
          TextFormField(
            controller: notcontroller,
            maxLines: 15,
            decoration: InputDecoration(
                hintText: "Not",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(200),
                        border: Border.all(
                            color: widget.renk == Colors.yellowAccent
                                ? Colors.white
                                : Colors.yellowAccent,
                            width: 2.5)),
                  ),
                  onTap: () {
                    setState(() {
                      widget.renk = Colors.yellowAccent;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(200),
                        border: Border.all(
                            color: widget.renk == Colors.greenAccent
                                ? Colors.white
                                : Colors.greenAccent,
                            width: 2.5)),
                  ),
                  onTap: () {
                    setState(() {
                      widget.renk = Colors.greenAccent;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(200),
                        border: Border.all(
                            color: widget.renk == Colors.blueAccent
                                ? Colors.white
                                : Colors.blueAccent,
                            width: 2.5)),
                  ),
                  onTap: () {
                    setState(() {
                      widget.renk = Colors.blueAccent;
                    });
                  },
                ),
              ),
            ],
          )
        ],
      )
    ];
  }
}

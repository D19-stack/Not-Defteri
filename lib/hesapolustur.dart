import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_not_defteri/anaekran.dart';
import 'package:flutter_not_defteri/loginislemleri.dart';
import 'package:flutter_not_defteri/main.dart';

class HesapOlustur extends StatefulWidget {
  const HesapOlustur({Key? key}) : super(key: key);

  @override
  State<HesapOlustur> createState() => _HesapOlusturState();
}

String? email;
String? password;
GlobalKey formkey = GlobalKey<FormState>();
TextEditingController mailim = TextEditingController();
TextEditingController passwordum = TextEditingController();
FirebaseFirestore firestore = FirebaseFirestore.instance;

class _HesapOlusturState extends State<HesapOlustur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Form(
          key: formkey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (a) {
                    email = a.toString();
                  },
                  controller: mailim,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Lütfen Mail Adresinizi Giriniz",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (a) {
                    password = a.toString();
                  },
                  controller: passwordum,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Lütfen Şifrenizi Giriniz",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ),
              ElevatedButton(
                  onPressed: hesapOlusturLan,
                  child: const Text("Hesap Oluştur")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const LoginIslemleri();
                    }));
                  },
                  child: const Text(
                      "Sisteme Kayıtlı Bir Hesabınız Varsa Hemen Onunla Giriş Yapın."))
            ],
          )),
    );
  }

  void hesapOlusturLan() async {
    String email = mailim.text.toString();
    String password = passwordum.text.toString();

    try {
      debugPrint("trya girdi");
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      debugPrint("kullanıcı oluştu");
      User yeniUser = credential.user!;
      debugPrint(yeniUser.toString());
      if (auth.currentUser != null) {
        firestore.collection("users").doc(email.toString()).set({
          "email": email,
          "kayit_ani": FieldValue.serverTimestamp(),
          "notlar": []
        });
        pref!.setBool("dark", true);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => AnaEkran()));
        debugPrint("try çıktı");
      }
    } catch (error) {
      debugPrint("******************* Hata Var *******************");
      debugPrint(error.toString());
      if (error.toString() ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        ScaffoldMessenger.of(context).showSnackBar(snackBardondur(
            "Mail Zaten Başka Bir Hesap Tarafından Kullanılıyor."));
      } else if (error.toString() ==
          "[firebase_auth/weak-password] Password should be at least 6 characters") {
            ScaffoldMessenger.of(context).showSnackBar(snackBardondur("Şifre En Az 6 Karakter Uzunluğunda Olmalıdır."));
          }
    }
  }
}

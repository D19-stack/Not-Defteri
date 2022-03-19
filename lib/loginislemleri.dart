import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_not_defteri/hesapolustur.dart';
import 'package:flutter_not_defteri/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';

import 'anaekran.dart';

class LoginIslemleri extends StatefulWidget {
  const LoginIslemleri({Key? key}) : super(key: key);

  @override
  State<LoginIslemleri> createState() => _LoginIslemleriState();
}

ekle(bool neyiekleyeyim) {
  pref!.setBool("remember", neyiekleyeyim);
  if (mail.text.toString() != "") {
    pref!.setString("mail", mail.text.toString());
  }
}

FirebaseAuth auth = FirebaseAuth.instance;
TextEditingController mail = TextEditingController();
TextEditingController password = TextEditingController();
AppBar appbar = AppBar(
automaticallyImplyLeading :false,    elevation: 0,
    title: const Text(
      "Not Defterim",
      style: TextStyle(color: Colors.white),
    ));

class _LoginIslemleriState extends State<LoginIslemleri> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Form(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onSaved: (a) {
                email = a.toString();
              },
              controller: mail,
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
                passwordum = a.toString();
              },
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Lütfen Şifrenizi Giriniz",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          TextButton(
              onPressed: () async {
                try {
                  await auth.sendPasswordResetEmail(
                      email: mail.text.toString());
                  print(
                      "resetleme maili ${mail.text.toString()} adresine gönderildi");
                  ScaffoldMessenger.of(context).showSnackBar(snackBardondur(
                      "${mail.text.toString()} Mail Adresine Şifre Değiştirme Maili Attık.Lütfen Mailinizi Kontrol Edin"));
                } catch (error) {
                  print("şifre resetlenirken bir hata oluştu");
                  print(
                      "***********************************************************");
                  if (error.toString() ==
                      "[firebase_auth/unknown] Given String is empty or null") {
                    ScaffoldMessenger.of(context).showSnackBar(
                        snackBardondur("Lütfen Mail Adresinizi Giriniz"));
                  } else {
                    print(error.toString());
                    ScaffoldMessenger.of(context).showSnackBar(snackBardondur(
                        "Bir Hata Oluştu , Lütfen Daha Sonra Tekrar Deneyin"));
                  }
                }
              },
              child:const Text("Şifremi Unuttum")),
          ElevatedButton(onPressed: girisyaplan, child: const Text("Giriş yap")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Beni Hatırla"),
              Checkbox(activeColor: Colors.white,checkColor: Colors.black,value: _isChecked, onChanged: (degisim){
                setState(() {
                _isChecked=degisim!;
                });
              }),
            ],
          ),TextButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return HesapOlustur();
            }));
          }, child: Text("Sisteme Kayıtlı Bir Hesabınız Yoksa Hemen Yeni Bir Tane Oluşturun."))
        ],
      )),
    );
  }

  String? email;
  String? passwordum;
  void girisyaplan() async {
    email = mail.text.toString();
    passwordum = password.text.toString();
    await auth.signOut();

    try {
      await auth.signOut();
      if (auth.currentUser == null) {
        User oturumacanuser = (await auth.signInWithEmailAndPassword(
                email: mail.text.toString(),
                password: password.text.toString()))
            .user!;
        debugPrint(oturumacanuser.toString());
        ekle(_isChecked);
        pref!.setBool("dark", true);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AnaEkran()));
      } else {
        debugPrint("Şu an zaten giriş yapmış bir kullanıcı var");
      }
    } catch (error) {
      debugPrint("******************* Hata Var *******************");
      debugPrint(error.toString());
      if (error.toString() ==
          "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBardondur("Şifre Ya Da Mail Yanlış"));
      } else if (error.toString() ==
          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
        ScaffoldMessenger.of(context).showSnackBar(
            snackBardondur("Böyle Bir Kullanıcı Yok Ya Da Silinmiş..."));
      }
    }
  }
}

SnackBar snackBardondur(String yazi) {
  return SnackBar(
    content: Text(
      yazi,
      style: TextStyle(color: Colors.black),
    ),
    backgroundColor: Colors.grey,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
  );
}

bool _isChecked = false;

import 'package:flutter/material.dart';
import 'package:kisiler_uygulamasi/Kisilerdao.dart';
import 'package:kisiler_uygulamasi/main.dart';


class KisiKayitSayfa extends StatefulWidget {
  const KisiKayitSayfa({super.key});

  @override
  State<KisiKayitSayfa> createState() => _KisiKayitSayfaState();
}

class _KisiKayitSayfaState extends State<KisiKayitSayfa> {

  var tfKisiAdi=TextEditingController();
  var tfKisiTel=TextEditingController();


  Future<void>kayit(String kisi_ad,String kisi_tel) async{
    await Kisilerdao().kisiEkle(kisi_ad, kisi_tel);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Anasayfa(title: "")));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("KİŞİ KAYIT"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0,right: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: tfKisiAdi,
                decoration: InputDecoration(hintText: "KİŞİ AD: "),
              ),

              TextField(
                controller: tfKisiTel,
                decoration: InputDecoration(hintText: "KİŞİ TEL: "),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
         kayit(tfKisiAdi.text, tfKisiTel.text);
        },
        tooltip: 'KİŞİ KAYIT',
        icon: Icon(Icons.save_alt_sharp),
        label: Text("KAYDET"),
      ),
    );
  }
}

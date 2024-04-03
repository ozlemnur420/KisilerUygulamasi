
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kisiler_uygulamasi/Kisi_detay_sayfa.dart';
import 'package:kisiler_uygulamasi/Kisi_kay%C4%B1t_sayfa.dart';
import 'package:kisiler_uygulamasi/Kisiler.dart';
import 'package:kisiler_uygulamasi/Kisilerdao.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const Anasayfa(title: ''),
    );
  }
}

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key, required this.title});

  final String title;

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  bool aramaYapiliyorMu=false;
  String arama_kelimesi="";

  Future<List<Kisiler>>tumKisileriGoster() async{
    var kisiler_listesi= await Kisilerdao().tumKisiler();
    return kisiler_listesi;
  }

  Future<List<Kisiler>>aramaYap(String arama_kelimesi) async{
    var kisiler_listesi= await Kisilerdao().kisiArama(arama_kelimesi);
    return kisiler_listesi;
  }

  Future<void>sil(int kisi_id) async{
    await Kisilerdao().kisiSil(kisi_id);
    setState(() {

    });
  }

  Future<bool>uygulamayiKapat() async{
   await exit(0);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: (){
            uygulamayiKapat();
          },
        ),
        title: aramaYapiliyorMu ?
            TextField(
              decoration: InputDecoration(hintText: "Arama yapmak için bir şey yazınız"),
              onChanged: (arama_sonucu){

                print("Arama sonucu: $arama_sonucu");
                setState(() {
                  arama_kelimesi=arama_sonucu;
                });

              },
            )
            : Text("KİŞİLER UYGULAMASI"),

        actions: [
          aramaYapiliyorMu ?  // true durumu
            IconButton(
           icon: Icon(Icons.cancel,),
           onPressed: (){
           setState(() {
           aramaYapiliyorMu=false;
           arama_kelimesi="";
         });
       },
       )
          : IconButton(
            icon: Icon(Icons.search_rounded), // false durumu
            onPressed: (){
              setState(() {
                aramaYapiliyorMu=true;

              });
            },
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      ),
      body: WillPopScope(
        onWillPop: uygulamayiKapat,
        child: FutureBuilder<List<Kisiler>>(
        
          future: aramaYapiliyorMu ? aramaYap(arama_kelimesi) : tumKisileriGoster(),
          builder: (context,snapshot){
            if(snapshot.hasData){
        
              var kisiler_listesi=snapshot.data;
              return ListView.builder(
                itemCount: kisiler_listesi!.length,
                itemBuilder: (context,indeks){
                  var kisi=kisiler_listesi[indeks];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>KisiDetaySayfa(kisi: kisi,)));
                    },
                    child: Card(
        
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
        
                            Text(kisi.kisi_ad,style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(kisi.kisi_tel),
                            IconButton(
        
                              icon: Icon(Icons.delete_forever),
                              onPressed: (){
                                sil(kisi.kisi_id);
                              },
        
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
        
            else{
              return Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>KisiKayitSayfa()));
        },
        tooltip: 'KİŞİ EKLE',
        child: const Icon(Icons.add_box),
      ),
    );
  }
}

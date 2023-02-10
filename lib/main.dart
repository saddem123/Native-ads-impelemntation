import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:test_ads_clean/locator.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: [
        '883d4442-b7db-4b6e-869c-e157c5fd1bbb',
        '86f80ed3-107e-4c0b-8b2b-27dec65cadd8',
        'F160D736-A6B6-4329-9CBA-ABBA1D8235EE'
      ]));
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  @override
  void initState() {
    super.initState();

  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late NativeAd ad;
  bool withAds = true;
  bool adLoaded = false;



  @override
  void initState() {
    super.initState();
    if(withAds) ad = generateNewAd()..load();
    // ad = generateNewAd()..load();
  }

  NativeAd generateNewAd() {
    return NativeAd(
      adUnitId: Platform.isAndroid ?
          'ca-app-pub-3940256099942544/1044960115':
          'ca-app-pub-3940256099942544/2521693316',
      factoryId: 'listTile',
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
          mediaAspectRatio: MediaAspectRatio.landscape,
          videoOptions: VideoOptions(
            customControlsRequested: false,
            clickToExpandRequested: false,
            startMuted: false,
          )),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            adLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print("error loading ads $error");
        }
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          /// VideoWidget(videoUrl: _videos[index]),
          if(adLoaded) AdWidgetContainer(ad: ad)
        ],
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    ad.dispose();
  }
}

class ImageContainer extends StatelessWidget {
  final String imageUrl;
  const ImageContainer({Key? key,required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("ImageContainer ${imageUrl}");
    return Container(
        margin: const EdgeInsets.only(bottom: 30,top: 20),
        child: Image.network(imageUrl,width: MediaQuery.of(context).size.width,height: 300,fit: BoxFit.cover,));
  }
}


class AdWidgetContainer extends StatefulWidget {
  final NativeAd ad;
  const AdWidgetContainer({Key? key,required this.ad}) : super(key: key);

  @override
  State<AdWidgetContainer> createState() => _AdWidgetContainerState();
}

class _AdWidgetContainerState extends State<AdWidgetContainer> {


  @override
  void initState() {
    super.initState();
    //widget.ad.load().then((value) => setState(() => _adLoaded = true));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: AdWidget(key: Key(widget.ad.hashCode.toString()),ad: widget.ad),
    );
  }

  @override
  void dispose() {
    // widget.ad.dispose();
    super.dispose();
  }
}


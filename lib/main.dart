import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:test_ads_clean/locator.dart';
import 'package:test_ads_clean/resuable_video_player_service.dart';
import 'package:visibility_detector/visibility_detector.dart';


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

  int loadedAds = 0;
  late List<NativeAd> _ads;
  List<bool> _loadedState = [false,false,false,false,false,false];

  late NativeAd ad;
  bool withAds = true;


  final List<String> _videos = const [
    /*'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4"*/
  ];


  @override
  void initState() {
    super.initState();
    if(withAds) _ads = _preloadNativeAds();
    // ad = generateNewAd()..load();
  }

  NativeAd generateNewAd(int index) {
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
          print("ad loaded $index");
          setState(() {
            _loadedState[index] = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print("error loading ads $error");
        }
      ),

    );
  }

  List<NativeAd> _preloadNativeAds(){
    return  [generateNewAd(0)..load()];
  }

  List<Widget> _oldList(){
    return [
      const ImageContainer(imageUrl: "https://picsum.photos/250?image=9"),
      if(withAds && _loadedState[0])
        AdWidgetContainer(ad: _ads[0],index: 1,),
      const VideoWidget(videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"),
      // AdWidgetContainer(ad: ad),
      const ImageContainer(imageUrl: 'https://picsum.photos/250?image=10'),
      if(withAds && _loadedState[1])
        AdWidgetContainer(ad: _ads[1],index: 2),
      const VideoWidget(videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"),
      const ImageContainer(imageUrl: 'https://picsum.photos/250?image=7'),
      if(withAds && _loadedState[2])
        AdWidgetContainer(ad: _ads[2],index: 3),
      const ImageContainer(imageUrl: 'https://picsum.photos/250?image=6'),
      if(withAds && _loadedState[3])
        AdWidgetContainer(ad: _ads[3],index: 4,),
      // AdWidgetContainer(ad: ad),
      const ImageContainer(imageUrl: 'https://picsum.photos/250?image=10'),
      if(withAds && _loadedState[4])
        AdWidgetContainer(ad: _ads[4],index: 5),
      const ImageContainer(imageUrl: 'https://picsum.photos/250?image=7'),
      if(withAds && _loadedState[5])
        AdWidgetContainer(ad: _ads[5],index: 6),
      const ImageContainer(imageUrl: 'https://picsum.photos/250?image=6'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print("build MyHomePage");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context,index) {
          return Column(
            children: [
              /// VideoWidget(videoUrl: _videos[index]),
              if(_loadedState[0]) AdWidgetContainer(ad: _ads[0], index:0)
            ],
          );
        },
      )
    );
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
  final int index;
  const AdWidgetContainer({Key? key,required this.ad,required this.index}) : super(key: key);

  @override
  State<AdWidgetContainer> createState() => _AdWidgetContainerState();
}

class _AdWidgetContainerState extends State<AdWidgetContainer> {

  bool _adLoaded = false;

  @override
  void initState() {
    super.initState();
    //widget.ad.load().then((value) => setState(() => _adLoaded = true));
  }

  @override
  Widget build(BuildContext context) {
    print("build AdWidgetContainer ${widget.index}");
    return SizedBox(
        height: 400,
        width: MediaQuery.of(context).size.width,
        child:  AdWidget(key: Key(widget.ad.hashCode.toString()),ad: widget.ad)
    );
  }

  @override
  void dispose() {
    // widget.ad.dispose();
    super.dispose();
  }
}

class VideoWidget extends StatefulWidget {
  final String videoUrl;
  const VideoWidget({Key? key,required this.videoUrl}) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {

  BetterPlayerController? _betterPlayerController;
  bool _playerInitialized = false;
  final VideoPlayerControllerPool _controllerPool = locator<VideoPlayerControllerPool>();
  double _visibilityFraction = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init state");
    _betterPlayerController = _controllerPool.getBetterPlayerController(hashThumbnail: "L00cGya#j[a}bHazWojbbHazjbfQ");
    _betterPlayerController?.setupDataSource(BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.videoUrl));
    _betterPlayerController?.setControlsEnabled(false);
    _betterPlayerController?.addEventsListener(onPlayerEvent);
  }

  void onPlayerEvent(BetterPlayerEvent event) {
    //if(!hasException) {
    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.initialized:

          setState(() {
            _playerInitialized = true;
          });
          print("initalized player");
          if(_visibilityFraction > 0.4){
            play();
          }
          /*if(_betterPlayerController){

          }*/
          //}else{
          // _configureControllerOnIos(videoDownloadUrl);
          // }
        

        break;
      case BetterPlayerEventType.play:
      // TODO: Handle this case.
      //TODO: Fix Playing in background.
        /*if (betterPlayerController != null) {
          NewsFeedViewModel.isMuted
              ? betterPlayerController!.setVolume(0)
              : betterPlayerController!.setVolume(1);
        }*/
        break;
      case BetterPlayerEventType.pause:
      // TODO: Handle this case.
        break;
      case BetterPlayerEventType.seekTo:
      //  //Utils.printf('seekTo');
      // TODO: Handle this case.
        break;
      case BetterPlayerEventType.openFullscreen:
      // TODO: Handle this case.
        break;
      case BetterPlayerEventType.hideFullscreen:
      // TODO: Handle this case.
        break;
      case BetterPlayerEventType.setVolume:
      // TODO: Handle this case.
        break;
      case BetterPlayerEventType.progress:
      //  //Utils.printf("better Play progress");
        // _incrementNbViews();
        break;
      case BetterPlayerEventType.finished:
        _betterPlayerController?.seekTo(const Duration(seconds: 0));
        // TODO: Handle this case.
        break;
      case BetterPlayerEventType.exception:
      // TODO: Handle this case.
      // Utils.printf('better exception');
      // SchedulerBinding.instance!.addPersistentFrameCallback((timeStamp) {
      // if(Platform.isAndroid){
      // betterPlayerController!.

        /*if (!disposed) {
          _videoPlayerControllerPool.replaceBetterPlayerController(
              betterPlayerController,
              hashThumbnail: post.hashThumbnail);
          dataSourceInitialized = false;
          _controllerInitialized = false;
          betterPlayerController = _videoPlayerControllerPool
              .getBetterPlayerController(hashThumbnail: post.hashThumbnail);
          _configureController(videoDownloadUrl);
          notifyListeners();
          // _videoPlayerControllerPool.replaceBetterPlayerController(betterPlayerController);
        }*/
        // hasException = true;
        //notifyListeners();
        // });
        break;
      case BetterPlayerEventType.controlsVisible:
      // TODO: Handle this case.
        break;
    /* case BetterPlayerEventType.controlsHidden:
                  // TODO: Handle this case.
                  break;*/
      case BetterPlayerEventType.setSpeed:
      // TODO: Handle this case.
        break;
      case BetterPlayerEventType.changedSubtitles:
      // TODO: Handle this case.
        break;
      case BetterPlayerEventType.changedTrack:
      // TODO: Handle this case.
        break;
      case BetterPlayerEventType.changedPlayerVisibility:
      //print('changedPlayerVisibility ${}');
        break;
      case BetterPlayerEventType.changedResolution:
      // TODO: Handle this case.
        break;
      case BetterPlayerEventType.pipStart:
      // TODO: Handle this case.
      // Utils.printf('pip start called');

        break;
      case BetterPlayerEventType.pipStop:
      // TODO: Handle this case.
      // Utils.printf('pip stop called');
        break;
      case BetterPlayerEventType.setupDataSource:
      // Utils.printf('setup data source');
      // TODO: Handle this case.
        break;
      case BetterPlayerEventType.bufferingStart:
      // TODO: Handle this case.
      // Utils.printf('buffering start');
        //play();
        // Utils.printf('buffering start');
        // betterPlayerController!.play();
        break;
      case BetterPlayerEventType.bufferingUpdate:
      // Utils.printf('buffering update');
        //play();
        // TODO: Handle this case.
        break;
      case BetterPlayerEventType.bufferingEnd:
      // TODO: Handle this case.
        break;
      case BetterPlayerEventType.controlsHiddenStart:
      // TODO: Handle this case.
        break;
      case BetterPlayerEventType.controlsHiddenEnd:
      // TODO: Handle this case.
        break;
      case BetterPlayerEventType.changedPlaylistItem:
      // TODO: Handle this case.
        break;
    }
    //}
  }

  void play(){
    if(_betterPlayerController != null && (_betterPlayerController!.isPlaying() == false)){
      _betterPlayerController!.play();
    }
  }
  void pause(){
    if(_betterPlayerController != null && (_betterPlayerController!.isPlaying() == true)){
      _betterPlayerController!.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    var sw = MediaQuery.of(context).size.width;
    return VisibilityDetector(
      key: Key('visibility-player-${widget.videoUrl}'),
      onVisibilityChanged: (visibleForTesting){
        _visibilityFraction = _visibilityFraction;
        if(visibleForTesting.visibleFraction > 0.4){
          play();
        } else {
          pause();
        }
      },
      child: SizedBox(
        width: sw,
        height:  sw * 16 / 12 ,
        child:  _betterPlayerController != null  && _playerInitialized ? BetterPlayer(
          controller: _betterPlayerController!,
        ) :  const Center(
          child:  SizedBox(
              width: 25,
              height: 25,
              child:  CircularProgressIndicator()),
        ),
      ),
    );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose");
    _betterPlayerController?.removeEventsListener(onPlayerEvent);
    _controllerPool.freeBetterPlayerController(_betterPlayerController);
    _betterPlayerController = null;
    _playerInitialized = false;
  }

}

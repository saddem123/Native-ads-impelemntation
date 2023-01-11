import 'package:better_player/better_player.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:test_ads_clean/default_better_player_controller_configuration.dart';
import 'package:test_ads_clean/loading_video_blur_widget.dart';


class VideoPlayerControllerPool {
  final List<BetterPlayerController> _betterPlayerControllerRegistry = [];
  final List<BetterPlayerController> _usedBetterPlayerControllerRegistry = [];
  final Map<BetterPlayerController, int> _controllersCountDown = {};
  // cached controllers that need to be disposed after elapsed countdown (declared here to eliminate GC)
  final List<BetterPlayerController> _controllerDisposeQueue = [];
  List<BetterPlayerController> _runningControllers = List.empty(growable: true);
  int preAllocatedControllers = 1;

  int unusedControllerLifeTime = 3;

  // Map<int, Function(double visibilityFraction)> visibilityFractionCallBacks =  Map();

  // Map<BetterPlayerController,Function(BetterPlayerEvent)?> betterPlayerEventCallBacks=Map();

  /*
  setPlayerVisibilityChangedBehavior(BetterPlayerController controller,
      Function(double) playerVisibilityChangedBehavior) {
    var controllerIndex = _betterPlayerControllerRegistry.indexOf(controller);

    if (controllerIndex == -1) return;

    //Set callback
    visibilityFractionCallBacks[controllerIndex] =
        playerVisibilityChangedBehavior;
  }

  visibilityFractionCallBack(visibility){
    var controllerIndex = _betterPlayerControllerRegistry.length;

    var callback = visibilityFractionCallBacks[controllerIndex];
    //Utils.printf("callback $callback");
    if (callback != null) callback(visibility);
  }
*/

  pauseControllers() {
    _runningControllers.clear();
    _usedBetterPlayerControllerRegistry.forEach((controller) {
      if (controller.isPlaying() == true) {
        controller.pause();
        _runningControllers.add(controller);
      }
    });
  }

  resumeControllers() {
    _runningControllers.forEach((controller) {
      controller.play();
    });
    _runningControllers.clear();
  }

  _createController({String? hashThumbnail}) {
    return BetterPlayerController(
      BetterPlayerConfiguration(
          fit: BoxFit.cover,
          startAt: Duration(seconds: 0),
          controlsConfiguration: DefaultBetterPlayerControlsConfiguration(loadingWidget: LoadingVideoBlurWidget(
              hashThumbnail: (hashThumbnail == null || hashThumbnail == '')
                  ? "L00cGya#j[a}bHazWojbbHazjbfQ"
                  : hashThumbnail)),
          allowedScreenSleep: false,
          autoPlay: false,
          autoDispose: false,
          handleLifecycle: false,
          looping: false),
    );
  }

  VideoPlayerControllerPool({String? hashThumbnail}) {
    for (int index = 0; index < preAllocatedControllers; index++) {
      _betterPlayerControllerRegistry
          .add(_createController(hashThumbnail: hashThumbnail));
    }

    /*Timer.periodic(Duration(seconds: 1), (timer) {
      Utils.printf(
          "_usedBetterPlayerControllerRegistry count: ${_usedBetterPlayerControllerRegistry.length}");
      Utils.printf(
          "_betterPlayerControllerRegistry count: ${_betterPlayerControllerRegistry.length}");
      Utils.printf(
          "_controllersCountDown count: ${_controllersCountDown.length}");

      if (_usedBetterPlayerControllerRegistry.length >=
          _betterPlayerControllerRegistry.length) return;
      _controllerDisposeQueue.clear();

      _controllersCountDown.forEach((controller, lifeTime) {
        // Utils.printf("lifeTime $lifeTime");
        // Utils.printf(
        //     "_controllersCountDown[controller] before ${_controllersCountDown[controller]}");
        if (lifeTime < unusedControllerLifeTime) {
          lifeTime++;
          _controllersCountDown[controller] = lifeTime;
          // Utils.printf(
          //     "_controllersCountDown[controller] after ${_controllersCountDown[controller]}");
          return;
        }
        //cache controller for dispose
        _controllerDisposeQueue.add(controller);
      });

      _controllerDisposeQueue.forEach((queuedController) {
        _betterPlayerControllerRegistry.remove(queuedController);
        //remove from count down
        _controllersCountDown.remove(queuedController);
        queuedController.dispose(forceDispose: true);
      });

      _controllerDisposeQueue.clear();
    });*/
  }

  void pauseControllersDefinitively(){
    if(_betterPlayerControllerRegistry.isNotEmpty){
      _betterPlayerControllerRegistry.forEach((controller) {
        try{
          if(controller.isVideoInitialized() == true && controller.isPlaying() == true){
            controller.pause();
          }
        }catch(e){
          print("error controllers" + e.toString());
        }
      });
    }
  }

  BetterPlayerController getBetterPlayerController({String? hashThumbnail}) {
    var freeController = _betterPlayerControllerRegistry.firstWhereOrNull(
            (controller) =>
        !_usedBetterPlayerControllerRegistry.contains(controller));

    if (freeController == null) {
      freeController = _createController(hashThumbnail: hashThumbnail);
      _betterPlayerControllerRegistry.add(freeController!);
    }

    _usedBetterPlayerControllerRegistry.add(freeController);

    // _controllersCountDown.remove(freeController);

    print(
        "_usedBetterPlayerControllerRegistry count: ${_usedBetterPlayerControllerRegistry.length}");
    print(
        "_betterPlayerControllerRegistry count: ${_betterPlayerControllerRegistry.length}");

    return freeController;
  }

  void freeBetterPlayerController(
      BetterPlayerController? betterPlayerController) async {
    // Utils.printf("freeBetterPlayerController called");
    if (betterPlayerController == null) return;
    if (betterPlayerController.isPlaying() != null &&
        betterPlayerController.isPlaying() != null &&
        betterPlayerController.isPlaying()!) {
      await betterPlayerController.pause();
      print('paused');
    }
    /*
    var controllerIndex =
        _betterPlayerControllerRegistry.indexOf(betterPlayerController);
    visibilityFractionCallBacks.remove(controllerIndex);*/
    _usedBetterPlayerControllerRegistry.remove(betterPlayerController);

    // reset countDown
    // _controllersCountDown[betterPlayerController] = 0;
    print(
        "_usedBetterPlayerControllerRegistry after free ${_usedBetterPlayerControllerRegistry.length}");
    print(
        "_betterPlayerControllerRegistry after free ${_betterPlayerControllerRegistry.length}");
  }

  void replaceBetterPlayerController(
      BetterPlayerController? betterPlayerController,
      {String? hashThumbnail}) {
    print("freeBetterPlayerController called");
    if (betterPlayerController == null) return;

    _betterPlayerControllerRegistry.clear();
    // _usedBetterPlayerControllerRegistry.clear();
    // _usedBetterPlayerControllerRegistry.remove(betterPlayerController);
    _betterPlayerControllerRegistry
        .add(_createController(hashThumbnail: hashThumbnail));

    // var newController = _createController();
    // _betterPlayerControllerRegistry[_indexOfController] = newController;
    // _controllersCountDown[newController] = 0;
    // freeBetterPlayerController(betterPlayerController);
    // _usedBetterPlayerControllerRegistry.remove(betterPlayerController);
    // _controllersCountDown.remove(betterPlayerController);
    betterPlayerController.dispose();
  }

  void dispose() {
    _betterPlayerControllerRegistry.forEach((controller) {
      controller.dispose();
    });
  }

// resetControllers(){
//   _betterPlayerControllerRegistry.forEach((controller) {
//     controller.dispose( forceDispose: true);
//   });
//   _betterPlayerControllerRegistry.clear();
//   _usedBetterPlayerControllerRegistry.clear();
//   _controllerDisposeQueue.clear();
//   _controllersCountDown.clear();
//
//   Utils.printf("_betterPlayerControllerRegistry after reset count: ${_betterPlayerControllerRegistry.length}");
// }
}

/// old VideoPlayerControllerPool
// class VideoPlayerControllerPool {
//   final List<BetterPlayerController> _betterPlayerControllerRegistry = [];
//   final List<BetterPlayerController> _usedBetterPlayerControllerRegistry = [];
//   List<BetterPlayerController> _runningControllers = List.empty(growable: true);
//   int preAllocatedControllers = 1;
//
//   // Map<int, Function(double visibilityFraction)> visibilityFractionCallBacks =  Map();
//
//   // Map<BetterPlayerController,Function(BetterPlayerEvent)?> betterPlayerEventCallBacks=Map();
//
//   /*
//   setPlayerVisibilityChangedBehavior(BetterPlayerController controller,
//       Function(double) playerVisibilityChangedBehavior) {
//     var controllerIndex = _betterPlayerControllerRegistry.indexOf(controller);
//
//     if (controllerIndex == -1) return;
//
//     //Set callback
//     visibilityFractionCallBacks[controllerIndex] =
//         playerVisibilityChangedBehavior;
//   }
//
//   visibilityFractionCallBack(visibility){
//     var controllerIndex = _betterPlayerControllerRegistry.length;
//
//     var callback = visibilityFractionCallBacks[controllerIndex];
//     Utils.printf("callback $callback");
//     if (callback != null) callback(visibility);
//   }
// */
//
//   _createController() {
//     return BetterPlayerController(
//       BetterPlayerConfiguration(
//           fit: BoxFit.cover,
//           controlsConfiguration: BetterPlayerControlsConfiguration(
//               loadingWidget: LoadingWidget(),
//               enableAudioTracks: false,
//               enableFullscreen: false,
//               enableMute: false,
//               enableOverflowMenu: false,
//               enablePip: false,
//               enablePlayPause: true,
//               enablePlaybackSpeed: false,
//               enableProgressBar: false,
//               enableProgressBarDrag: false,
//               enableProgressText: false,
//               enableQualities: false,
//               enableRetry: true,
//               enableSkips: false,
//               enableSubtitles: false),
//           allowedScreenSleep: false,
//           autoPlay: false,
//           autoDispose: false,
//           handleLifecycle: false,
//           looping: false),
//     );
//   }
//
//   VideoPlayerControllerPool() {
//     for (int index = 0; index < preAllocatedControllers; index++) {
//       _betterPlayerControllerRegistry.add(_createController());
//     }
//   }
//
//   BetterPlayerController getBetterPlayerController() {
//     var freeController = _betterPlayerControllerRegistry.firstWhereOrNull(
//             (controller) =>
//         !_usedBetterPlayerControllerRegistry.contains(controller));
//
//     if (freeController == null) {
//       freeController = _createController();
//       _betterPlayerControllerRegistry.add(freeController!);
//     }
//     _usedBetterPlayerControllerRegistry.add(freeController);
//
//     Utils.printf(
//         "_usedBetterPlayerControllerRegistry count: ${_usedBetterPlayerControllerRegistry.length}");
//     Utils.printf(
//         "_betterPlayerControllerRegistry count: ${_betterPlayerControllerRegistry.length}");
//
//     return freeController;
//   }
//
//   void freeBetterPlayerController(
//       BetterPlayerController? betterPlayerController) {
//     Utils.printf("freeBetterPlayerController called");
//     if (betterPlayerController == null) return;
//     betterPlayerController.pause();
//     /*
//     var controllerIndex =
//         _betterPlayerControllerRegistry.indexOf(betterPlayerController);
//     visibilityFractionCallBacks.remove(controllerIndex);*/
//     _usedBetterPlayerControllerRegistry.remove(betterPlayerController);
//
//     print(
//         "_usedBetterPlayerControllerRegistry after free ${_usedBetterPlayerControllerRegistry.length}");
//     print(
//         "_betterPlayerControllerRegistry after free ${_betterPlayerControllerRegistry.length}");
//   }
//
//   pauseControllers() {
//     _runningControllers.clear();
//     _usedBetterPlayerControllerRegistry.forEach((controller) {
//       if (controller.isPlaying() == true) {
//         controller.pause();
//         _runningControllers.add(controller);
//       }
//     });
//   }
//
//   resumeControllers() {
//     _runningControllers.forEach((controller) {
//       controller.play();
//     });
//     _runningControllers.clear();
//   }
//
//   void dispose() {
//     _betterPlayerControllerRegistry.forEach((controller) {
//       controller.dispose();
//     });
//   }
// }

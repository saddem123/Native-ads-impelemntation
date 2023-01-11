import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class DefaultBetterPlayerControlsConfiguration extends BetterPlayerControlsConfiguration{
  final Widget loadingWidget;

  DefaultBetterPlayerControlsConfiguration ({
    required this.loadingWidget
  }):super (
    loadingWidget: loadingWidget,
    enableAudioTracks: false,
    enableFullscreen: false,
    enableMute: false,
    enableOverflowMenu: false,
    enablePip: false,
    enablePlayPause: true,
    enablePlaybackSpeed: false,
    enableProgressBar: false,
    enableProgressBarDrag: false,
    enableProgressText: false,
    enableQualities: false,
    enableRetry: false,
    enableSkips: false,
    enableSubtitles: false,
  );

}
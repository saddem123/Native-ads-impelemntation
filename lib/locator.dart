import 'package:get_it/get_it.dart';
import 'package:test_ads_clean/resuable_video_player_service.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  locator.registerSingleton<VideoPlayerControllerPool>(VideoPlayerControllerPool());
}

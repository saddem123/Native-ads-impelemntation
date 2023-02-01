import UIKit
import Flutter
import google_mobile_ads


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [
            "c5526b788a56241494fd9502f3173935",
            "F160D736-A6B6-4329-9CBA-ABBA1D8235EE"
    ]
      // TODO: Register ListTileNativeAdFactory
    let listTileFactory = ListTileNativeAdFactory()
    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(self, factoryId: "listTile",
        nativeAdFactory: listTileFactory)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

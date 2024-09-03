import Flutter
import UIKit
import GoogleMaps // Import du framework Google Maps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Initialisation des services Google Maps avec votre clé API
    GMSServices.provideAPIKey("AIzaSyANNC3DiWElD6gP8Dc7YxNldzwYAkuvJXU")
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

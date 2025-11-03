import Flutter
import UIKit
import DigitalReefSDK
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {
    
  var digitalReef: DigitalReef = DigitalReef.shared
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    UNUserNotificationCenter.current().delegate = self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let drAd: Bool = userInfo["adAvailable"] as! Bool
        if(drAd){
            print("AppDelegate didReceiveRemoteNotification drAd")
            DigitalReef.shared.didReceiveRemoteNotification(application: application, userInfo: userInfo, fetchCompletionHandler: completionHandler)
        }else{
            print("AppDelegate didReceiveRemoteNotification from Others")
        }
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("AppDelegate didRegisterForRemoteNotificationsWithDeviceToken")
        DigitalReef.shared.didRegisterForRemoteNotificationsWithDeviceToken(application, deviceToken: deviceToken)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let drAd: Bool = response.notification.request.content.userInfo["adAvailable"] as? Bool ?? false
        if(drAd){
            DigitalReef.shared.didReceiveNotificationResponse(center: center, didReceive: response, withCompletionHandler: completionHandler)
        }else{
            print("AppDelegate didReceiveResponse from Others")
        }
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let drAd: Bool = notification.request.content.userInfo["adAvailable"] as? Bool ?? false
        if(drAd){
            print("AppDelegate willPresentNotification drAd")
            DigitalReef.shared.willPresentNotification(center: center, willPresent: notification, withCompletionHandler: completionHandler)
        }else{
            print("AppDelegate willPresentNotification from Others")
            completionHandler([.alert, .badge, .sound])
        }
    }
}

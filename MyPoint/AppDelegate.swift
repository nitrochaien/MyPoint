//
//  AppDelegate.swift
//  MyPoint
//
//  Created by Nam Vu on 12/28/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit
import Localize
import Firebase
import UserNotifications
import netfox
import AppsFlyerLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    override init() {
        super.init()
        UIFont.overrideInitialize()
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//        NFX.sharedInstance().start()

        setupLocalize()
        registerObservers()
        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true

        configAppsFlyer()
        registerRemoteNotifications(application)

        if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            pushUserInfo = userInfo
        } else {
            pushUserInfo = nil
        }

        setRoot()

        return true
    }

    private func setRoot() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let initialViewController = SplashScreenViewController()
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }

    private func registerObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pasteboardChanged),
                                               name: UIPasteboard.changedNotification,
                                               object: nil)
    }

    @objc private func pasteboardChanged() {
        Loading.whisper(title: "", subtitle: "common.copied".localized)
        //        let alert = UIAlertController(title: nil,
        //                                      message: "common.copied".localized,
        //                                      preferredStyle: .alert)
        //        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: {
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //                alert.dismiss(animated: true, completion: nil)
        //            }
        //        })
    }

    private func setupLocalize() {
        let localize = Localize.shared
        localize.update(language: "vi")
        // Set your localize provider.
        localize.update(provider: .json)
        // The used language
        print("LOCALIZE: \(localize.currentLanguage)")
        // List of aviable languajes
        print("LOCALIZE: \(localize.availableLanguages)")
    }

    private func configAppsFlyer() {
        AppsFlyerLib.shared().appsFlyerDevKey = Defines.appsFlyerDevKey
        AppsFlyerLib.shared().appleAppID = Defines.appITunesItemIdentifier
        AppsFlyerLib.shared().delegate = self
    }
    
    private func registerRemoteNotifications(_ application: UIApplication) {
        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Start the SDK (start the IDFA timeout set above, for iOS 14 or later)
        AppsFlyerLib.shared().start()
    }
    
    // Open Deeplinks
    // Open URI-scheme for iOS 9 and above
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        return true
    }
    
    // Report Push Notification attribution data for re-engagements
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerLib.shared().handleOpen(url, options: options)
        return true
    }
    
    // Reports app open from deep link for iOS 10 or later
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//        Storage.shared.deviceToken = tokenString
//        NotificationCenter.default.post(name: NotificationName.didGetDeviceToken, object: nil, userInfo: nil)
    }

    static var shared: AppDelegate? = {
        return UIApplication.shared.delegate as? AppDelegate
    }()
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    // Only triggers in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        pushUserInfo = notification.request.content.userInfo
        completionHandler([.badge, .sound, .alert])
    }

    // Trigger when user tap notification banner
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        pushUserInfo = response.notification.request.content.userInfo
        PushNotificationManager.shared.handlePushNotification()
    }

    // Trigger right after when app receive remote notification
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AppsFlyerLib.shared().handlePushNotification(userInfo)
        pushUserInfo = userInfo
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        Storage.shared.firebaseToken = fcmToken
        #if DEBUG
        Messaging.messaging().subscribe(toTopic: "mypoint_test_namdv")
        #endif
    }
}

// MARK: - AppsFlyerLibDelegate
extension AppDelegate: AppsFlyerLibDelegate {
    
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        print("onConversionDataSuccess data:")
        for (key, value) in installData {
            print(key, ":", value)
        }
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"],
                   let campaign = installData["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = installData["is_first_launch"] as? Bool,
               is_first_launch {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        print(error)
    }
    
    //Handle Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        //Handle Deep Link Data
        print("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            print(key, ":", value)
        }
    }
    
    func onAppOpenAttributionFailure(_ error: Error) {
        print(error)
    }
    
}

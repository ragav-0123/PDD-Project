//
//  AppDelegate.swift
//  Animeverse
//
//  Created by SAIL on 22/02/25.
//

import UIKit
import UserNotifications
import Kommunicate

//@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    // Pass your App Id here. You can get the App Id from install section in the dashboard.
    var appId = "11be8bc3aa73bea6f9cc1281935cebad3"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpNavigationBarAppearance()

        UNUserNotificationCenter.current().delegate = self
        registerForNotification()

        KMPushNotificationHandler.shared.dataConnectionNotificationHandlerWith(Kommunicate.defaultConfiguration, Kommunicate.kmConversationViewConfiguration)
        let kmApplocalNotificationHandler : KMAppLocalNotification =  KMAppLocalNotification.appLocalNotificationHandler()
        kmApplocalNotificationHandler.dataConnectionNotificationHandler()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("APP_ENTER_IN_BACKGROUND")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("APP_ENTER_IN_FOREGROUND")
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        KMDbHandler.sharedInstance().saveContext()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {

        print("DEVICE_TOKEN_DATA :: \(deviceToken.description)")  // (SWIFT = 3) : TOKEN PARSING

        var deviceTokenString: String = ""
        for i in 0..<deviceToken.count
        {
            deviceTokenString += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        print("DEVICE_TOKEN_STRING :: \(deviceTokenString)")

        if (KMUserDefaultHandler.getApnDeviceToken() != deviceTokenString)
        {
            let kmRegisterUserClientService: KMRegisterUserClientService = KMRegisterUserClientService()
            kmRegisterUserClientService.updateApnDeviceToken(withCompletion: deviceTokenString, withCompletion: { (response, error) in
                print ("REGISTRATION_RESPONSE :: \(String(describing: response))")
            })
        }
    }

    func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in

            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let service = KMPushNotificationService()
        let dict = notification.request.content.userInfo
        guard !service.isKommunicateNotification(dict) else {
            service.processPushNotification(dict, appState: UIApplication.shared.applicationState)
            completionHandler([])
            return
        }
        completionHandler([.sound, .badge, .banner])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let service = KMPushNotificationService()
        let dict = response.notification.request.content.userInfo
        if service.isApplozicNotification(dict) {
            service.processPushNotification(dict, appState: UIApplication.shared.applicationState)
        }
        completionHandler()
    }

    func setUpNavigationBarAppearance() {

        // Kommunicate SDK
        let kmNavigationBarProxy = UINavigationBar.appearance(whenContainedInInstancesOf: [KMBaseNavigationViewController.self])
        kmNavigationBarProxy.isTranslucent = false
        kmNavigationBarProxy.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}


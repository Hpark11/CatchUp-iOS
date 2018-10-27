//
//  AppDelegate.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 6. 7..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleMaps
import GooglePlaces
import UserNotifications
import FirebaseMessaging
import AWSAppSync
import RealmSwift
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let gcmMessageIDKey = "gcm.message_id"
  var appSyncClient: AWSAppSyncClient?

  fileprivate var coordinator: SceneCoordinatorType?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // AWS AppSync --------------------------------------------------------------------------------------------]
    let databaseURL = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent(Define.appsyncLocalDB)
    
    do {
      let appSyncConfig = try AWSAppSyncClientConfiguration(url: Define.appsyncEndpointURL, serviceRegion: .APNortheast2, apiKeyAuthProvider: Define.appsyncKeyAPI, databaseURL: databaseURL)
      
      appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
      appSyncClient?.apolloClient?.cacheKeyForObject = { $0["id"] }
    } catch {
      print("Error initializing AppSync client. \(error)")
    }
    
    // Firebase And Google Services ---------------------------------------------------------------------------]
    FirebaseApp.configure()
    GMSServices.provideAPIKey(Define.keyGMSService)
    GMSPlacesClient.provideAPIKey(Define.keyGMSPlace)
    GADMobileAds.configure(withApplicationID: Define.idGADMobileAds)
    
    // Window Config ------------------------------------------------------------------------------------------]
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    guard let uWindow = window else {
      fatalError("Unable to create application window")
    }
    
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    
    // App Coordinator  ---------------------------------------------------------------------------------------]
    coordinator = AppCoordinator(window: uWindow)
    let viewModel = EntranceViewModel(coordinator: coordinator!, client: appSyncClient!)
    let scene = EntranceScene(viewModel: viewModel)
    coordinator?.transition(to: scene, type: .root)
    
    // Realm Config  ------------------------------------------------------------------------------------------]
    let documentsUrl = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent(Define.rlmFileUrlPathPromises)
    
    Realm.Configuration.defaultConfiguration = Realm.Configuration(
      inMemoryIdentifier: Define.rlmManagePromises, schemaVersion: 2,
      migrationBlock: { migration, oldVersion in
        if (oldVersion < 2) {
          
        }
    })
    
    // Push Messaging  ----------------------------------------------------------------------------------------]
    Messaging.messaging().delegate = self
  
    if #available(iOS 10.0, *) {
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
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    KOSession.handleDidBecomeActive()
    UIApplication.shared.applicationIconBadgeNumber = 0
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }
  
  // [START receive_message]
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    // Print full message.
    print(userInfo)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
    // Print full message.
    print(userInfo)
    
    completionHandler(UIBackgroundFetchResult.newData)
  }
  // [END receive_message]
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Unable to register for remote notifications: \(error.localizedDescription)")
  }
  
  // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
  // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
  // the FCM registration token.
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("APNs token retrieved: \(deviceToken)")
    
    // With swizzling disabled you must set the APNs token here.
    // Messaging.messaging().apnsToken = deviceToken
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if KOSession.isKakaoAccountLoginCallback(url) {
      return KOSession.handleOpen(url)
    }
  
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    if KLKTalkLinkCenter.shared().isTalkLinkCallback(url) {
//      guard let params = url.query?.components(separatedBy: "&"), params.count >= 2 else { return true }
//      if let id = params[0].components(separatedBy: "=").last?.dropLast() {
//        guard let phone = UserDefaultService.phoneNumber else { return true }
//        appSyncClient?.perform(mutation: AddContactIntoPromiseMutation(id: String(id), phone: phone)) { result, error in
//          PromiseItem.add(promise: result?.data?.addContactIntoPromise)
//        }
//      }
      return true
    }
    
    if KOSession.isKakaoAccountLoginCallback(url) {
      return KOSession.handleOpen(url)
    }
    return true
  }
  
  // MARK: - Core Data stack
  
  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "Audigo_iOS")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
  
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let _ = notification.request.content.userInfo
    completionHandler([.alert, .sound])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let _ = response.notification.request.content.userInfo
    completionHandler()
  }
}

extension AppDelegate : MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Firebase registration token: \(fcmToken)")
    UserDefaultService.pushToken = fcmToken
  }

  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    print("Received data message: \(remoteMessage.appData)")
  }
}



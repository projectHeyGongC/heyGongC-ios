//
//  AppDelegate.swift
//  heyGongC
//
//  Created by 김은서 on 12/25/23.
//

import UIKit
import CoreData
import FirebaseMessaging
import Firebase
import SwiftyUserDefaults

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var backgroundSessionCompletionHandler: (() -> Void)?
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    lazy var operationQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
        queue.name = "ServerInteractionQueue"
        queue.qualityOfService = .background
        return queue
    }()
    lazy var operationQueueBG:OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
        queue.name = "ServerInteractionQueue"
        queue.qualityOfService = .background
        return queue
    }()
    static var kQueueOperationsChanged = "kQueueOperationsChanged"
    static var kQueueOperationsChangedBG = "kQueueOperationsChangedBG"
    
    
    var window: UIWindow?
    
    override init() {
        super.init()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        Push.configure(application: application, delegate: self)
        
        return true
    }
    
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession
                     identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "heyGongC")
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

// MARK: Life Cycle
extension AppDelegate {
    
    // MARK: UISceneSession Lifecycle
    
    // willPresent (포그라운드 상태)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        push(application: UIApplication.shared, userInfo: userInfo, isLocalPush: true)
        completionHandler([.banner, .list, .badge, .sound]) // alert 는 deprecated라 수정 _ kes 220824
    }
    
    // didReceive (백그라운드 상태)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification
        let userInfo = notification.request.content.userInfo
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Message Closed")
        case UNNotificationDefaultActionIdentifier:
            // [ 메시지를 눌렀을 때 ]
            // 여기서 위의 받았을 때 mainVC나 이동로직 이상하게 쓰면
            // UNUserNotificationCenterDelegate methods not being called 나옴
            break
        default:
            break
        }
        
        push(application: UIApplication.shared, userInfo: userInfo, isLocalPush: true)
        completionHandler()
    }
    
    /**
     push 이벤트 -> linkAction 연결
     - parameters:
        - isLocalPush: 실제 푸시 알림으로 linkAction 처리 / deepLink로 linkAction 처리
     */
    private func push(application: UIApplication, userInfo: [AnyHashable : Any], isLocalPush: Bool) {
        application.applicationIconBadgeNumber = 0
        
//        App.shared.pushInfo = PushInfo(
//            link_url: userInfo["link_url"] as? String ?? "",
//            portfolio_grp: userInfo["portfolio_grp"] as? String ?? "",
//            type: userInfo["type"] as? String ?? ""
//        )
//        
//        /*
//         - link_url : "https://qm.quantec.co.kr:9100/contents/contents_10_220607.html"
//         - portfolio_grp : "UP000"
//         - body : "상품 가입 요망 요망 상품 가입 요망 상품이 나왔습니다. 가입하세요. 요망 상품 가입 요망 상품이 나왔습니다. 가입하세요."
//         - title : "마케팅메세지 테스트"
//         - type : "11"
//         - portfolio : ""
//         */
//        
//        App.shared.hasPushEvent = true
//        if isLocalPush {
//            Defaults.IS_PUSH = true
//        }
//        
        NotificationCenter.default.post(name: GCNotification.Push.name, object: nil)
    }
}

//MARK: Apptracking 권한
extension AppDelegate {
    class NotificationHandler{
        //Permission function
        func askNotificationPermission(completion: @escaping ()->Void){
            //Permission to send notifications
            let center = UNUserNotificationCenter.current()
            // Request permission to display alerts and play sounds.
            center.requestAuthorization(options: [.alert, .badge, .sound])
            { (granted, error) in
                // Enable or disable features based on authorization.
                completion()
            }
        }
    }
}

// MARK: APNS 설정
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 디바이스 토큰
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("deviceToken \(deviceTokenString)")
        // FCM
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError
                     error: Error) {
        print(error)
    }
}

// MARK: DELEGATE - AppDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            print("Firebase registration token: \(token)")
            Defaults.FCM_TOKEN = token
            let dataDict:[String: String] = ["token": token]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        }
    }
}

//
//  AppDelegate.swift
//  Memento
//
//  Created by Jonah Kornberg on 10/19/18.
//  Copyright © 2018 Jonah Kornberg. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import UserNotifications
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge])
        { (granted, error) in
            print("granted: \(granted)")
            if error != nil{
                print("Unsuccess")
            }
        }
        let knownAction = UNNotificationAction(identifier: "knownAction", title: "I Know It", options: [])
        let viewAction = UNNotificationAction(identifier: "viewAction", title: "Show Answer", options: [.foreground])
        let category = UNNotificationCategory(identifier: "questionCategory", actions: [knownAction, viewAction], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        // Override point for customization after application launch.
        return true
    }
    
    
    func scheduleNotifications(set : cardSet){
        let defaults = UserDefaults.standard
        let timeIntervalSetting = defaults.double(forKey: "timeInterval")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Memento Quiz"
        let cardInt = Int.random(in: 0..<set.cards.count)
        content.body = set.cards[cardInt].side1
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "questionCategory"
        let identifier = String(set.dateCreated.hashValue)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Created Notification: \(identifier)")
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {print("Error adding notification: \(error)")}
        }
    }

    func cancelNotifications(set: cardSet){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [String(set.dateCreated.hashValue)])
        print("Deleted Notification: \(String(set.dateCreated.hashValue))")

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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        NotificationCenter.default.post(name: .terminationNotificationKey, object: nil)
    }
    
    // MARK: - Core Data stack
    
   
    
    // MARK: - Core Data Saving support
    

    
}

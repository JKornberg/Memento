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
    var setArray: Results<cardSet>?
    let realm = try! Realm()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Error getting file URL")
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge])
        { (granted, error) in
            print("granted: \(granted)")
            if error != nil{
                print("Unsuccess")
            }
        }
        loadData()
        //Setup actions and categories for notifications
        let knownAction = UNNotificationAction(identifier: "knownAction", title: "I Know It", options: [])
        let viewAction = UNNotificationAction(identifier: "viewAction", title: "Show Answer", options: [.foreground])
        let category = UNNotificationCategory(identifier: "questionCategory", actions: [knownAction, viewAction], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        center.delegate = self
        return true
    }
    
    func loadData(){
        setArray = realm.objects(cardSet.self).sorted(byKeyPath: "dateCreated")
    }
    
    
    func scheduleNotifications(set : cardSet){
        //Set time interval to default if not set manually
        let defaults = UserDefaults.standard
        var timeIntervalSetting = set.duration.value
        if timeIntervalSetting == 0 || timeIntervalSetting == nil  {
            timeIntervalSetting = defaults.double(forKey: "timeInterval") }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let content = UNMutableNotificationContent()
        
        //Setup card content
        content.title = "Memento Quiz"
        let card = getWeightedRandom(set: set)
        content.body = card.side1
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "questionCategory"
        let identifier = String(set.dateCreated.hashValue) + "&\(card.id)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Created Notification with timer: \(String(describing: timeIntervalSetting))")
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {print("Error adding notification: \(error)")}
        }
    }
    
    func getWeightedRandom(set: cardSet) -> Card{
        var totalWeight = 0
        var selectedCard = Card()
        for card in set.cards{
            totalWeight += card.points
        }
        var randInt = Int.random(in: 0..<totalWeight)
        for card in set.cards{
            randInt -= card.points
            if randInt <= 0{
                selectedCard = card
                break
            }
        }
        return selectedCard
    }

    //Cancels pending notifications when toggled off
    func cancelNotifications(set: cardSet){
        let hash = set.dateCreated.hashValue
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (requests) in
            for request in requests{
                if request.identifier.split(separator: "&")[0] == String(hash){
                    center.removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    print("Deleted Notification: \(request.identifier)")

                    break
                }
            }
        }
    }
    
    func changePoints(_ card: Card, right : Bool){
        var newPoints : Int = 5
        var newStreak : Int = 0
        if right{
            switch card.streak{
            case let x where x >= 5:
                newPoints = card.points + 3
            case 3...4:
                newPoints = card.points + 2
            default:
                newPoints = card.points + 1
            }
            newStreak = card.streak + 1
        } else{
            newPoints = card.points - 1
            newStreak = 0
        }
        do{
            try realm.write {
                card.points = newPoints
                card.streak = newStreak
            }
        } catch{
                print("Error changing card score: \(error)")
        }
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

extension AppDelegate : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let ids = response.notification.request.identifier.split(separator: "&")
        let setId = ids[0]
        let cardId = ids[1]
        var selectedSet : cardSet?
        for set in setArray!{
            if String(set.dateCreated.hashValue) == setId{
                selectedSet = set
                break
            }
        }
        guard let set = selectedSet else{return}
        var selectedCard : Card?
        for card in set.cards{
            if card.id == Int(cardId){
                selectedCard = card
            }
        }
        guard let card = selectedCard else {return}
        response.actionIdentifier == "knownAction" ? changePoints(card, right: true) : changePoints(card, right: false)
        completionHandler()
    }
}

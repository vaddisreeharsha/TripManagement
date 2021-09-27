//
//  AppDelegate.swift
//  TripManagement
//
//  Created by Virtual Dusk  on 23/09/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    var repeatingTimer : RepeatingTimer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.isTripStarted){
            setUpRepeatingTimer()
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        print("applicationDidEnterBackground")
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.isTripStarted){
            self.setUpRepeatingTimer()
            bgTask = application.beginBackgroundTask(expirationHandler: {
                self.endBackground()
            })
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Application will Enter fore ground")
    }
    
    //MARK: - Helper Methods
    func setUpRepeatingTimer(){
        if let timer = self.repeatingTimer{
            timer.suspend()
            self.repeatingTimer = nil
        }
        self.repeatingTimer = RepeatingTimer(timeInterval: 5)
        self.repeatingTimer?.eventHandler = {
            print("setUpRepeatingTimer method \(Date())")
            let loc = UserLocationManger.shared
            loc.startUpdateLocationManager()
        }
        self.repeatingTimer?.resume()
    }
    
    
    func endBackground() {
        if let timer = self.repeatingTimer{
            timer.suspend()
            self.repeatingTimer = nil
        }
        PersistentStorage.shared.saveContext()
        
        UIApplication.shared.endBackgroundTask(bgTask)
        bgTask = UIBackgroundTaskIdentifier.invalid
        print("endBackgroud Callback Method Fired!")
    }
}


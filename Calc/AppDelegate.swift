//
//  AppDelegate.swift
//  Calc
//
//  Created by Evgeniy Kolesin on 14.04.16.
//  Copyright © 2016 Evgeniy Kolesin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        if shortcutItem.type == "com.evgeniykolesin.calc.openCalc" {
            let vc = UIStoryboard(name: "Main", bundle: nil)
            let calc = vc.instantiateViewController(withIdentifier: "CalcVC") as! CalcVC
            self.window?.rootViewController?.present(calc, animated: true, completion: nil)
        }
        else if shortcutItem.type == "com.evgeniykolesin.calc.openPhoto" {
            let vc1 = UIStoryboard(name: "Main", bundle: nil)
            let photo = vc1.instantiateViewController(withIdentifier: "PhotoVC") as! PhotoVC
            self.window?.rootViewController?.present(photo, animated: true, completion: nil)
        }
        else if shortcutItem.type == "com.evgeniykolesin.calc.openCam" {
            let vc2 = UIStoryboard(name: "Main", bundle: nil)
            let cam = vc2.instantiateViewController(withIdentifier: "CameraVC") as! CameraVC
            self.window?.rootViewController?.present(cam, animated: true, completion: nil)
        }
    }
}

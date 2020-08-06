//
//  AppDelegate.swift
//  MovieHub
//
//  Created by Arthur Luiz Lara Quites
//  Copyright © 2020 Arthur Luiz Lara Quites. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            guard let windowU = self.window else {
                return false
            }
            
            // start the custom controller, good for specifiend behaviors without touching the UIViewController directly
            let nav1 = CustomNavigationController(rootViewController: MoviesViewController())
            
            // if one desire to use tabbar navigation, uncomment these lines below and use as follows:
            //let tab = CustomTabBarController()
            //tab.viewControllers = [nav1]
            //nav1.tabBarItem.title = "Title"
            //windowU.rootViewController = tab
            
            // set the rootviewcontroller to be the one customized and start it 
            windowU.rootViewController = nav1
            windowU.makeKeyAndVisible()
            
            return true
        }
    //MARK: -

        func applicationWillResignActive(_ application: UIApplication) {
        }

        func applicationDidEnterBackground(_ application: UIApplication) {

        }

        func applicationWillEnterForeground(_ application: UIApplication) {
        }

        func applicationDidBecomeActive(_ application: UIApplication) {
        }
        
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        }

        func applicationWillTerminate(_ application: UIApplication) {
        }

}


//
//  AppDelegate.swift
//  SDLProjectionDemo
//
//  Created by Yuan on 2018/5/22.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ProxyManagerDelegate {
    var window: UIWindow?
    var rootViewController: UINavigationController!
    
    var fordWindowSize = CGSize.zero
    var fordWindowInsets = UIEdgeInsets.zero
    var hasConnectedFord = false
    var becomeActiveShouldResumeWindow = false
    
    var stopVideoSessionTimer: Timer?
    var startVideoSessionTimer: Timer?
    var resumeWindowTimer: Timer?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let frame = UIScreen.main.bounds;
        let window = UIWindow.init(frame: frame)
       
        let caqVc = ProjectionCAQController.init(nibName: nil, bundle: nil)
        let vhaVc = ProjectionVHAController.init(nibName: nil, bundle: nil)
        let webVc = ProjectionWebController.init(nibName: nil, bundle: nil)
        
        caqVc.view.tag = 1000
        vhaVc.view.tag = 2000
        webVc.view.tag = 3000
        
        window.rootViewController = caqVc
        window.rootViewController?.addChildViewController(vhaVc)
        window.rootViewController?.addChildViewController(webVc)
        window.rootViewController?.view.addSubview(vhaVc.view)
        window.rootViewController?.view.addSubview(webVc.view)
        
        vhaVc.view.isHidden = true
        webVc.view.isHidden = true
        
        window.rootViewController?.view.bringSubview(toFront: caqVc.view)
        
        window.makeKeyAndVisible()
        self.window = window
        
        let manager = ProxyManager.sharedInstance
        manager.delegate = self
       
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        let manager = ProxyManager.sharedInstance
        manager.isBackgroundStated = true
        self.stopVideoSessionTimer?.invalidate()
        self.stopVideoSessionTimer = nil
        
        self.startVideoSessionTimer?.invalidate()
        self.startVideoSessionTimer = nil
        
        self.resumeWindowTimer?.invalidate()
        self.resumeWindowTimer = nil
        
        ProxyManager.sharedInstance.sdlManager.stop()
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
        
        let manager = ProxyManager.sharedInstance
        manager.isBackgroundStated = false
        
        if manager.connected {
            self.stopVideoSessionTimer = Timer.scheduledTimer(timeInterval: 0.5, target: manager, selector: #selector(manager.stopVideoSession), userInfo: nil, repeats: false)
            self.startVideoSessionTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.onDidconnnectFord), userInfo: nil, repeats: false)
        }  
        manager.startConnect()
        if self.becomeActiveShouldResumeWindow {
            self.becomeActiveShouldResumeWindow = false
            self.resumeWindowTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.onDidconnnectFord), userInfo: nil, repeats: false)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

}

























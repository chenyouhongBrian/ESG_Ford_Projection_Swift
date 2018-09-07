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
    var rootViewController: UIViewController!
    
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
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let CAQcontroller = storyboard.instantiateViewController(withIdentifier: "VCTest")
        
        let caqVc = CAQcontroller
        let vhaVc = ProjectionVHAController.init(nibName: nil, bundle: nil)
        let webVc = ProjectionWebController.init(nibName: nil, bundle: nil)
        
        caqVc.view.tag = 1000
        vhaVc.view.tag = 2000
        webVc.view.tag = 3000
        
        self.rootViewController = caqVc
        window.rootViewController = self.rootViewController
        
        window.rootViewController?.addChildViewController(vhaVc)
        window.rootViewController?.addChildViewController(webVc)
        window.rootViewController?.view.addSubview(vhaVc.view)
        window.rootViewController?.view.addSubview(webVc.view)
        
        vhaVc.view.isHidden = true
        webVc.view.isHidden = true
        
        window.rootViewController?.view.bringSubview(toFront: caqVc.view)
        
        window.makeKeyAndVisible()
        self.window = window
        
      //  let manager = ProxyManager.sharedInstance
      //  manager.delegate = self
       
        print("11-------------------------------------didFinishLaunchingWithOptions)");
        
       // IFlySetting.setLogFile(rawValue: -1)
        IFlySetting.showLogcat(true)
        
//        var mypaths:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask,true)
        
        let appID = "5b600f0c"
        let initString = "appid=\(appID)"
        IFlySpeechUtility.createUtility(initString)
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//        let manager = ProxyManager.sharedInstance
//        manager.isBackgroundStated = true
        self.stopVideoSessionTimer?.invalidate()
        self.stopVideoSessionTimer = nil
        
        self.startVideoSessionTimer?.invalidate()
        self.startVideoSessionTimer = nil
        
        self.resumeWindowTimer?.invalidate()
        self.resumeWindowTimer = nil
        
   //     ProxyManager.sharedInstance.sdlManager.stop()
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
        print("12-------------------------------------applicationDidBecomeActive)");
         
//        let manager = ProxyManager.sharedInstance
//        manager.isBackgroundStated = false
        
//        if manager.connected {
//             print("14-------------------------------------manager.startVideoSession)");
//            self.stopVideoSessionTimer = Timer.scheduledTimer(timeInterval: 1, target: manager, selector: #selector(manager.stopVideoSession), userInfo: nil, repeats: false)
//           
//            self.startVideoSessionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(manager.startVideoSession), userInfo: nil, repeats: false)
//        }  
//        manager.startConnect()
//        if self.becomeActiveShouldResumeWindow {
//             print("16-------------------------------------becomeActiveShouldResumeWindow)");
//            
//            self.becomeActiveShouldResumeWindow = false
//            self.resumeWindowTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onDisconnectFord), userInfo: nil, repeats: false)
//        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //讯飞
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        IFlySpeechUtility.getUtility().handleOpen(url)
        return true
    }
     
}

























//
//  AppDelegate+Extension.swift
//  SDLProjectionDemo
//
//  Created by Yuan on 2018/5/24.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import Foundation
import MapKit

extension AppDelegate{
    @objc func onConnectFord() {
        //保持屏幕常量
        UIApplication.shared.isIdleTimerDisabled = true
        let orientation = UIApplication.shared.statusBarOrientation
        if (orientation != UIInterfaceOrientation.landscapeRight) {
        }
        self.changeWindowFrame()
    }
    
    @objc func onDisconnectFord() {
        UIApplication.shared.isIdleTimerDisabled = false
        let manager = ProxyManager.sharedInstance
        manager.stopCapture()
         self.resumeWindowFrame()
    }
    
    func changeScreenSize() {
        let manager = ProxyManager.sharedInstance
        if manager.connected {
            self.onConnectFord()
        } else {
            if manager.isBackgroundStated {
                self.becomeActiveShouldResumeWindow = true
            }else{
                self.onDisconnectFord()
            }
        }
    }
    
    func changeWindowFrame() {
        let manager = ProxyManager.sharedInstance
        let scale = 2.5 / 3.0
        if manager.screenWidth > 0 && manager.screenWidth < 2000 && manager.screenHeight > 0 && manager.screenHeight < 2000 {
            self.fordWindowSize = CGSize(width: Double(manager.screenWidth), height: Double(manager.screenHeight))
        }else {
            self.fordWindowSize = CGSize(width: 800.0, height: 348.0)
        }
        let width = Double(self.fordWindowSize.width) * scale
        let height = Double(self.fordWindowSize.height) * scale
        
        let frame = CGRect(x: 50.0, y: 50.0, width: width, height: height)
        self.window?.frame = frame
        self.window?.setNeedsUpdateConstraints()
        
        self.rootViewController.view.setNeedsUpdateConstraints()
        self.rootViewController.view.setNeedsLayout()
        manager.startCapture()
    }
    
    func resumeWindowFrame() {
        let screen = UIScreen.main
        self.window?.transform = (self.window?.transform.scaledBy(x: 1.0, y: 1.0))!
        self.window?.frame = screen.bounds
        self.window?.setNeedsLayout()
        
        let view = self.rootViewController.view
        view?.setNeedsUpdateConstraints()
        view?.setNeedsLayout()
        
        let name = NSNotification.Name(rawValue: "SDLManagerConnectStateChangedNotification")
        NotificationCenter.default.post(name: name, object: self)
    }
    
    static var kFirstTouchEvent: SDLOnTouchEvent? = nil
    static var kSecondTouchEvent: SDLOnTouchEvent? = nil
    
    func sdlManager(_ sdlManager: ProxyManager, didReceived touchEvent: SDLOnTouchEvent) {
        if let event = touchEvent.event.firstObject as? SDLTouchEvent {
        let touchEventId = event.touchEventId.intValue
            switch touchEventId {
            case 0:
                AppDelegate.kFirstTouchEvent = touchEvent
            default:
                AppDelegate.kSecondTouchEvent = touchEvent
            }
        }
        var touchEvents = [SDLOnTouchEvent]()
        if let first = AppDelegate.kFirstTouchEvent{
            touchEvents.append(first)
        }
        
        if let second = AppDelegate.kSecondTouchEvent {
            touchEvents.append(second)
        }
        
        if touchEvents.count > 0 {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let window = appDelegate.window {
               window.handleSDLOntouchEvents(touchEvents: touchEvents, fordWindowSize: self.fordWindowSize)
                
//                window.handleSDLOnTouchEvents(touchEvents: touchEvents, fordWindowSize: self.fordWindowSize)
            }
        }
    }
    
    func sdlManager(_ sdlManager: ProxyManager, didUpdated location: CLLocation) {
        
    }
    
    func sdlManager(_ sdlManager: ProxyManager, didSelect command: Int) {
        
    }
    
    func sdlManager(_ sdlManager: ProxyManager, didConnected: Bool) {
        self.hasConnectedFord = didConnected
        self.changeScreenSize()
    }
    
    
    
    
    
    
    
    
}

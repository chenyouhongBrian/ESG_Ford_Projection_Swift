//
//  UIView+Extension.swift
//  SDLProjectionDemo
//
//  Created by Yuan on 2018/6/12.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import Foundation

protocol SDLTouchProtocol {
    func touchesBegan(touches: [NSValue], fordTouchEvents:[SDLOnTouchEvent])
    func touchesMoved(touches: [NSValue], fordTouchEvents:[SDLOnTouchEvent])
    func touchesEnded(touches: [NSValue], fordTouchEvents:[SDLOnTouchEvent])
    func touchesCancelled(touches:[NSValue], fordTouchEvents:[SDLOnTouchEvent])
}

extension UIView :SDLTouchProtocol {
    func touchesBegan(touches: [NSValue], fordTouchEvents:[SDLOnTouchEvent]) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
        let window = appDelegate.window,
        let point = touches.first?.cgPointValue,
        let te = fordTouchEvents.first,
        let e = te.event.firstObject as? SDLTouchEvent {
            HJFakeMetaTouch.fakeTouchId(e.touchEventId.intValue + 10, at: point, with: .began, window: window)
            //常驻子线程，保持子线程一直处理事件
            //为了保证线程长期运转，可以在子线程中加入RunLoop，并且给Runloop设置item，防止Runloop自动退出。
            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 1.0, false)
        }
    }
    
    func touchesMoved(touches: [NSValue], fordTouchEvents: [SDLOnTouchEvent]) {
       if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
        let window = appDelegate.window,
        let point = touches.first?.cgPointValue,
        let te = fordTouchEvents.first,
        let e = te.event.firstObject as? SDLTouchEvent {
        HJFakeMetaTouch.fakeTouchId(e.touchEventId.intValue + 10, at: point, with:.moved, window: window)
        CFRunLoopRunInMode(CFRunLoopMode.commonModes, 1.0, false)
        }
    }
    
    func touchesEnded(touches: [NSValue], fordTouchEvents: [SDLOnTouchEvent]){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
        let window = appDelegate.window,
        let point = touches.first?.cgPointValue,
        let te = fordTouchEvents.first,
        let e = te.event.firstObject as? SDLTouchEvent {
        HJFakeMetaTouch.fakeTouchId(e.touchEventId.intValue + 10, at: point, with: .ended, window: window)
        CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 1.0, false)
        }
    }
    
    func touchesCancelled(touches: [NSValue], fordTouchEvents: [SDLOnTouchEvent]) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
        let window = appDelegate.window,
        let point = touches.first?.cgPointValue,
        let te = fordTouchEvents.first,
            let e = te.event.firstObject as? SDLTouchEvent {
           HJFakeMetaTouch.fakeTouchId(e.touchEventId.intValue + 10, at: point, with: .cancelled, window: window)
        }
    }
}































//
//  UIWindow+Extension.swift
//  SDLProjectionDemo
//
//  Created by Yuan on 2018/6/12.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import Foundation

extension UIWindow {
    func handleSDLOntouchEvents(touchEvents: [SDLOnTouchEvent],fordWindowSize:CGSize) {
        var beginTouches = [NSValue]()
        var moveTouches = [NSValue]()
        var endTouches = [NSValue]()
        var cancelTouches = [NSValue]()
        
        var beginEvents = [SDLOnTouchEvent]()
        var moveEvents = [SDLOnTouchEvent]()
        var endEvents = [SDLOnTouchEvent]()
        var cancelEvents = [SDLOnTouchEvent]()
        
        for te in touchEvents {
             if let e = te.event.firstObject as? SDLTouchEvent, let touchType = te.type, let c = e.coord.firstObject as? SDLTouchCoord {
                let point = self.windowPoint(touchCoord: c, fordWindowSize: fordWindowSize)
                let value = NSValue(cgPoint: point)
                if touchType.isEqual(to:SDLTouchType.begin()) {
                    beginTouches.append(value)
                    beginEvents.append(te)
                }
                else if touchType.isEqual(to: SDLTouchType.move()){
                    moveTouches.append(value)
                    moveEvents.append(te)
                }
                else if touchType.isEqual(to: SDLTouchType.move()){
                    moveTouches.append(value)
                    moveEvents.append(te)
                }
                else if touchType.isEqual(to: SDLTouchType.end()){
                    endTouches.append(value)
                    endEvents.append(te)
                }
                else if touchType.isEqual(to: SDLTouchType.cancel()){
                    cancelTouches.append(value)
                    cancelEvents.append(te)
                }
            }
        }
        
        var touches = [NSValue]()
        touches.append(contentsOf: beginTouches)
        touches.append(contentsOf: moveTouches)
        touches.append(contentsOf: endTouches)
        touches.append(contentsOf: moveTouches)
        
        for t in touches {
            let point = t.cgPointValue
            if let view = self.hitTest(point, with: nil){
            if beginTouches.count > 0 {
            view.touchesBegan(touches: beginTouches, fordTouchEvents: beginEvents)
                }
            else if moveTouches.count > 0 {
                view.touchesMoved(touches: moveTouches, fordTouchEvents: moveEvents)
                }
            else if endTouches.count > 0 {
                view.touchesEnded(touches: endTouches, fordTouchEvents: endEvents)
                }
            else if cancelEvents.count > 0 {
                view.touchesCancelled(touches: cancelTouches, fordTouchEvents: cancelEvents)
                }
            }
            break
        }
    }
    
    func windowPoint(touchCoord:SDLTouchCoord, fordWindowSize:CGSize) -> CGPoint {
        var point = CGPoint.zero
        let viewSize = self.bounds.size
        
        let x: CGFloat = CGFloat(touchCoord.x.floatValue)
        let y: CGFloat = CGFloat(touchCoord.y.floatValue)
        
        let rx = x / fordWindowSize.width
        let ry = y / fordWindowSize.height
        point = CGPoint(x: rx * viewSize.width, y: ry * viewSize.height)
        
        return point
    }
}























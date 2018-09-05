//
//  Tool.swift
//  SDLProjectionDemo
//
//  Created by Dandy.Guan on 2018/7/11.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import UIKit


class Tool: NSObject {

   class func warningContentsByCode(number: String) -> Array<String> {
        let path = Bundle.main.path(forResource: "WarningContent",ofType:"plist")
        let url = URL(fileURLWithPath: path!)
        let dic = NSDictionary(contentsOf: url) as? Dictionary<String,AnyObject>
        print("warningContentByCode ------- \(number)")
        let key = "600\(number)"
    
        print("warningContents ------\(dic)")
        let arr : Array<String> = dic![key] as! Array
        
        let engine = ["E17","E26"]
        let exhaust = ["E07","E08","F26"]
        let fuel = ["E10","E13","E20"]
        let steer = ["F29"]
        let tire = ["E27","E28","E29"]
        
        var warningArr : Array<String> = []
        
        if engine.contains(number) {
            warningArr.append("engine")
        }else if exhaust.contains(number) {
            warningArr.append("exhaust")
        }else if fuel.contains(number) {
            warningArr.append("fuel")
        }else if steer.contains(number) {
            warningArr.append("steer")
        }else if tire.contains(number) {
            warningArr.append("tire")
        }
        
        //警告标题
        warningArr.append(arr[1])
        //警告图标
        warningArr.append(arr[4])
        //警告内容
        warningArr.append(arr[3])
        
        return warningArr
    }

 
   class func getLabelHeigh(labelStr:String, font:UIFont, size:CGSize) -> CGFloat {
        let text : NSString = labelStr as NSString
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let textSize = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as?[NSAttributedStringKey : Any], context: nil).size
    
    print("contentLabelHeight --- \(textSize.height)")
       return textSize.height
    }
    
    
        
        
        
        
   
}









































































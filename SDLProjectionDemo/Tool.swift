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
    
    class func getBGColorByPMValue(_ pmValue: Int) -> UIColor {
        var color = UIColor()
        
        if pmValue <= 35 {
            color = UIColor(red: 143 / 255.0, green: 208 / 255.0, blue: 188 / 255.0, alpha: 1.0)
            
        } else if pmValue <= 75 {
            color = UIColor(red: 139 / 255.0, green: 194 / 255.0, blue: 74 / 255.0, alpha: 1.0)
            
        } else if pmValue <= 115 {
            color = UIColor(red: 223 / 255.0, green: 196 / 255.0, blue: 45 / 255.0, alpha: 1.0)
            
        } else if pmValue <= 150 {
            color = UIColor(red: 151 / 255.0, green: 140 / 255.0, blue: 0 / 255.0, alpha: 1.0)
            
        } else if pmValue <= 250 {
            color = UIColor(red: 229 / 255.0, green: 57 / 255.0, blue: 55 / 255.0, alpha: 1.0)
            
        } else if pmValue <= 350 {
            color = UIColor(red: 97 / 255.0, green: 79 / 255.0, blue: 131 / 255.0, alpha: 1.0)
            
        } else {
            color = UIColor(red: 60 / 255.0, green: 60 / 255.0, blue: 52 / 255.0, alpha: 1.0)
        }
        return color
    }
    
    class func getNewColorWith(color: UIColor, andAlpha: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let newColor = UIColor(red: red, green: green, blue: blue, alpha: andAlpha)
        return newColor
    }
    
    
        
        
        
        
   
}









































































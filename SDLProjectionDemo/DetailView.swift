//
//  DetailView.swift
//  SDLProjectionDemo
//
//  Created by Dandy.Guan on 2018/8/13.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import UIKit

let Screew = UIScreen.main.bounds.size.width

class DetailView: UIView {

    var image : UIImageView?
    var titleLabel : UILabel?
    var contentLabel : UILabel?
    var lineView : UIView?
    
    func setUpView() {
        image = UIImageView.init(frame: CGRect(x: 5, y: 5, width: Screew / 10, height: Screew / 10))
        lineView = UIView.init(frame: CGRect(x: 5, y: 10 + Screew / 10 , width: Screew - 10 - Screew / 10, height: 1))
        lineView?.backgroundColor = UIColor.init(red: 238/255.0, green: 191/255.0, blue: 45/255.0, alpha: 1)
        
        titleLabel = UILabel.init(frame: CGRect(x: 20 + Screew / 10, y: 5, width: Screew - Screew / 10 - 40, height: Screew / 10))
        let size : CGFloat = CGFloat(30 * Int(Screew / 10))
        titleLabel?.font = UIFont.systemFont(ofSize: size)
        titleLabel?.numberOfLines = 2
        titleLabel?.textColor = UIColor.init(red: 238/255.0, green: 191/255.0, blue: 45/255.0, alpha: 1)
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.adjustsFontSizeToFitWidth = true
        
        contentLabel = UILabel.init()
        let size2 : CGFloat = CGFloat(16 * Int(Screew / 10))
        contentLabel?.font = UIFont.systemFont(ofSize: size2)
        contentLabel?.numberOfLines = 0
//        contentLabel?.textColor =UIColor.white
//        contentLabel?.textAlignment = NSTextAlignment.left
//        
//        let contentHeigh : CGFloat = 
//        
    }
    
    

}

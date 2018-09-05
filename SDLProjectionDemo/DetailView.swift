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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = UIImageView.init(frame: CGRect(x: 5, y: 5, width: Screew / 10, height: Screew / 10))
        lineView = UIView.init(frame: CGRect(x: 5, y: 10 + Screew / 10 , width: Screew - 10 - Screew / 10, height: 1))
        lineView?.backgroundColor = UIColor.init(red: 238/255.0, green: 191/255.0, blue: 45/255.0, alpha: 1)
        
        titleLabel = UILabel.init(frame: CGRect(x: 20 + Screew / 10, y: 5, width: Screew - Screew / 10 - 40, height: Screew / 10))
        contentLabel = UILabel.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
   public func setUpView() {
    
        let size : CGFloat = 30
        titleLabel?.font = UIFont.systemFont(ofSize: size)
        titleLabel?.numberOfLines = 2
        titleLabel?.textColor = UIColor.init(red: 238/255.0, green: 191/255.0, blue: 45/255.0, alpha: 1)
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.adjustsFontSizeToFitWidth = true
        
    
        let size2 : CGFloat = 16
    print("contentLableFont \(size2)")
    let font : UIFont = UIFont.systemFont(ofSize: size2)
        contentLabel?.font = font
        contentLabel?.numberOfLines = 0
        contentLabel?.textColor = UIColor.white
        contentLabel?.textAlignment = NSTextAlignment.left
    
   
    
        let contentHeigh : CGFloat = Tool.getLabelHeigh(labelStr: (contentLabel?.text)!, font: font, size: CGSize(width: Screew - 80, height: 100))
    var height : CGFloat = 0
    if contentHeigh < 90 {
        height = 90
    }else{
        height = contentHeigh
    }
    
        contentLabel?.frame = CGRect(x: 5, y: Screew / 10 + 21, width: Screew - Screew / 10 , height: height)
        
        self.addSubview(image!)
        self.addSubview(titleLabel!)
        self.addSubview(contentLabel!)
        self.addSubview(lineView!)
    }

}



















//
//  PScrollView.swift
//  SDLProjectionDemo
//
//  Created by Dandy.Guan on 2018/9/3.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import UIKit

class PScrollView: UIScrollView {

    override func layoutSubviews() {
        super.layoutSubviews()
        for view : UIView in self.subviews {
            if view.isKind(of: UIButton.self) {
                var rect : CGRect = view.frame
                rect.origin.y = 200 + self.contentOffset.y
                view.frame = rect
            }
        }
    }

}

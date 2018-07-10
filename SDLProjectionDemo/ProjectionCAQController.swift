//
//  ProjectionCAQController.swift
//  SDLProjectionDemo
//
//  Created by Dandy.Guan on 2018/6/20.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import UIKit

class ProjectionCAQController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func vhaButtonAction(_ sender: Any) {
        let window = UIApplication.shared.keyWindow
        let windowView = window?.rootViewController?.view
        let vhaView = windowView?.viewWithTag(2000)
        let webView = windowView?.viewWithTag(3000)
        vhaView?.isHidden = false
        webView?.isHidden = true
    }
    
    @IBAction func appButtonAction(_ sender: Any) {
        let window = UIApplication.shared.keyWindow
        let windowView = window?.rootViewController?.view
        let vhaView = windowView?.viewWithTag(2000)
        let webView = windowView?.viewWithTag(3000)
        vhaView?.isHidden = true
        webView?.isHidden = false
    }
    


}

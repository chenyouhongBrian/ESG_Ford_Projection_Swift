//
//  ProjectionWebController.swift
//  SDLProjectionDemo
//
//  Created by Dandy.Guan on 2018/7/5.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import UIKit

class ProjectionWebController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func caqButtonAction(_ sender: Any) {
        let window = UIApplication.shared.keyWindow
        let windowView = window?.rootViewController?.view
        let vhaView = windowView?.viewWithTag(2000)
        let webView = windowView?.viewWithTag(3000)
        vhaView?.isHidden = true
        webView?.isHidden = true
    }
    
    
    @IBAction func vhaButtonAction(_ sender: Any) {
        let window = UIApplication.shared.keyWindow
        let windowView = window?.rootViewController?.view
        let vhaView = windowView?.viewWithTag(2000)
        let webView = windowView?.viewWithTag(3000)
        vhaView?.isHidden = false
        webView?.isHidden = true
    }
    

}








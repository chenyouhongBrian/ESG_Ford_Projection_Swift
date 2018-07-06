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
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func vhaButtonAction(_ sender: Any) {
        
        
    }
    

}








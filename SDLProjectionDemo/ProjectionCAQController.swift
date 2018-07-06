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
        let vc = ProjectionVHAController.init(nibName: nil, bundle: nil)
        self.present(vc, animated: false, completion: nil)
        
        
    }
    
    @IBAction func appButtonAction(_ sender: Any) {
        
        
        let vc = ProjectionWebController.init(nibName: nil, bundle: nil)
        self.present(vc, animated: false, completion: nil)
        
        
    }
    


}

//
//  ProjectionVHAController.swift
//  SDLProjectionDemo
//
//  Created by Dandy.Guan on 2018/7/5.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import UIKit

class ProjectionVHAController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
       
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    @IBAction func caqButtonAction(_ sender: Any) {
        //self.dismiss(animated: false, completion: nil)
         self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func webButtionAction(_ sender: Any) {
        let vc = ProjectionWebController.init(nibName: nil, bundle: nil)
        self.present(vc, animated: false, completion: nil)
        
    }
    

}















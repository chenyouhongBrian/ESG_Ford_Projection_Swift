//
//  ProjectionVHAController.swift
//  SDLProjectionDemo
//
//  Created by Dandy.Guan on 2018/7/5.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import UIKit

class ProjectionVHAController: UIViewController {

    @IBOutlet weak var alertButton: UIButton!
    
    @IBOutlet weak var tireImage1: UIImageView!
    
    @IBOutlet weak var tireImage2: UIImageView!
    
    @IBOutlet weak var tireImage3: UIImageView!
    
    @IBOutlet weak var tireImage4: UIImageView!
    
    @IBOutlet weak var engineImage: UIImageView!
    
    @IBOutlet weak var fuelImage: UIImageView!
    
    @IBOutlet weak var engineAlert: UIButton!
    
    @IBOutlet weak var fuelAlert: UIButton!
    
    @IBOutlet weak var steerAlert: UIButton!
    
    @IBOutlet weak var tireAlert: UIButton!
    
    @IBOutlet weak var exhaustAlert: UIButton!
    
    var engineArray: NSMutableArray?
    var exhaustArray: NSMutableArray?
    var fuelArray: NSMutableArray?
    var steerArray: NSMutableArray?
    var tireArray: NSMutableArray?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
    }
    
    func setUpVHAProjectionViewByArray(_ array: NSArray)  {
        let engine = ["E17","E26"]
        let exhaust = ["E07","E08","F26"];
        let fuel = ["E10","E13","E20"];
        let steer = ["F29"];
        let tire = ["E27","E28","E29"];
        
        engineAlert.isHidden = true
        exhaustAlert.isHidden = true
        fuelAlert.isHidden = true
        steerAlert.isHidden = true
        tireAlert.isHidden = true
        
        engineImage.isHidden = true
        tireImage1.isHidden = true
        tireImage2.isHidden = true
        tireImage3.isHidden = true
        tireImage4.isHidden = true
        fuelImage.isHidden = true
        
        alertButton.setTitle("Alert \(array.count)", for: UIControlState.normal)
        
        for number in array {
            if engine.contains(number as! String) {
                engineAlert.isHidden = false
                engineImage.isHidden = false
                engineArray?.add(number)
            }
            
            if exhaust.contains(number as! String) {
                exhaustAlert.isHidden = false
                exhaustArray?.add(number)
            }
            
            if fuel.contains(number as! String) {
                fuelAlert.isHidden = false
                fuelImage.isHidden = false
                fuelArray?.add(number)
            }
            
            if steer.contains(number as! String) {
                steerAlert.isHidden = false
                steerArray?.add(number)
            }
            
            if tire.contains(number as! String) {
                view.bringSubview(toFront: tireAlert)
                tireImage1.isHidden = false
                tireImage2.isHidden = false
                tireImage3.isHidden = false
                tireImage4.isHidden = false
                tireAlert.isHidden = false
                tireArray?.add(number)
            }
        }
    }
    
    @IBAction func caqButtonAction(_ sender: Any) {
        //self.dismiss(animated: false, completion: nil)
        // self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
         let window = UIApplication.shared.keyWindow
         let windowView = window?.rootViewController?.view
         let vhaView = windowView?.viewWithTag(2000)
         let webView = windowView?.viewWithTag(3000)
        vhaView?.isHidden = true
        webView?.isHidden = true
    }
    
    @IBAction func webButtionAction(_ sender: Any) {
        let window = UIApplication.shared.keyWindow
        let windowView = window?.rootViewController?.view
        let vhaView = windowView?.viewWithTag(2000)
        let webView = windowView?.viewWithTag(3000)
        vhaView?.isHidden = true
        webView?.isHidden = false
    }
    
    @IBAction func alertButtonAction(_ sender: Any) {
        
        
        
    }
   
    @IBAction func callDealerAction(_ sender: Any) {
        engineArray?.removeAllObjects()
        exhaustArray?.removeAllObjects()
        fuelArray?.removeAllObjects()
        steerArray?.removeAllObjects()
        tireArray?.removeAllObjects()
  
       
        
        
        
        
        
        
    }
    
    @IBAction func randomAction(_ sender: Any) {
        
        
    }
    
    @IBAction func engineAlertAction(_ sender: Any) {
        
    }
    
    @IBAction func fuelAlertAction(_ sender: Any) {
        
    }
    
    @IBAction func steerAlertAction(_ sender: Any) {
        
        
    }
    
    @IBAction func tireAlertAction(_ sender: Any) {
     
        
    }
    
    @IBAction func exhaustAlertAction(_ sender: Any) {
     
        
    }
    
    
    
    
}















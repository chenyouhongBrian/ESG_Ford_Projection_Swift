//
//  VCTest.swift
//  SDLProjectionDemo
//
//  Created by Ford-BrianChen on 2018/9/5.
//  Copyright © 2018年 YuanWei. All rights reserved.
//

import UIKit

class VCTest: UIViewController {
    
    @IBOutlet weak var warningLabel: UILabel!
   
    @IBOutlet weak var cabinLabel: UILabel!
    
    @IBOutlet weak var exteriorLabel: UILabel!
    
    @IBOutlet weak var exteriorTitleLabel: UILabel!
    
    
    @IBOutlet weak var bgWhitePink: UIView!
    
    @IBOutlet weak var bgPink: UIView!
    
    @IBOutlet weak var pmBgPink: UIView!
    
    
    var cabinPMValue = 150
    var exteriorPMValue = 150
    
    var PMChangingTimer: Timer?
    var grandientLayer = CAGradientLayer()
    
    let speechSynth = IFlySpeechSynthesizer.sharedInstance()
    var firstSame = true
    var firstExteriorGreater = true
    var firstCabinGreater = true
    
    var testView: UIView? = UIView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AVAudioSession.sharedInstance().requestRecordPermission({_ in print("提早开启权限")})
        initSpeechSynth()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(testView!)
        testView!.tag = 5000
        setUpView()
        PMChangingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.refreshPMValue()
        }
    }
    
    func setUpView() {
        cabinLabel.text = String(cabinPMValue)
        exteriorLabel.text = String(exteriorPMValue)
        warningLabel.textColor = UIColor.black
        warningLabel.text = "室內外空气质量一致"
        
        pmBgPink.layer.cornerRadius = 80.0
        let bounds = bgWhitePink.bounds
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: [.topRight, .bottomRight ] , cornerRadii: CGSize(width: 165, height: 165))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        bgWhitePink.layer.addSublayer(maskLayer)
        bgWhitePink.layer.mask = maskLayer
        
        let bounds2 = bgPink.bounds
        let maskPath2 = UIBezierPath.init(roundedRect: bounds2, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 165, height: 165))
        let maskLayer2 = CAShapeLayer()
        maskLayer2.frame = bounds2
        maskLayer2.path = maskPath2.cgPath
        bgPink.layer.addSublayer(maskLayer2)
        bgPink.layer.mask = maskLayer2
    }
    
    func refreshPMValue() {
        if cabinPMValue == 0 {
            cabinPMValue = 160
            exteriorPMValue = 150
            
        } else if cabinPMValue <= 150 {
            cabinPMValue -= 10
            exteriorPMValue += 10
            
        } else if cabinPMValue == 300 {
            cabinPMValue = 150
            exteriorPMValue = 150
            
        } else if cabinPMValue > 150 {
            cabinPMValue += 10
            exteriorPMValue -= 10
        }
        
        if let testView = testView {
            if !testView.isHidden {
                setUpPMView()
            }
        }
        
    }
    
    func setUpPMView() {
        cabinLabel.text = String(cabinPMValue)
        exteriorLabel.text = String(exteriorPMValue)
        
        if cabinPMValue == exteriorPMValue {
            if firstSame {
                speechSynth?.startSpeaking("室内外空气质量一致")
                firstSame = false
                firstCabinGreater = true
                firstExteriorGreater = true
            }
            warningLabel.text = "室內外空气质量一致"
            
        } else if cabinPMValue > exteriorPMValue {
            if firstCabinGreater {
                speechSynth?.startSpeaking("建议更换滤芯")
                firstCabinGreater = false
                firstSame = true
                firstExteriorGreater = true
            }
            warningLabel.text = "建议更换滤芯"
            
        } else {
            if firstExteriorGreater {
                speechSynth?.startSpeaking("室外空气污染大于室内")
                firstExteriorGreater = false
                firstSame = true
                firstCabinGreater = true
            }
            warningLabel.text = "室外空气污染大于室内"
        }
        
        let exteriorColor = Tool.getBGColorByPMValue(exteriorPMValue)
        let cabinColor3 = Tool.getBGColorByPMValue(cabinPMValue)
        let cabinColor2 = Tool.getNewColorWith(color: cabinColor3, andAlpha: 0.25)
        let cabinColor1 = Tool.getNewColorWith(color: cabinColor3, andAlpha: 0.21)
        let exteriorColor2 = Tool.getNewColorWith(color: exteriorColor, andAlpha: 0.25)
        
        exteriorLabel.textColor = exteriorColor
        exteriorTitleLabel.textColor = exteriorColor
        
        pmBgPink.backgroundColor = cabinColor3
        bgWhitePink.backgroundColor = cabinColor1
        bgPink.backgroundColor = cabinColor2
        
        
        
        grandientLayer.colors = [exteriorColor2.cgColor, cabinColor2.cgColor]
        grandientLayer.locations = [0.4, 0.7]
        grandientLayer.startPoint = CGPoint(x: 0.3, y: 0)
        grandientLayer.endPoint = CGPoint(x: 0.8, y: 0)
        grandientLayer.frame = bgPink.frame
        
        bgPink.layer.insertSublayer(grandientLayer, below: warningLabel.layer)
        
    }
    
    func initSpeechSynth() {
        guard let synthizer = speechSynth else { return }
        synthizer.delegate = self
        
        synthizer.setParameter(IFlySpeechConstant.type_CLOUD(), forKey: IFlySpeechConstant.engine_TYPE())
        synthizer.setParameter("50", forKey: IFlySpeechConstant.volume())
        synthizer.setParameter(" xiaoyan ", forKey: IFlySpeechConstant.voice_NAME())
        synthizer.setParameter(" tts.pcm", forKey: IFlySpeechConstant.tts_AUDIO_PATH())
    }

    
    
    @IBAction func VHABtnPressed(_ sender: UIButton) {
        let window = UIApplication.shared.keyWindow
        let windowView = window?.rootViewController?.view
        let vhaView = windowView?.viewWithTag(2000)
        vhaView?.isHidden = false
        if let viewTag = testView {
            viewTag.isHidden = true
        }
    }
    
    
    
}


extension VCTest: IFlySpeechSynthesizerDelegate {
    func onCompleted(_ error: IFlySpeechError!) {
        print("synthizerError:\(error)" )
    }
    
    
}

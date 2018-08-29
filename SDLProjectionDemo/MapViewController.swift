//
//  MapViewController.swift
//  SDLProjectionDemo
//
//  Created by Dandy.Guan on 2018/8/15.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import UIKit

class MapViewController: UIViewController,IFlySpeechSynthesizerDelegate {
    
    //语音
    var iFlySpeechSynthesizer: IFlySpeechSynthesizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //语音合成
        //获取语音合成单例
        iFlySpeechSynthesizer = IFlySpeechSynthesizer.sharedInstance()
        iFlySpeechSynthesizer?.delegate = self
        //设置合成参数
        //设置在线工作方式
        // iFlySpeechSynthesizer?.setParameter(IFlySpeechConstant.type_CLOUD(), forKey: IFlySpeechConstant.engine_TYPE())
        iFlySpeechSynthesizer?.setParameter(IFlySpeechConstant.type_CLOUD()!, forKey: IFlySpeechConstant.engine_TYPE()!)
        //设置音量，取值范围 0~100
        let voice = "50"
        iFlySpeechSynthesizer?.setParameter(voice, forKey: IFlySpeechConstant.volume()!)
        //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
        let people = "xiaoyan"
        iFlySpeechSynthesizer?.setParameter(people, forKey: IFlySpeechConstant.voice_NAME()!)
        //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
        let format = "tts.pcm"
        iFlySpeechSynthesizer?.setParameter(format, forKey: IFlySpeechConstant.tts_AUDIO_PATH()!)
        
    //        //启动合成会话
    //        let text = "高德地图为你导航到最近维修地点"
    //        iFlySpeechSynthesizer?.startSpeaking(text)
        
    }
    
    deinit {
        iFlySpeechSynthesizer?.delegate = nil
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //IFlySpeechSynthesizerDelegate
    //合成开始
    func onSpeakBegin() {
        print("IFlySpeechSynthesizer__onSpeakBegin")
    }
    //合成结束
    func onCompleted(_ error: IFlySpeechError!) {
        print("IFlySpeechSynthesizer__onCompleted")
    }
    //合成缓冲进度
    func onBufferProgress(_ progress: Int32, message msg: String!) {
        
    }
    //合成播放进度
    func onSpeakProgress(_ progress: Int32, beginPos: Int32, endPos: Int32) {
        
    }

    
    
}







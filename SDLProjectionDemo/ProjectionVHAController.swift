//
//  ProjectionVHAController.swift
//  SDLProjectionDemo
//
//  Created by Dandy.Guan on 2018/7/5.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import UIKit

class ProjectionVHAController: UIViewController,IFlySpeechSynthesizerDelegate,IFlySpeechRecognizerDelegate {

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
    
    @IBOutlet weak var alertView: UIView!
    
    var engineArray: NSMutableArray?
    var exhaustArray: NSMutableArray?
    var fuelArray: NSMutableArray?
    var steerArray: NSMutableArray?
    var tireArray: NSMutableArray?
    
    var alertController: UIAlertController?
    var mapAlert: YHAlertView?
    
    //语音
    var iFlySpeechSynthesizer: IFlySpeechSynthesizer?
    //不带界面的识别对象
    var iFlySpeechRecognizer: IFlySpeechRecognizer?
    
    var whichSentence: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let string1 = "是"
        if string1.contains("是") {
            print("99999999999999999999999999999999999")
        }
        
        
        
        
        
        //模拟维修提示
        let alertArray = ["E17"]
        self.setUpVHAProjectionViewByArray(alertArray as NSArray)
  
        //横屏
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        
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
    
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
     
        
        
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
        engineArray?.removeAllObjects()
        exhaustArray?.removeAllObjects()
        fuelArray?.removeAllObjects()
        steerArray?.removeAllObjects()
        tireArray?.removeAllObjects()
        
        whichSentence = "1级"
        alertController = UIAlertController(title: "VHA", message: "是否到就近维修店进行维修", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "否", style: UIAlertActionStyle.default) { (cancelAction) in
           
            self.cancelAction()
         //   self.alertController?.dismiss(animated: true, completion: nil)
        }
        
        let okAction = UIAlertAction(title: "是", style: UIAlertActionStyle.default) { (okAction) in
//            self.alertController?.dismiss(animated: true, completion: nil)
//            let mapVC = MapViewController.init(nibName: "MapViewController", bundle: nil)
//
//            self.present(mapVC, animated: true, completi on: nil)
            self.okAction()
        }
        
        alertController?.addAction(cancelAction)
        alertController?.addAction(okAction)
        
        self.present(alertController!, animated: true, completion: nil)
        
        //获取语音合成单例
        iFlySpeechSynthesizer = IFlySpeechSynthesizer.sharedInstance()
        iFlySpeechSynthesizer?.delegate = self
        //启动合成会话
        let text = "发动机机油压力低,是否到就近维修店进行维修"
        iFlySpeechSynthesizer?.startSpeaking(text)

        self.initRecognizer()
        
        let string1 = "是"
        if string1.contains("是") {
            print("99999999999999999999999999999999999")
        }else {
            print("66666666666666666666666666666666666")
        }
        
    }
 
    func cancelAction() {
        alertController?.dismiss(animated: true, completion: nil)
        //停止录音
        iFlySpeechRecognizer?.cancel()
        iFlySpeechRecognizer?.stopListening()
    }
    func okAction() {
       
        
        self.initRecognizer()
        
        
        alertController?.dismiss(animated: true, completion: nil)
        
        whichSentence = "2级"
        //启动合成会话
        let text1 = "1.东昌路19号"
        let text2 = "2.陆家嘴22号"
        
        let text = "就近维修店有两家，请选择数字 \(text1) \(text2)"
        iFlySpeechSynthesizer?.startSpeaking(text)
        
        YHAlertView.show(title: "就近维修店有两家", message: "请选择", cancelButtonTitle: "取消", otherButtonTitles:text1,text2) { (alertV:YHAlertView, index:Int) in
            print("点击下标是:\(index)")
            
            //停止录音
            self.iFlySpeechRecognizer?.cancel()
            self.iFlySpeechRecognizer?.stopListening()
            
            
            switch index{
            case 1:
                //启动合成会话
                let text = "高德地图为你导航到东昌路19号"
                self.iFlySpeechSynthesizer?.startSpeaking(text)
                let mapVC = MapViewController.init(nibName: "MapViewController", bundle: nil)
                self.present(mapVC, animated: true, completion: nil)
                
                break
            case 2:
                //启动合成会话
                let text = "高德地图为你导航到陆家嘴22号"
                self.iFlySpeechSynthesizer?.startSpeaking(text)
                let mapVC = MapViewController.init(nibName: "MapViewController", bundle: nil)
                self.present(mapVC, animated: true, completion: nil)
         
                break
            default:
                break
            }
            
        }
        
        
       
    
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
    
    override var shouldAutorotate:Bool{
    
    return false
    
    }
    
    @IBAction func alertActionYes(_ sender: Any) {
        
    }
    
    @IBAction func alertActionNo(_ sender: Any) {
        
    }
    
    func initRecognizer() {
        var urlStr = NSString.init()
        //var urlStr [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //创建语音识别对象
        print("1-----------\(String(describing: iFlySpeechRecognizer))")
        iFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance()
        print("2-----------\(String(describing: iFlySpeechRecognizer))")
        //音频源为音频流（-1)   //默认为麦克风 1
        iFlySpeechRecognizer?.setParameter("1", forKey: "audio_source")
       iFlySpeechRecognizer?.setParameter("", forKey: IFlySpeechConstant.params())
        //设置识别参数
        //设置为听写模式
        iFlySpeechRecognizer?.setParameter("lat", forKey: IFlySpeechConstant.ifly_DOMAIN())
        iFlySpeechRecognizer?.delegate = self
        
        if iFlySpeechRecognizer != nil {
            //设置最长录音时间
           iFlySpeechRecognizer?.setParameter("3000000", forKey: IFlySpeechConstant.speech_TIMEOUT())
            //设置后端点
            iFlySpeechRecognizer?.setParameter("3000", forKey: IFlySpeechConstant.vad_EOS())
            //设置前端点
            iFlySpeechRecognizer?.setParameter("3000", forKey: IFlySpeechConstant.vad_BOS())
            //网络等待时间
            iFlySpeechRecognizer?.setParameter("20000", forKey: IFlySpeechConstant.net_TIMEOUT())
            //设置采样率
            iFlySpeechRecognizer?.setParameter("16000", forKey: IFlySpeechConstant.sample_RATE())
            //设置语言
             iFlySpeechRecognizer?.setParameter("zh_cn", forKey: IFlySpeechConstant.language())
            //设置是够返回标点符号
            iFlySpeechRecognizer?.setParameter("1", forKey: IFlySpeechConstant.asr_PTT())
        }
        
        //取消本次会话
        iFlySpeechRecognizer?.cancel()
        //设置音频来源为麦克风
        iFlySpeechRecognizer?.setParameter("json", forKey: IFlySpeechConstant.result_TYPE())
   
        //https://blog.csdn.net/u010047161/article/details/49788919
        //https://blog.csdn.net/liumude123/article/details/52573424
        
        //asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。
        //[_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        iFlySpeechRecognizer?.setParameter("asr.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
        //启动识别服务
        iFlySpeechRecognizer?.delegate = self
   
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+10) {
       let ret = self.iFlySpeechRecognizer?.startListening()
            //U8bd5   //U3002
            if ret! {
               print("启动语音成功")
            }else {
                print("启动识别服务失败,请稍后重试")
            }
        }
    }

   // 解析听写json格式的数据
   // params例如：
   // {"sn":1,"ls":true,"bg":0,"ed":0,"ws":[{"bg":0,"cw":[{"w":"白日","sc":0}]},{"bg":0,"cw":[{"w":"依山","sc":0}]},{"bg":0,"cw":[{"w":"尽","sc":0}]},{"bg":0,"cw":[{"w":"黄河入海流","sc":0}]},{"bg":0,"cw":[{"w":"。","sc":0}]}]}
   
    func stringFromJson(params : NSString?) -> NSString? {
        if (params?.length)! == 0 {
            return nil
        }
        var tempStr = NSMutableString.init()
        let paramData = params?.data(using: String.Encoding.utf8.rawValue) //String.Encoding.utf8.rawValue
        let  resultJson = try? JSONSerialization.jsonObject(with: paramData!, options: [])
        let resultDic = resultJson as! NSDictionary
        
        //JSONSerialization.ReadingOptions
        //as! NSDictionary
        print("resultDic_______ == \(resultDic)")
        
        if resultDic.count > 0 {
            var wordArray = NSArray.init()
            wordArray = resultDic.object(forKey:"ws") as! NSArray
            
            print("word_______ == \(wordArray)")
            
            for (index,_) in wordArray.enumerated() {
                let wsDic = wordArray.object(at: index) as! NSDictionary
                let cwArray = wsDic.object(forKey: "cw") as! NSArray
                
                for(index,_) in cwArray.enumerated() {
                    let wDic = cwArray.object(at: index) as! NSDictionary
                    let str = wDic.object(forKey: "w") as! NSString
                    tempStr.append(str as String)
                }
            }
        }
        return tempStr
    }

//    - (NSString *)stringFromJson:(NSString*)params
//    {
//    if (params == NULL) {
//    return nil;
//    }
//
//    NSMutableString *tempStr = [[NSMutableString alloc] init];
//    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
//    [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
//
//    if (resultDic!= nil) {
//    NSArray *wordArray = [resultDic objectForKey:@"ws"];
//
//    for (int i = 0; i < [wordArray count]; i++) {
//    NSDictionary *wsDic = [wordArray objectAtIndex: i];
//    NSArray *cwArray = [wsDic objectForKey:@"cw"];
//
//    for (int j = 0; j < [cwArray count]; j++) {
//    NSDictionary *wDic = [cwArray objectAtIndex:j];
//    NSString *str = [wDic objectForKey:@"w"];
//    [tempStr appendString: str];
//    }
//    }
//    }
//    return tempStr;
//    }

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
    
//IFlySpeechRecognizerDelegate
    //识别结果返回代理
    func onResults(_ results: [Any]!, isLast: Bool) {
        print("IFlySpeechRecognizerResults__ = \(results)")
        
        if let results = results {
           //todo
        } else {
            
        }
        
        guard results != nil else {
            
            return
        }
  
        if results.count <= 0 {
            return
        }

        let a = "qqq"
        
        let b = "aa" + a
        
        var resultString = NSMutableString.init()
        var dic = NSDictionary.init()
        dic = results[0] as! NSDictionary

        for (key,value) in dic {
          print(key,value)
            let keyString = NSMutableString(format: "%@", key as! CVarArg)
            resultString.append(keyString as String)
        }
        
         let resultFromJson = self.stringFromJson(params: resultString)
         let code = resultFromJson?.lowercased
        print("resultFromJson__ = \(String(describing: resultFromJson))")
       // print("resultFromJson__------ = \(String(describing: resultFromJson))")
        print("code__------ = \(String(describing: code))")
        
        if (whichSentence == "1级") {
            if (resultFromJson?.contains("试"))! || (resultFromJson?.contains("是"))! || (resultFromJson?.contains("时"))! || (resultFromJson?.contains("事"))! || (resultFromJson?.contains("你"))! || (resultFromJson?.contains("爱"))! || (resultFromJson?.contains("u4f60"))!{
                self.okAction()
            }
            
            if (resultFromJson?.contains("否"))! || (resultFromJson?.contains("不"))! || (resultFromJson?.contains("不是"))!{
                self.cancelAction()
            }
            
        }
        
        if (whichSentence == "2级") {
            if (resultFromJson?.contains("一"))! || (resultFromJson?.contains("以"))! || (resultFromJson?.contains("衣"))! || (resultFromJson?.contains("医"))! || (resultFromJson?.contains("伊"))!{
                
                //停止录音
                self.iFlySpeechRecognizer?.cancel()
                self.iFlySpeechRecognizer?.stopListening()
                //启动合成会话
                let text = "高德地图为你导航到东昌路19号"
                iFlySpeechSynthesizer?.startSpeaking(text)
                
                let mapVC = MapViewController.init(nibName: "MapViewController", bundle: nil)
                self.present(mapVC, animated: true, completion: nil)
                
            }
            
            if (resultFromJson?.contains("二"))! || (resultFromJson?.contains("而"))! || (resultFromJson?.contains("儿"))! || (resultFromJson?.contains("尔"))! || (resultFromJson?.contains("耳"))!{
                
                //停止录音
                self.iFlySpeechRecognizer?.cancel()
                self.iFlySpeechRecognizer?.stopListening()
                //启动合成会话
                let text = "高德地图为你导航到陆家嘴22号"
                iFlySpeechSynthesizer?.startSpeaking(text)
                
                let mapVC = MapViewController.init(nibName: "MapViewController", bundle: nil)
                self.present(mapVC, animated: true, completion: nil)

                
            }
        }
        
        
        
    }
    
    
//    func isIncludeChineseYes(string: NSString?) -> Bool {
////
//
//        let chinese = NSString.init()
//
////        let code = string?.lowercased
////        if (string?.contains("u662f"))! {
////
////        }
////
////        for (_, value) in string.characters.enumerate() {
////
////            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
////                return true
////            }
////        }
////
////        return false
//    }
//
    //停止录音回调
    func onEndOfSpeech() {
        
    }
    //开始录音回调
    func onBeginOfSpeech() {
         print("IFlySpeechRecognizer__onBeginOfSpeech")
    }
    //音量回调函数
    func onVolumeChanged(_ volume: Int32) {
       // print("IFlySpeechRecognizer__onVolumeChanged")
    }
    func onCancel() {
        print("IFlySpeechRecognizer__onCancel")
    }
   
    
}


































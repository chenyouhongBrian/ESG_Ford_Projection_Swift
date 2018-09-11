//
//  ProjectionVHAController.swift
//  SDLProjectionDemo
//
//  Created by Dandy.Guan on 2018/7/5.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

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
    
    var engineArray: Array<String> = []
    var exhaustArray: Array<String> = []
    var fuelArray: Array<String> = []
    var steerArray: Array<String> = []
    var tireArray: Array<String> = []
    var randomArray: Array<String> = []
    
    var alertController: UIAlertController?
    var mapAlert: YHAlertView?
    
    var detailScrollView: PScrollView = PScrollView()
    
    //语音
    var iFlySpeechSynthesizer: IFlySpeechSynthesizer?
    //不带界面的识别对象
    var iFlySpeechRecognizer: IFlySpeechRecognizer?
    
    var whichSentence: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   //     self.initRecognizer()
        //事故详细视图
        detailScrollView.backgroundColor = UIColor.black
        detailScrollView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        detailScrollView.alpha = 0.8
        detailScrollView.isScrollEnabled = true
        detailScrollView.showsVerticalScrollIndicator = true
        detailScrollView.isUserInteractionEnabled = true
        
        
        //模拟维修提示
        randomArray = ["E17"]
        self.setUpVHAProjectionViewByArray(randomArray)
  
        //横屏
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        
    
    self.initIFlySpeechSynthesizer()
   
    }
    
    func initIFlySpeechSynthesizer() {
        
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
        
        //语音合成
        //获取语音合成单例
        iFlySpeechSynthesizer = IFlySpeechSynthesizer.sharedInstance()
         iFlySpeechSynthesizer?.delegate = self
    }
    
    func setUpVHAProjectionViewByArray(_ array: Array<String>)  {
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
            if engine.contains(number) {
                engineAlert.isHidden = false
                engineImage.isHidden = false
                engineArray.append(number)
            }
            
            if exhaust.contains(number) {
                exhaustAlert.isHidden = false
                exhaustArray.append(number)
            }
            
            if fuel.contains(number) {
                fuelAlert.isHidden = false
                fuelImage.isHidden = false
                fuelArray.append(number)
            }
            
            if steer.contains(number) {
                steerAlert.isHidden = false
                steerArray.append(number)
            }
            
            if tire.contains(number) {
                view.bringSubview(toFront: tireAlert)
                tireImage1.isHidden = false
                tireImage2.isHidden = false
                tireImage3.isHidden = false
                tireImage4.isHidden = false
                tireAlert.isHidden = false
                tireArray.append(number)
            }
        }
    }
    
    @IBAction func caqButtonAction(_ sender: Any) {
   
    }
    
    @IBAction func webButtionAction(_ sender: Any) {
//        let window = UIApplication.shared.keyWindow
//        let windowView = window?.rootViewController?.view
//        let vhaView = windowView?.viewWithTag(2000)
//        let webView = windowView?.viewWithTag(3000)
//        vhaView?.isHidden = true
//        webView?.isHidden = false
        
        //停止语音识别
        iFlySpeechRecognizer?.destroy()
        
        let window = UIApplication.shared.keyWindow
        let windowView = window?.rootViewController?.view
        let vhaView = windowView?.viewWithTag(2000)
        let webView = windowView?.viewWithTag(3000)
        let caqView = windowView?.viewWithTag(1000)
        
        let textView = caqView?.viewWithTag(5000)
        textView?.isHidden = false
        vhaView?.isHidden = true
        webView?.isHidden = true
    }
    
    @IBAction func alertButtonAction(_ sender: Any) {
        
        print("randomArray ---- \(randomArray)")
        var titleArray : Array<String> = []
           self.setScrollViewByArray(detailArray: randomArray)
    }
   
    @IBAction func callDealerAction(_ sender: Any) {
        engineArray.removeAll()
        exhaustArray.removeAll()
        fuelArray.removeAll()
        steerArray.removeAll()
        tireArray.removeAll()
    }
    
    @IBAction func randomAction(_ sender: Any) {
        engineArray.removeAll()
        exhaustArray.removeAll()
        fuelArray.removeAll()
        steerArray.removeAll()
        tireArray.removeAll()
        
        let alertArray = ["E17","E26","E07","E08","F26","E10","E13","E20","F29","E27","E28","E29"]
        
        randomArray = alertArray.shuffleRandomCount()
        
        self.setUpVHAProjectionViewByArray(randomArray)
        
      
//        alertController = UIAlertController(title: "VHA", message: "是否到就近维修店进行维修", preferredStyle: UIAlertControllerStyle.alert)
//
//        let cancelAction = UIAlertAction(title: "否", style: UIAlertActionStyle.default) { (cancelAction) in
//            self.cancelAction()
//        }
//
//        let okAction = UIAlertAction(title: "是", style: UIAlertActionStyle.default) { (okAction) in
//            self.okAction()
//        }
//
//        alertController?.addAction(cancelAction)
//        alertController?.addAction(okAction)
//
//        self.present(alertController!, animated: true, completion: nil)
    }
 
    
//不去附近汽车维修店
   @objc func cancelAction() {
 //       alertController?.dismiss(animated: true, completion: nil)
        detailScrollView.removeFromSuperview()
        //停止语音识别
        iFlySpeechRecognizer?.destroy()
    }

//不去附近汽车维修店
   @objc func okAction() {
    detailScrollView.removeFromSuperview()
        //停止语音识别
        iFlySpeechRecognizer?.destroy()
 //       alertController?.dismiss(animated: true, completion: nil)
        
        whichSentence = "2级"
        //启动合成会话
        let text1 = "1.东昌路19号"
        let text2 = "2.陆家嘴22号"
        
        let text = "就近维修店有两家，请选择数字 \(text1) \(text2)"
        iFlySpeechSynthesizer?.startSpeaking(text)
    
        YHAlertView.show(title: "就近维修店有两家", message: "请选择", cancelButtonTitle: "取消", otherButtonTitles:text1,text2) { (alertV:YHAlertView, index:Int) in
            print("点击下标是:\(index)")
            
            switch index{
            //取消
            case 0:
                //停止语音识别
                self.iFlySpeechRecognizer?.destroy()
                break
            case 1:
                //启动合成会话
                let text = "高德地图为你导航到东昌路19号"
                 //停止语音识别
                self.iFlySpeechRecognizer?.destroy()
                let mapVC = MapViewController.init(nibName: "MapViewController", bundle: nil)
                mapVC.speakText = text
                self.present(mapVC, animated: true, completion: nil)
                
                break
            case 2:
                //启动合成会话
                let text = "高德地图为你导航到陆家嘴22号"
               self.iFlySpeechRecognizer?.destroy()
                let mapVC = MapViewController.init(nibName: "MapViewController", bundle: nil)
                 mapVC.speakText = text
                self.present(mapVC, animated: true, completion: nil)
         
                break
            default:
                break
            }
        }
    }
    
    @IBAction func engineAlertAction(_ sender: Any) {
       
    self.setScrollViewByArray(detailArray: engineArray)

    }
    
    func setScrollViewByArray(detailArray:Array<String>) {
        detailScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        if detailArray.count > 0 {
            for view:UIView in detailScrollView.subviews{
                view.removeFromSuperview()
            }

            whichSentence = "1级"
            //停止语音识别
            iFlySpeechRecognizer?.destroy()
 
            //启动合成会话
            iFlySpeechSynthesizer = IFlySpeechSynthesizer.sharedInstance()
             iFlySpeechSynthesizer?.delegate = self
            let text = "汽车故障提示，是否到就近维修店进行维修"
            iFlySpeechSynthesizer!.startSpeaking(text)
            
            let warningView : UIView = UIView.init(frame: CGRect(x: 20, y: 5, width: ScreenWidth - 40, height: 100))
            warningView.backgroundColor = UIColor.black
             detailScrollView.addSubview(warningView)
            let warningLabel : UILabel = UILabel.init(frame: CGRect(x: 40, y: 5, width: 250, height: 90))
            warningLabel.font = UIFont.systemFont(ofSize: 22)
            warningLabel.adjustsFontSizeToFitWidth = true
            warningLabel.numberOfLines = 2
            warningLabel.text = "汽车故障提示，是否到就近维修店进行维修"
            warningLabel.textColor = UIColor.white
            warningView.addSubview(warningLabel)
            
            let noButton : UIButton = UIButton.init(type: UIButtonType.custom)
            noButton.setImage(UIImage.init(named: "no"), for: UIControlState.normal)
            noButton.frame = CGRect(x: 350, y: 10, width: 90, height: 90)
            let yesButton : UIButton = UIButton.init(type: UIButtonType.custom)
            yesButton.setImage(UIImage.init(named: "ok"), for: UIControlState.normal)
            yesButton.frame = CGRect(x: 550, y: 10, width: 90, height: 90)
            warningView.addSubview(noButton)
            warningView.addSubview(yesButton)
            noButton.addTarget(self, action: #selector(cancelAction), for: UIControlEvents.touchUpInside)
            yesButton.addTarget(self, action: #selector(okAction), for: UIControlEvents.touchUpInside)
            
            let lineView : UIView = UIView.init(frame: CGRect(x: 20, y: warningView.bounds.size.height + 1, width: warningView.bounds.size.width - 40, height: 1))
            lineView.backgroundColor = UIColor.init(red: 238/255.0, green: 191/255.0, blue: 45/255.0, alpha: 1)
            warningView.addSubview(lineView)
        
            var heightBefore : CGFloat = 110
            for index in 0..<detailArray.count {
                let contentArray = Tool.warningContentsByCode(number: detailArray[index])
                let detailView = DetailView()
                detailView.contentLabel?.text = contentArray[3]
                detailView.titleLabel?.text = contentArray[1]
                detailView.image?.image = UIImage(named: contentArray[2])
                detailView.setUpView()
                
                let height : CGFloat = CGFloat((detailView.contentLabel?.bounds.size.height)!)
               
                let y : CGFloat =  heightBefore
                detailView.frame = CGRect(x: 40, y: y, width: ScreenWidth - 80, height: height)
                
                detailScrollView.addSubview(detailView)
                let preY : CGFloat = CGFloat(ScreenWidth / 10 + 20)
                heightBefore = heightBefore + (detailView.contentLabel?.bounds.size.height)! + preY + 20
            }
           
            let limitHeight : CGFloat = heightBefore + 20
            print("limitHeight ------ \(limitHeight)")
            if(limitHeight < ScreenHeight) {
                detailScrollView.contentSize = CGSize(width: ScreenWidth, height: ScreenHeight)
            }else{
                detailScrollView.contentSize = CGSize(width: ScreenWidth, height: limitHeight)
            }
            self.view.addSubview(detailScrollView)
        }
    }
    
    
    @IBAction func fuelAlertAction(_ sender: Any) {
        self.setScrollViewByArray(detailArray: fuelArray)
    }
    
    @IBAction func steerAlertAction(_ sender: Any) {
         self.setScrollViewByArray(detailArray: steerArray)
    }
    
    @IBAction func tireAlertAction(_ sender: Any) {
        self.setScrollViewByArray(detailArray: tireArray)
    }
    
    @IBAction func exhaustAlertAction(_ sender: Any) {
        self.setScrollViewByArray(detailArray: exhaustArray)
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
   
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+10) {
//       let ret = self.iFlySpeechRecognizer?.startListening()
//            //U8bd5   //U3002
//            if ret! {
//               print("启动语音成功")
//            }else {
//                print("启动识别服务失败,请稍后重试")
//            }
//        }
    }

   // 解析听写json格式的数据
     // params例如：
   // {"sn":1,"ls":true,"bg":0,"ed":0,"ws":[{"bg":0,"cw":[{"w":"白日","sc":0}]},{"bg":0,"cw":[{"w":"依山","sc":0}]},{"bg":0,"cw":[{"w":"尽","sc":0}]},{"bg":0,"cw":[{"w":"黄河入海流","sc":0}]},{"bg":0,"cw":[{"w":"。","sc":0}]}]}
   
    func stringFromJson(params : String?) -> String? {
        if (params?.lengthOfBytes(using: String.Encoding.utf8)) == 0 {
            return nil
        }
        var tempStr : String = ""
        let paramData = params?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) //String.Encoding.utf8.rawValue
        let  resultJson = try? JSONSerialization.jsonObject(with: paramData!, options: [])
        let resultDic = resultJson as! NSDictionary
        
        //JSONSerialization.ReadingOptions
        //as! NSDictionary
        //print("resultDic_______ == \(resultDic)")
        
        if resultDic.count > 0 {
            var wordArray = NSArray.init()
            wordArray = resultDic.object(forKey:"ws") as! NSArray
            
           // print("word_______ == \(wordArray)")
            
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

//IFlySpeechSynthesizerDelegate
    //合成开始
    func onSpeakBegin() {
        print("IFlySpeechSynthesizer__onSpeakBegin")
    }
    //合成结束
    func onCompleted(_ error: IFlySpeechError!) {
        print("IFlySpeechSynthesizer__onCompleted")
      self.initRecognizer()
      
        let ret = iFlySpeechRecognizer?.startListening()
        //U8bd5   //U3002
        if ret! {
            print("启动语音成功")
        }else {
            print("启动识别服务失败,请稍后重试")
        }
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
        print("c__ = \(results)")
        
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

        
        var resultString : String = ""
        var dic = NSDictionary.init()
        dic = results[0] as! NSDictionary

        for (key,value) in dic {
          print(key,value)
            let keyString = NSMutableString(format: "%@", key as! CVarArg)
            resultString.append(keyString as String)
        }
        
         let resultFromJson = self.stringFromJson(params: resultString)
         let code = resultFromJson?.lowercased
       // print("resultFromJson__ = \(String(describing: resultFromJson))")
       // print("resultFromJson__------ = \(String(describing: resultFromJson))")
        print("code__----------- = \(String(describing: code))")
    
        if (whichSentence == "1级") {
            if (resultFromJson?.contains("试"))! || (resultFromJson?.contains("是"))! || (resultFromJson?.contains("时"))! || (resultFromJson?.contains("事"))!  || (resultFromJson?.contains("u4f60"))!{

                self.okAction()
            }
            
            if (resultFromJson?.contains("否"))! || (resultFromJson?.contains("不"))! || (resultFromJson?.contains("不是"))!{
              
                self.cancelAction()
            }
            
        }
        
        if (whichSentence == "2级") {
            
            if (resultFromJson?.contains("一"))! || (resultFromJson?.contains("以"))! || (resultFromJson?.contains("衣"))! || (resultFromJson?.contains("医"))! || (resultFromJson?.contains("伊"))!{
                
                //停止语音识别
                iFlySpeechRecognizer?.destroy()

                //启动合成会话
                let text = "高德地图为你导航到东昌路19号"
    
                for view:UIView in  (UIApplication.shared.keyWindow?.subviews)!{
                    if view.isKind(of: YHAlertView.self) {
                        view.removeFromSuperview()
                    }
                }
   
                let mapVC = MapViewController.init(nibName: "MapViewController", bundle: nil)
                mapVC.speakText = text
                self.present(mapVC, animated: true, completion: nil)
                
            }
            
            if (resultFromJson?.contains("二"))! || (resultFromJson?.contains("而"))! || (resultFromJson?.contains("儿"))! || (resultFromJson?.contains("尔"))! || (resultFromJson?.contains("耳"))!{
                
                //停止语音识别
                iFlySpeechRecognizer?.destroy()
                //启动合成会话
                let text = "高德地图为你导航到陆家嘴22号"
                
                for view:UIView in  (UIApplication.shared.keyWindow?.subviews)!{
                    if view.isKind(of: YHAlertView.self) {
                        view.removeFromSuperview()
                    }
                }
                let mapVC = MapViewController.init(nibName: "MapViewController", bundle: nil)
                mapVC.speakText = text
                self.present(mapVC, animated: true, completion: nil)
                
            }
        }
    }

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
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.frame.size.height = ScreenHeight
        self.view.frame.size.width = ScreenWidth
    }
    
    
}



extension UIView {
     var width: CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            print("=========== newValue \(newValue)")
        }
    }
}






























//
//  ProxyManager.swift
//  SDLProjectionDemo
//
//  Created by Yuan on 2018/5/24.
//  Copyright © 2018 YuanWei. All rights reserved.
//

import UIKit
import Foundation
//import SmartDeviceLink

enum SDLHMIFirstState: Int {
    case none = 0
    case nonNone
    case full
}

enum SDLHMIInitialShowState: Int {
    case none = 0
    case dataAvailable = 1
    case shown
}

protocol ProxyManagerDelegate: NSObjectProtocol {
    func sdlManager(_ sdlManager: ProxyManager,didReceived touchEvent:SDLOnTouchEvent)
    func sdlManager(_ sdlManager: ProxyManager,didSelect command: Int)
    func sdlManager(_ sdlManager: ProxyManager,didConnected: Bool)
}

class ProxyManager: NSObject, SDLManagerDelegate, SDLProxyListener {
    static let sharedInstance = ProxyManager()
    weak var delegate: ProxyManagerDelegate?
    var sdlManager: SDLManager!

    var connected: Bool = false {
       //willSet有一个newValue参数，didSet有一个oldvalue参数
        willSet(newValue){
            
        }
        didSet(oldValue) {
            if (connected != oldValue){
                self.delegate?.sdlManager(self, didConnected: connected)
            }
        }
    } 
    
    var isVideoSessionConnected: Bool {
        get {
            return (self.sdlManager.streamManager?.videoSessionConnected)!
        }
    }
    var isAudioSessionConnected: Bool {
        get {
            return (self.sdlManager.streamManager?.audioSessionConnected)!
        }
    }
    
    var screenWidth = Float(800.0)
    var screenHeight = Float(348.0)
    
    var isBackgroundStated: Bool = false
    var firstTimeState: SDLHMIFirstState = .none
    var initialShowState: SDLHMIInitialShowState = .none
    var isHmiReady = false
    var firstTimeHMIFull = false
    var isCapturing: Bool = false
    var captureQueue = DispatchQueue(label: "projection.capture.queue")
    var displayLink: CADisplayLink?
    
    private override init() {
        super.init()
        let lifecyceConfig = SDLLifecycleConfiguration.defaultConfiguration(withAppName: "搜狗导航", appId: "3342016694")
        
        lifecyceConfig.appType = SDLAppHMIType.navigation()
        lifecyceConfig.securityManagers = [FMCSecurityManager.self]
        let image = UIImage.init(named: "appicon1")
        let appIconArt = SDLArtwork.persistentArtwork(with: image!, name: "appicon1", as: .PNG)
        lifecyceConfig.appIcon = appIconArt
        lifecyceConfig.language = SDLLanguage.zh_CN()
        lifecyceConfig.languagesSupported = [SDLLanguage.zh_CN(),SDLLanguage.en_US(),SDLLanguage.en_GB()]
        let lockScreen = SDLLockScreenConfiguration.disabled()
        let config = SDLConfiguration.init(lifecycle: lifecyceConfig, lockScreen: lockScreen)
        self.sdlManager = SDLManager.init(configuration: config, delegate: self)
    }
    
    //MARK: Public Methods
    func startConnect()  {
        NotificationCenter.default.removeObserver(self, name: SDLDidReceiveRegisterAppInterfaceResponse, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveRegisterAppInterfaceResponse), name: SDLDidReceiveRegisterAppInterfaceResponse, object: nil)
        
        self.sdlManager.start { (success, error) in
            if success {
                self.sdlManager.proxy?.removeDelegate(self)
                self.sdlManager.proxy?.addDelegate(self)
                self.connected = true
            }else{
                self.connected = false
            }
        }
    }
    func readyToStartVideoSession()  {
        if (!self.isHmiReady) {
            return
        }
        if (!self.sdlManager.permissionManager.isRPCAllowed("OnTouchEvent")) {
            return
        }
        if (self.isVideoSessionConnected) {
            return;
        }
        let bitrate = 2048
        let videoEncoderSettings = [kVTCompressionPropertyKey_ProfileLevel: kVTProfileLevel_H264_Baseline_AutoLevel,
                                    kVTCompressionPropertyKey_RealTime: true,
                                    kVTCompressionPropertyKey_AverageBitRate: (bitrate * 1024),
                                    kVTCompressionPropertyKey_ExpectedFrameRate: (20)] as [CFString : Any]
       self.sdlManager.streamManager?.videoEncoderSettings = videoEncoderSettings
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.sdlManager.streamManager?.startVideoSession(withTLS: .authenticateOnly, start: { (success, encryption, error) in
                if (!success) {
                    if let err = error {
                        print("err = \(err)")
                    }
                    else{
                        print("Error starting video session.")
                    }
                }
                else {
                    print("Video Session Connected")
                }
            })
        }
    }
    
    func sendVideoData(imageBuffer : CVImageBuffer) -> Bool {
        if (!self.isVideoSessionConnected) {
            return false
        }
        let ret = self.sdlManager.streamManager?.sendVideoData(imageBuffer)
        return ret!
    }
    func sendAudioData(data : Data) -> Bool {
        if (!self.isAudioSessionConnected) {
            return false
        }
        let ret = self.sdlManager.streamManager?.sendAudioData(data)
        return ret!
        }
  
    func startVideoSessionWithCompletion(startBlock : @escaping
        SDLStreamingEncryptionStartBlock) {
        if (self.isVideoSessionConnected) {
            startBlock(true, true, nil)
            return
        }
        let flag = SDLEncryptionFlag.authenticateOnly
        self.sdlManager.streamManager?.startVideoSession(withTLS: flag, start: { (success, encryption, error) in
            startBlock(success, encryption, error)
        })
    }
    @objc func startVideoSession() {
        self.startVideoSessionWithCompletion { (success, encrytion, error) in
        }
    }
    @objc func stopVideoSession() {
        if (self.isVideoSessionConnected) {
            self.sdlManager.streamManager?.stopVideoSession()
        }
    }
    @objc func startAudioSession() {
        if (self.isAudioSessionConnected) {
            return
        }
        let flag = SDLEncryptionFlag.authenticateOnly
        self.sdlManager.streamManager?.startAudioSession(withTLS: flag, start: { (success, encryption, error) in
        })
    }
    @objc func stopAudioSession() {
        
    }
    
    func startCapture() {
        // captureQueue.syn
        self.captureQueue.sync {
            if !self.isCapturing {
                let currentRunLoop = RunLoop.main
                self.displayLink?.invalidate()
                self.displayLink = CADisplayLink(target: self, selector: #selector(self.render))
                self.displayLink?.add(to: currentRunLoop, forMode: RunLoopMode.commonModes)
                self.isCapturing = true
                self.displayLink?.preferredFramesPerSecond = 4
            }
        }
    }
    func stopCapture() {
        if self.isCapturing {
            self.displayLink?.invalidate()
            self.displayLink = nil
            self.isCapturing = false
        }
    }
    
    @objc func render(displayLink: CADisplayLink) {
        if self.isVideoSessionConnected && !self.isBackgroundStated {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                if let window = appDelegate.window {
                    if window.frame.isEmpty {
                        return
                    }
                    let scale: CGFloat = 1.0
                    if let cgImage = self.snapshot(view: window, scale: scale)?.cgImage {
                        if let buffer = self.getCVPixelBuffer(cgImage) {
                            let _ = self.sendVideoData(imageBuffer: buffer)
                            //                            print("render ret = ")
                        }
                    }
                }
            }
        }
    }
    
    func snapshot(view: UIView, scale:CGFloat) -> UIImage? {
        let size = CGSize(width: view.frame.size.width * scale, height: view.frame.size.height * scale)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.5)
        let rect = CGRect(x: 0.0, y:0.0, width: size.width, height: size.height)
        view.drawHierarchy(in: rect, afterScreenUpdates: false)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
    }
    
    func getCVPixelBuffer(_ image: CGImage) -> CVPixelBuffer? {
        let imageWidth = Int(image.width)
        let imageHeight = Int(image.height)
        
        let attributes : [NSObject:AnyObject] = [kCVPixelBufferCGImageCompatibilityKey : true as AnyObject,
                                                 kCVPixelBufferCGBitmapContextCompatibilityKey : true as AnyObject]
        
        var pxbuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault, imageWidth, imageHeight, kCVPixelFormatType_32ARGB, attributes as CFDictionary?, &pxbuffer)
        
        if let _pxbuffer = pxbuffer {
            let flags = CVPixelBufferLockFlags(rawValue: 0)
            CVPixelBufferLockBaseAddress(_pxbuffer, flags)
            let pxdata = CVPixelBufferGetBaseAddress(_pxbuffer)
            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pxdata,
                                    width: imageWidth,
                                    height: imageHeight,
                                    bitsPerComponent: 8,
                                    bytesPerRow: CVPixelBufferGetBytesPerRow(_pxbuffer),
                                    space: rgbColorSpace,
                                    bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
            if let _context = context {
                _context.draw(image, in: CGRect.init(x: 0, y: 0, width: imageWidth, height: imageHeight))
            }else{
                CVPixelBufferUnlockBaseAddress(_pxbuffer, flags)
                 return nil
            }
            CVPixelBufferUnlockBaseAddress(_pxbuffer, flags)
            return _pxbuffer
        }
        return nil
    }
    
    //MARK: PRC Request Methods
    func sendRequestOnce(rpcRequest: SDLRPCRequest) {
        self.sdlManager.send(rpcRequest, withResponseHandler: nil)
    }

    
    
    
    
    
//Mark: SDLManagerDelegate Methods
    func managerDidDisconnect() {
      self.firstTimeState = .none
      self.initialShowState = .none
      self.isHmiReady = false
      self.firstTimeHMIFull = false
        self.stopVideoSession()
        self.stopAudioSession()
    }

    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeTo newLevel: SDLHMILevel) {
       
        self.isHmiReady = newLevel.isEqual(to: SDLHMILevel.full())
        if (!newLevel.isEqual(to: SDLHMILevel.none()) && self.firstTimeState == .none) {
            self.firstTimeState = .nonNone
        }
        
        if (newLevel.isEqual(to: SDLHMILevel.full()) && self.firstTimeHMIFull) {
            self.firstTimeHMIFull = false
            //发送视频
        }
        else if (oldLevel.isEqual(to: SDLHMILevel.full()) && newLevel.isEqual(to: SDLHMILevel.none())){
            
        }
        
        if (oldLevel.isEqual(to: SDLHMILevel.none()) && newLevel.isEqual(to: SDLHMILevel.full())) {
            //发送视频
        }
    }
    
    //Mark: SDLProxyListener methods
    func on(_ notification: SDLOnDriverDistraction!) {
    }
    func on(_ notification: SDLOnHMIStatus!) {
    }
    func onProxyClosed() {
    }
    func onProxyOpened() {
    }
    func on(_ notification: SDLOnTouchEvent!) {
        
    }
    
    //Mark: Private methods
    @objc func performTouchEvent(event: SDLOnTouchEvent) {
        self.delegate?.sdlManager(self, didReceived: event)
    }
    
    @objc func didReceiveRegisterAppInterfaceResponse(notification:SDLRPCResponseNotification){
        if let response = notification.response as?
            SDLRegisterAppInterfaceResponse {
            if response.success.boolValue{
                self.firstTimeHMIFull = true
                self.screenWidth = response.displayCapabilities.screenParams.resolution.resolutionWidth.floatValue
                self.screenHeight = response.displayCapabilities.screenParams.resolution.resolutionHeight.floatValue
                let version = response.systemSoftwareVersion
                print("systemSoftwareVersion = \(String(describing: version))")
            }
        }
    }
}










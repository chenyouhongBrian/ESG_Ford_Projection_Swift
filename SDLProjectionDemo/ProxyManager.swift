//
//  ProxyManager.swift
//  SDLDemo
//
//  Created by zhengzheng on 2018/5/15.
//  Copyright © 2018 Sogou, Inc. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreVideo


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
    func sdlManager(_ sdlManager: ProxyManager, didReceived touchEvent: SDLOnTouchEvent)
    func sdlManager(_ sdlManager: ProxyManager, didUpdated location: CLLocation)
    func sdlManager(_ sdlManager: ProxyManager, didSelect command: Int)
    func sdlManager(_ sdlManager: ProxyManager, didConnected: Bool)
}

class ProxyManager : NSObject, SDLManagerDelegate, SDLProxyListener {
    static let sharedInstance = ProxyManager()
    
    weak var delegate: ProxyManagerDelegate?
    
    var connected: Bool = false {
        willSet(newValue) {
            
        }
        didSet(oldValue) {
            if (connected != oldValue) {
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
            print("1-------------------------------------self.sdlManager.streamManager?.audioSessionConnected")
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
    var captureQueue = DispatchQueue(label: "sogoumap.capture.queue")
    var displayLink: CADisplayLink?
    var sdlManager: SDLManager!
    
    private override init() {
        super.init()
        let lifecycleConfig = SDLLifecycleConfiguration.defaultConfiguration(withAppName: "搜狗导航", appId: "3342016694")
        lifecycleConfig.securityManagers = [FMCSecurityManager.self]
        
        lifecycleConfig.appType = SDLAppHMIType.navigation()
        let image = UIImage.init(named: "appicon1")
        let appIconArt = SDLArtwork.persistentArtwork(with: image!, name: "appicon1", as: .PNG)
        lifecycleConfig.appIcon = appIconArt
        lifecycleConfig.language = SDLLanguage.zh_CN()
        lifecycleConfig.languagesSupported = [SDLLanguage.zh_CN(), SDLLanguage.en_US(), SDLLanguage.en_GB()]
        
        let lockScreen = SDLLockScreenConfiguration.disabled()
       
        let config = SDLConfiguration.init(lifecycle: lifecycleConfig, lockScreen: lockScreen)
        self.sdlManager = SDLManager.init(configuration: config, delegate: self)
        
        print("2-------------------------------------SDLManager.init(configuration: config, delegate: self)")
        
    }
    
    // MARK: Public Methods
    func startConnect() {
        NotificationCenter.default.removeObserver(self, name: SDLDidReceiveRegisterAppInterfaceResponse, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveRegisterAppInterfaceResponse), name: SDLDidReceiveRegisterAppInterfaceResponse, object: nil)
        
        self.sdlManager.start { (success, error) in
            if success {
                self.sdlManager.proxy?.removeDelegate(self)
                self.sdlManager.proxy?.addDelegate(self)
                self.connected = true
            }
                else {
                    self.connected = false
            }
        }
    }
    func readyToStartVideoSession() {
        if (!self.isHmiReady) {
             print("3-------------------------------------!self.isHmiReady")
            return
        }
        if (!self.sdlManager.permissionManager.isRPCAllowed("OnTouchEvent")) {
        
            return
        }
        if (self.isVideoSessionConnected) {
                 print("4-------------------------------------self.isVideoSessionConnected\(self.isVideoSessionConnected)")
            return;
        }
        let bitrate = 2048
        let videoEncoderSettings = [kVTCompressionPropertyKey_ProfileLevel: kVTProfileLevel_H264_Baseline_AutoLevel,
                                    kVTCompressionPropertyKey_RealTime: true,
                                    kVTCompressionPropertyKey_AverageBitRate: (bitrate * 1024),
                                    kVTCompressionPropertyKey_ExpectedFrameRate: (20)] as [CFString : Any]
        self.sdlManager.streamManager?.videoEncoderSettings = videoEncoderSettings
         print("13-------------------------------------readyToStartVideoSession()");
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("5-------------------------------------self.sdlManager.streamManager?.startVideoSession"); self.sdlManager.streamManager?.startVideoSession(withTLS: .authenticateOnly, start: { (success, encryption, error) in
                if (!success) {
                    if let err = error {
                        print("err = \(err)")
                    }
                    else {
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
        print("6-------------------------------------sendVideoData");
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
    func startVideoSessionWithCompletion(startBlock : @escaping SDLStreamingEncryptionStartBlock) {
        if (self.isVideoSessionConnected) {
            startBlock(true, true, nil)
            return
        }
           print("16-------------------------------------manager.startVideoSession)");
        let flag = SDLEncryptionFlag.authenticateOnly
        self.sdlManager.streamManager?.startVideoSession(withTLS: flag, start: { (success, encryption, error) in
            startBlock(success, encryption, error)
        })
    }
    @objc func startVideoSession() {
           print("15-------------------------------------manager.startVideoSession)");
        self.startVideoSessionWithCompletion { (success, encryption, error) in
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
        if (self.isAudioSessionConnected) {
            self.sdlManager.streamManager?.stopAudioSession()
        }
    }
    
    
    func startCapture() {
        //        captureQueue.syn
        print("7-------------------------------------startCapture");
        self.captureQueue.sync {
            if !self.isCapturing {
                let currentRunLoop = RunLoop.main
                self.displayLink?.invalidate()
                self.displayLink = CADisplayLink(target: self, selector: #selector(self.render))
                self.displayLink?.add(to: currentRunLoop, forMode: RunLoopMode.commonModes)
                self.isCapturing = true
                self.displayLink?.frameInterval = 4
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
         print("8-------------------------------------render");
        if self.isVideoSessionConnected && !self.isBackgroundStated {
            print("9-------------------------------------self.isVideoSessionConnected");
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                if let window = appDelegate.window {
                    if window.frame.isEmpty {
                        return
                    }
                    print("10-------------------------------------self.sendVideoData(imageBuffer: buffer)");
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
    
    func snapshot(view: UIView, scale: CGFloat) -> UIImage? {
        let size = CGSize(width: view.frame.size.width * scale, height: view.frame.size.height * scale)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.5)
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        view.drawHierarchy(in: rect, afterScreenUpdates: false)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
    }
    
    func getCVPixelBuffer(_ image: CGImage) -> CVPixelBuffer? {
        let imageWidth = Int(image.width)
        let imageHeight = Int(image.height)
        
        let attributes : [NSObject:AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey : true as AnyObject,
            kCVPixelBufferCGBitmapContextCompatibilityKey : true as AnyObject
        ]
        
        var pxbuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault,
                            imageWidth,
                            imageHeight,
                            kCVPixelFormatType_32ARGB,
                            attributes as CFDictionary?,
                            &pxbuffer)
        
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
            }
            else {
                
                CVPixelBufferUnlockBaseAddress(_pxbuffer, flags)
                return nil
            }
            
            CVPixelBufferUnlockBaseAddress(_pxbuffer, flags)
            return _pxbuffer
        }
        
        return nil
    }
    
    // MARK: RPC Request Methods
    func sendRequestOnce(rpcRequest: SDLRPCRequest) {
        self.sdlManager.send(rpcRequest, withResponseHandler: nil)
    }
    
    func sendRequest(rpcRequest: SDLRPCRequest, handler: @escaping SDLResponseHandler) {
        self.sdlManager.send(rpcRequest) { (request, response, error) in
            handler(request, response, error)
        }
    }
    // MARK: SDLManagerDelegate Methods
    func managerDidDisconnect() {
        self.firstTimeState = .none
        self.initialShowState = .none
        self.isHmiReady = false
        self.firstTimeHMIFull = false
        self.stopVideoSession()
        self.stopAudioSession()
    }
    
    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeTo newLevel: SDLHMILevel) {
       print("10-------------------------------------hmiLevel)");
        self.isHmiReady = newLevel.isEqual(to: SDLHMILevel.full())
        if (!newLevel.isEqual(to: SDLHMILevel.none())
            && self.firstTimeState == .none) {
            self.firstTimeState = .nonNone
        }
        
        if (newLevel.isEqual(to: SDLHMILevel.full()) && self.firstTimeHMIFull) {
            self.firstTimeHMIFull = false
            
            self.readyToStartVideoSession()
        }
        else if (oldLevel.isEqual(to: SDLHMILevel.full()) && newLevel.isEqual(to: SDLHMILevel.none())) {
            
        }
        
        if (oldLevel.isEqual(to: SDLHMILevel.none()) && newLevel.isEqual(to: SDLHMILevel.full())) {
            self.readyToStartVideoSession()
        }
    }
    
    // MARK: SDLProxyListener methods
    func on(_ notification: SDLOnDriverDistraction!) {
    }
    
    func on(_ notification: SDLOnHMIStatus!) {
    }
    
    func onProxyClosed() {
    }
    
    func onProxyOpened() {
    }
    
    func on(_ notification: SDLOnTouchEvent!) {
        if !self.isBackgroundStated {
            if let noti = notification {
                self.performSelector(onMainThread: #selector(self.performTouchEvent), with: noti, waitUntilDone: true, modes: [RunLoopMode.commonModes.rawValue])
            }
        }
    }
    
    // MARK: Private methods
    @objc func performTouchEvent(event: SDLOnTouchEvent) {
        self.delegate?.sdlManager(self, didReceived: event)
    }
    
    @objc func didReceiveRegisterAppInterfaceResponse(notification: SDLRPCResponseNotification) {
        if let response = notification.response as? SDLRegisterAppInterfaceResponse {
            if response.success.boolValue {
                self.firstTimeHMIFull = true
                self.screenWidth = response.displayCapabilities.screenParams.resolution.resolutionWidth.floatValue
                self.screenHeight = response.displayCapabilities.screenParams.resolution.resolutionHeight.floatValue
                
                let version = response.systemSoftwareVersion
                print("systemSoftwareVersion = \(String(describing: version))")
            }
        }
    }
}




















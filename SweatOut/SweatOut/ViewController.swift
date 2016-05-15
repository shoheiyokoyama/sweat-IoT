//
//  ViewController.swift
//  SweatOut
//
//  Created by Hanawa Takuro on 2016/05/14.
//  Copyright © 2016年 Hanawa Takuro. All rights reserved.
//

import UIKit
import CoreBluetooth
import Social
import FillableLoaders

class ViewController: UIViewController {

    let uuidVspService = "569a1101-b87f-490c-92cb-11ba5ea5167c"
    let uuidRX = "569a2001-b87f-490c-92cb-11ba5ea5167c"
    let uuidTX = "569a2000-b87f-490c-92cb-11ba5ea5167c"
    
    var blBase = BLEBaseClass()
    var blDevice: BLEDeviceClass?
    
    var loader = WavesLoader()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        blBase.scanDevices(nil)
        blDevice = nil
        
        NSTimer.scheduledTimerWithTimeInterval( 2.5, target: self, selector:#selector(ViewController.connect), userInfo: nil, repeats: false )

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        setupLoader()
    }
    
    func setupLoader() {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 50, 50)
        CGPathAddLineToPoint(path, nil, 70, 150)
        CGPathAddLineToPoint(path, nil, 170, 150)
        CGPathAddLineToPoint(path, nil, 190, 50)
        CGPathAddLineToPoint(path, nil, 50, 50)
        CGPathCloseSubpath(path)
        
        loader = WavesLoader.createLoaderWithPath(path: path)
        loader.loaderColor = UIColor.blueColor()
        loader.progressBased = true
        loader.progress = 0.0
        loader.showLoader()
    }
    
    @IBAction func tappedButton(sender: AnyObject) {
        startCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showTweetAlertWithImage(image: UIImage) {
        let tweetView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        tweetView.setInitialText("Twitter Test from Swift")
        tweetView.addImage(image)
        self.presentViewController(tweetView, animated: true, completion: nil)
    }
    
    func connect() {
        //	UUID_DEMO_SERVICEサービスを持っているデバイスに接続する
        blDevice = blBase.connectService(uuidVspService)
        guard let device = blDevice else { return }

        
        blBase.scanStop()
         //	キャラクタリスティックの値を読み込んだときに自身をデリゲートに指定
        device.delegate = self
//        blBase.printDevices()
        
        //	tx(Device->iPhone)のnotifyをセット
        let tx = device.getCharacteristic(uuidVspService, characteristic: uuidTX)
        guard let t = tx else { return }
        device.notifyRequest(t)
    }
    
    func disconnect() {
        if (blDevice != nil) {
            //	UUID_DEMO_SERVICEサービスを持っているデバイスから切断する
            blBase.disconnectService(uuidVspService)
            blDevice = nil
            //	周りのBLEデバイスからのadvertise情報のスキャンを開始する
            blBase.scanDevices(nil)
        }
    }
    
    func increseWater(byte: UInt8) {
        print(byte)
        
        if byte > 170 {
            loader.progress = 1
            loader.removeLoader()
        } else if byte > 150 {
            loader.progress = 0.6
        } else if byte > 130 {
            loader.progress = 0.3
        }
    }
}


extension ViewController: BLEDeviceClassDelegate {
    
    func didUpdateValueForCharacteristic(device: BLEDeviceClass!, characteristic: CBCharacteristic!) {
        guard let vld = blDevice else { return }
        
        if device == vld {
            let rx = vld.getCharacteristic(uuidVspService, characteristic: uuidRX)
            
            if characteristic == rx {
                let _ = characteristic.value?.bytes
                return
            }
            
            let tx = vld.getCharacteristic(uuidVspService, characteristic: uuidTX)
            if characteristic == tx {
                guard let data = characteristic.value else { return }
                var bytes = [UInt8](count:data.length, repeatedValue:0)
                data.getBytes(&bytes, length:data.length)
                increseWater(bytes[0])
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func startCamera() {
        let sourceType = UIImagePickerControllerSourceType.Camera
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) { return }

        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = sourceType
        cameraPicker.delegate = self
        self.presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)

        let logoImage = UIImage(named: "SWEATOUT-logo-1")!
        let shirtImage = UIImage(named: "SWEATOUT-photo-1")!

        UIGraphicsBeginImageContext(image.size)
        image.drawInRect(CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
        shirtImage.drawInRect(CGRect(x: -800, y: -900, width: 5000, height: 5000))
        logoImage.drawInRect(CGRect(x: 2100, y: 3200, width: 1000, height: 1000))
        let mergeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()

        UIImageWriteToSavedPhotosAlbum(mergeImage, self, nil, nil)
        showTweetAlertWithImage(mergeImage)
    }
}

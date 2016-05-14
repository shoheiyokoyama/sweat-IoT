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

class ViewController: UIViewController, BLEDeviceClassDelegate {

    let uuidVspService = "569a1101-b87f-490c-92cb-11ba5ea5167c"
    let uuidRX = "569a2001-b87f-490c-92cb-11ba5ea5167c"
    let uuidTX = "569a2000-b87f-490c-92cb-11ba5ea5167c"
    
    var blBase = BLEBaseClass()
    var blDevice: BLEDeviceClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blBase.scanDevices(nil)
        blDevice = nil
    }
    
    @IBAction func tappedButton(sender: AnyObject) {
        self.connect()

//        let tweetView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//
//        tweetView.setInitialText("Twitter Test from Swift")
//        
//        myComposeView.addImage(UIImage(named: "oouchi.jpg"))
//        // myComposeViewの画面遷移.
//        self.presentViewController(tweetView, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //------------------------------------------------------------------------------------------
    // BLEDeviceClassDelegate
    // readもしくはindicateもしくはnotifyにてキャラクタリスティックの値を読み込んだ時に呼ばれる
    //------------------------------------------------------------------------------------------
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
                print(bytes[0])
            }
        }
    }
}



















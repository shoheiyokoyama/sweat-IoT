//
//  ViewController.swift
//  SweatOut
//
//  Created by Hanawa Takuro on 2016/05/14.
//  Copyright © 2016年 Hanawa Takuro. All rights reserved.
//

import UIKit
import CoreBluetooth

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
                var buf = characteristic.value?.bytes
                return
            }
            
            let tx = vld.getCharacteristic(uuidVspService, characteristic: uuidTX)
            if characteristic == tx {
                var buf = characteristic.value?.bytes
                //            buf[0]
                return
            }
        }
    }
}



















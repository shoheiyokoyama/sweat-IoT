//
//  ViewController.swift
//  SweatOut
//
//  Created by Hanawa Takuro on 2016/05/14.
//  Copyright © 2016年 Hanawa Takuro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //BLEDeviceClassDelegate

    static let uuidVspService = "569a1101-b87f-490c-92cb-11ba5ea5167c"
    static let uuidRX = "569a2001-b87f-490c-92cb-11ba5ea5167c"
    static let uuidTX = "569a2000-b87f-490c-92cb-11ba5ea5167c"
    
    var blBase = BLEBaseClass()
    var device: BLEDeviceClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blBase.scanDevices(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func connect() {
        
    }
    
    func disconnect() {
        
    }
    
    //------------------------------------------------------------------------------------------
    // BLEDeviceClassDelegate
    // readもしくはindicateもしくはnotifyにてキャラクタリスティックの値を読み込んだ時に呼ばれる
    //------------------------------------------------------------------------------------------
    func didUpdateValueForCharacteristic(device: BLEDeviceClass!, characteristic: CBCharacteristic!) {
        return
    }
    
}


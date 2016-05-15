//
//  LastViewController.swift
//  SweatOut
//
//  Created by 横山祥平 on 2016/05/15.
//  Copyright © 2016年 Hanawa Takuro. All rights reserved.
//

import UIKit
import Social

class LastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func tap(sender: AnyObject) {
        startCamera()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func showTweetAlertWithImage(image: UIImage) {
        let tweetView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        tweetView.setInitialText("#SweatOutChallenge")
        tweetView.addImage(image)
        self.presentViewController(tweetView, animated: true, completion: nil)
    }

}

extension LastViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func startCamera() {
        let sourceType = UIImagePickerControllerSourceType.Camera
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) { return }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = sourceType
        cameraPicker.delegate = self
        
        
//        let navigationController = UINavigationController(rootViewController: cameraPicker)
//        self.showViewController(navigationController, sender: nil)
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
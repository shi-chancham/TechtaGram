//
//  ViewController.swift
//  TechtaGram
//
//  Created by 高橋詩穂 on 2016/01/19.
//  Copyright © 2016年 Shiho Takahashi. All rights reserved.
//

import UIKit

import AssetsLibrary

import Accounts

class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var cameraImageView: UIImageView!
    
    var originalImage : UIImage!
    
    var filter : CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePhoto(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            
            picker.allowsEditing = true
            
            presentViewController(picker, animated: true, completion: nil)
        }
        else{
            print("error")
        }
    }
    
    @IBAction func savePhoto(){
        
        let imageToSave = filter.outputImage!
        let softwareContext = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        let cgimg = softwareContext.createCGImage(imageToSave, fromRect: imageToSave.extent)
        let library = ALAssetsLibrary()
        library.writeImageToSavedPhotosAlbum(cgimg,metadata: imageToSave.properties,completionBlock: nil)
    }
    
    @IBAction func colorFilter(){
        
        let filterImage : CIImage = CIImage(image: originalImage)!
        
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        filter.setValue(1.0, forKey: "inputSaturation")
        filter.setValue(0.5, forKey: "inputBrightness")
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, fromRect: filter.outputImage!.extent)
        cameraImageView.image = UIImage(CGImage: cgImage)
    }
    
    @IBAction func openAlbum(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            picker.allowsEditing = true
            
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func snsPost(){
        let shareText = "写真を加工したよ！"
        let shareImage = cameraImageView.image!
        
        let activityItems = [shareText,shareImage]
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludedActivityTypes = [
            UIActivityTypePostToWeibo,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypePrint
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let i = info[UIImagePickerControllerEditedImage] as! UIImage
        cameraImageView.image = i
        
        
        originalImage = cameraImageView.image
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}


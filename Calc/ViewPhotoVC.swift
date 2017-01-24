//
//  ViewPhotoVC.swift
//  Calc
//
//  Created by Evgeniy Kolesin on 21.09.16.
//  Copyright © 2016 Evgeniy Kolesin. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AssetsLibrary
import Photos

class ViewPhotoVC: UIViewController {
    
    var assetCollection: PHAssetCollection!
    var photoAsset: PHFetchResult<PHAsset>!
    var index: Int = 0

    
    @IBAction func btnCancel(_ sender: AnyObject) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func btnExport(_ sender: AnyObject) {
    }
    
    @IBAction func btnTrash(_ sender: AnyObject) {
       
        /*
        let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this image?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(alertAction)in
            PHPhotoLibrary.shared().performChanges({
            //Delete Photo
                if let request = PHAssetCollectionChangeRequest(for: self.assetCollection){
                    request.removeAssets([self.photosAsset[self.index]])
                    
                }},completionHandler: {(success, error)in
                    NSLog("\nDeleted Image -> %@", (success ? "Success":"Error!"))
                        alert.dismiss(animated: true, completion: nil)
                            if(success){
                        // Move to the main thread to execute
                    DispatchQueue.main.asynchronously(execute: {
                        self.photoAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)
                        if(self.photosAsset.count == 0){
                            print("No Images Left!!")
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        }else{
                            
                            if(self.index >= self.photosAsset.count){
                                self.index = self.photosAsset.count - 1
                            }
                            self.displayPhoto()
                        }})
                            }else{
                                print("Error: \(error)")
                    }})
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {(alertAction)in
            //Do not delete photo
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        */
    }
 
    @IBOutlet var imgView: UIImageView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnTap = true    //!!Added Optional Chaining
        
        self.displayPhoto()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayPhoto(){
        // Set targetSize of image to iPhone screen size
        let screenSize: CGSize = UIScreen.main.bounds.size
        let targetSize = CGSize.init(width: 100, height: 100)
        
        let imageManager = PHImageManager.default()
        if let asset = self.photoAsset[self.index] as? PHAsset{
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil, resultHandler: {
                (result, info)->Void in
                self.imgView?.image = result
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

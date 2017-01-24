//
//  PhotoVC.swift
//  Calc
//
//  Created by Evgeniy Kolesin on 08.09.16.
//  Copyright © 2016 Evgeniy Kolesin. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AssetsLibrary
import Photos

let reuseIdentifier = "PhotoCell"
let albumName = "Easycalc"

class PhotoVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var albumFound: Bool = false
    var assetCollection: PHAssetCollection! = PHAssetCollection()
    var photoAsset: PHFetchResult<PHAsset>!
    var assetThumbnailSize:CGSize!
    
    @IBOutlet var menuButton: UIButton!
    
    @IBOutlet var noPhotosLabel: UILabel!
    
    @IBAction func btnCamera(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            let picker: UIImagePickerController!
            picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.mediaTypes = [kUTTypeImage as NSString as String]
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnPhotoAlbum(_ sender: AnyObject) {
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.delegate = self
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)

    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Check if the folder exists, if not, create it
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        if(collection.firstObject != nil){
            //found the album
            self.albumFound = true
            self.assetCollection = collection.firstObject! as PHAssetCollection
        }else{
            
            //Album placeholder for the asset collection, used to reference collection in completion handler
            var albumPlaceholder:PHObjectPlaceholder!
            
            //create the folder
            NSLog("\nFolder \"%@\" does not exist\nCreating now...", albumName)
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                albumPlaceholder = request.placeholderForCreatedAssetCollection
            },
         completionHandler: {(success:Bool, error:Error?)in
            if(success){
                print("Successfully created folder")
                self.albumFound = true
                let collection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
                self.assetCollection = collection.firstObject! as PHAssetCollection?
            }else{
                print("Error creating folder")
                self.albumFound = false
                                                    }
            })
            
        }
        
        func viewWillAppear(animated: Bool){
            // Get size of the collectionView cell for thumbnail image
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
                _ = layout.itemSize
                self.assetThumbnailSize = CGSize.init(width: 100, height: 100)
            }
            
            //fetch the photos from collection
            self.navigationController?.hidesBarsOnTap = false   //!! Use optional chaining
            self.photoAsset = PHAsset.fetchAssets(in: self.assetCollection, options: nil)
            
            
            if let photoCnt = self.photoAsset?.count{
                if(photoCnt == 0){
                    self.noPhotosLabel.isHidden = false
                }else{
                    self.noPhotosLabel.isHidden = true
                }
            }
            self.collectionView.reloadData()
        }
        
        
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier! as String == "viewLargePhoto"){
            
            if let controller:ViewPhotoVC = segue.destination as? ViewPhotoVC{
            if let cell = sender as? UICollectionViewCell{
                    if let indexPath: NSIndexPath = self.collectionView.indexPath(for: cell) as NSIndexPath?{
                        controller.index = indexPath.item
                        controller.photoAsset = self.photoAsset
                        controller.assetCollection = self.assetCollection
                    }
                }
            }
        }
    }
        
    

    //UICollectionViewDataSource Methods
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int = 0
        if(self.photoAsset != nil){
            count = self.photoAsset.count
        }
        return count
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    let cell: PhotoThumbnail = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoThumbnail
        
        //Modyfy the cell
        let asset: PHAsset = self.photoAsset[indexPath.item] as PHAsset
        
        // Create options for retrieving image (Degrades quality if using .Fast)
        //        let imageOptions = PHImageRequestOptions()
        //        imageOptions.resizeMode = PHImageRequestOptionsResizeMode.Fast
        PHImageManager.default().requestImage(for: asset, targetSize: self.assetThumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: {(result, info) in
                cell.setThumbnailImage(thumbnailImage: result!)
        })
        return cell
    }

   
     //UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 1
    }
    
    
    //  UIImagePickerControllerDelegateMethods
    
     private func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [String : NSDictionary]){
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        PHPhotoLibrary.shared().performChanges({
            
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection, assets: self.photoAsset)
            //albumChangeRequest.addAssets([assetPlaceholder])
            
            
            }, completionHandler: {(sucess, error)in
                
                NSLog("Adding Image to Library -> &@", (sucess ? "Success": "Error!"))
                picker.dismiss(animated: true, completion: nil)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
    }
     /*
    */
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   // override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}
    

}

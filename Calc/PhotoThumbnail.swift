//
//  PhotoThumbnail.swift
//  Calc
//
//  Created by Евгений Колесин on 27.09.16.
//  Copyright © 2016 Evgeniy Kolesin. All rights reserved.
//

import UIKit

class PhotoThumbnail: UICollectionViewCell {
    
    @IBOutlet var imgView: UIImageView!
    
    func setThumbnailImage(thumbnailImage: UIImage){
        self.imgView.image = thumbnailImage
    }
}

//
//  PhotosCollectionViewCell.swift
//  InstaBostaTask
//
//  Created by Abdallah on 01/02/2023.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    func set(photo:Photos){
        self.userPhotoImageView.loadImageUsingCacheWithURLString(photo.url, placeHolder: UIImage(named: "no_image_placeholder"))
    }
}

//
//  AlbumCollectionViewCell.swift
//  PicUp
//
//  Created by Charlie Kim on 2018. 2. 18..
//  Copyright © 2018년 Charlie Kim. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    
    weak var album: Album!
    
    func setAlbum(_ album: Album) {
        self.album = album
        
        albumNameLabel.text = self.album.albumName
        albumImageView.image = UIImage(named: self.album.albumImageName)
        
        albumImageView.layer.cornerRadius = 12.5
    }
}

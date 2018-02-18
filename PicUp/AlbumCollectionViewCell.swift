//
//  AlbumCollectionViewCell.swift
//  PicUp
//
//  Created by Charlie Kim on 2018. 2. 18..
//  Copyright © 2018년 Charlie Kim. All rights reserved.
//

import UIKit

protocol AlbumCellDelegate: class {
    func delete(cell: AlbumCollectionViewCell)
}

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var album: Album!
    weak var delegate: AlbumCellDelegate?
    
    var isEditing: Bool = false {
        didSet {
            deleteButton.isHidden = !isEditing
        }
    }
    
    func setAlbum(_ album: Album) {
        self.album = album
        
        albumNameLabel.text = self.album.albumName
        albumImageView.image = UIImage(named: self.album.albumImageName)
        
        albumImageView.layer.cornerRadius = 12.5
        deleteButton.layer.cornerRadius = deleteButton.frame.width / 2.0
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.delete(cell: self)
    }
}

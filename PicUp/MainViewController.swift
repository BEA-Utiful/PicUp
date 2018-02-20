//
//  MainViewController.swift
//  PicUp
//
//  Created by Charlie Kim on 2018. 2. 18..
//  Copyright © 2018년 Charlie Kim. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AlbumCellDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var albums : [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Albums"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AlbumDetailViewController
        let senderCell = sender as! AlbumCollectionViewCell
        
        destination.album = senderCell.album
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !isEditing
    }
 
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.navigationItem.leftBarButtonItem?.isEnabled = !editing
        
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! AlbumCollectionViewCell
            cell.isEditing = editing
        }
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell

        let album = albums[indexPath.row]
        cell.setAlbum(album)
        cell.isEditing = isEditing
        cell.delegate = self
        
        return cell
    }
    
    
    // MARK: AlbumCellDelegate
    func delete(cell: AlbumCollectionViewCell) {
        let alertController : UIAlertController
        let albumName = cell.albumNameLabel.text!
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            alertController = UIAlertController(title: "Delete \"\(albumName)\"", message: "Are you sure you want to delete the album \"\(albumName)\"?", preferredStyle: .actionSheet)
        } else {
            alertController = UIAlertController(title: "Delete \"\(albumName)\"", message: "Are you sure you want to delete the album \"\(albumName)\"?", preferredStyle: .alert)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
            if let indexPath = self.collectionView.indexPath(for: cell) {
                self.albums.remove(at: indexPath.row)
                self.collectionView.reloadData()
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: Member Methods
    @objc func addButtonPressed() {
        let alertController = UIAlertController(title: "New Album", message: "Enter new album  name", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let albumName = alertController.textFields?.first?.text {
                self.albums.append(Album(named: albumName, imageNamed: "test.png"))
                self.collectionView.reloadData()
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}

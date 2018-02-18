//
//  MainViewController.swift
//  PicUp
//
//  Created by Charlie Kim on 2018. 2. 18..
//  Copyright © 2018년 Charlie Kim. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var albums : [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Albums"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
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
 

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell

        let album = albums[indexPath.row]
        cell.setAlbum(album)
        
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    
    
    
    // MARK: Member Methods
    @objc func addButtonPressed() {
        albums.append(Album(named: "Test", imageNamed: "test.png"))
        collectionView.reloadData()
    }
}

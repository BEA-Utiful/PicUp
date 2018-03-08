//
//  AlbumDetailViewController.swift
//  PicUp
//
//  Created by Charlie Kim on 2018. 2. 18..
//  Copyright © 2018년 Charlie Kim. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DownloadModalViewDelegate {
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var thumnailCollectionView: UICollectionView!
    
    var images: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        thumnailCollectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressGesture(gesture:))))
        
        let downloadModalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "downloadModalViewController") as! DownloadModalViewController
        
        downloadModalViewController.title = self.navigationItem.title
        downloadModalViewController.delegate = self
        
        present(downloadModalViewController, animated: true, completion: nil)
    }
    
    func downloadModalView(_ downloadModalView: DownloadModalViewController, downloadFinished: Bool) {
        print("Download Finished")
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let imagesPath = documentsURL?.appendingPathComponent(self.navigationItem.title!).path
        
        do {
            images = try FileManager.default.contentsOfDirectory(atPath: imagesPath!)
        } catch {
            images = []
        }
        
        photoCollectionView.reloadData()
        thumnailCollectionView.reloadData()
    }
    
    @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = thumnailCollectionView.indexPathForItem(at: gesture.location(in: thumnailCollectionView)) else {
                break
            }
            
            thumnailCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            thumnailCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            thumnailCollectionView.endInteractiveMovement()
        default:
            thumnailCollectionView.cancelInteractiveMovement()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func showAllButtonPressed() {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        thumnailCollectionView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

 
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let imagesPath = documentsURL?.appendingPathComponent(self.navigationItem.title!).path
        
        if collectionView == photoCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumDetailPhotoCell", for: indexPath) as! AlbumDetailPhotoCollectionViewCell
            
            cell.imageView.image = UIImage(contentsOfFile: "\(imagesPath!)/\(images[indexPath.row])")
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumDetailCell", for: indexPath) as! AlbumDetailCollectionViewCell
            
            cell.imageView.image = UIImage(contentsOfFile: "\(imagesPath!)/\(images[indexPath.row])")
            
            return cell
        }
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        thumnailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        photoCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return collectionView == thumnailCollectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if collectionView == thumnailCollectionView {
            let temp = images[sourceIndexPath.row]
            images[sourceIndexPath.row] = images[destinationIndexPath.row]
            images[destinationIndexPath.row] = temp
            
            photoCollectionView.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == thumnailCollectionView {
            if let indexPath = thumnailCollectionView.indexPathForItem(at: CGPoint(x: thumnailCollectionView.center.x + thumnailCollectionView.contentOffset.x, y: 25)) {
                photoCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == photoCollectionView {
            if let indexPath = photoCollectionView.indexPathsForVisibleItems.first {
                thumnailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == photoCollectionView {
            return collectionView.frame.size
        } else {
            return CGSize(width: 25, height: 50)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var insets = self.thumnailCollectionView.contentInset
        let value = (self.view.frame.size.width - (self.thumnailCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
        
        insets.left = value
        insets.right = value
        self.thumnailCollectionView.contentInset = insets
        self.thumnailCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
}

//
//  AlbumDetailViewController.swift
//  PicUp
//
//  Created by Charlie Kim on 2018. 2. 18..
//  Copyright © 2018년 Charlie Kim. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DownloadModalViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        collectionView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func showAllButtonPressed() {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumDetailCell", for: indexPath) as! AlbumDetailCollectionViewCell
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let imagesPath = documentsURL?.appendingPathComponent(self.navigationItem.title!).path
        
        cell.imageView.image = UIImage(contentsOfFile: "\(imagesPath!)/\(images[indexPath.row])")
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width - 12) / 4.0
        
        return CGSize(width: width, height: width)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var insets = self.collectionView.contentInset
        let value = (self.view.frame.size.width - (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
        
        insets.left = value
        insets.right = value
        self.collectionView.contentInset = insets
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
}

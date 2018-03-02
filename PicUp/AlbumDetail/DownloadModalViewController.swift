//
//  DownloadModalViewController.swift
//  PicUp
//
//  Created by Charlie Kim on 2018. 3. 2..
//  Copyright © 2018년 Charlie Kim. All rights reserved.
//

import UIKit

protocol DownloadModalViewDelegate {
    func downloadModalView(_ downloadModalView: DownloadModalViewController, downloadFinished: Bool)
}

class DownloadModalViewController: UIViewController {
    @IBOutlet weak var downloadProgressView: UIProgressView!
    
    var delegate: DownloadModalViewDelegate?
    
    var totalProgress: Int = 0
    var currentProgress: Int = 0
    var errorCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        downloadProgressView.setProgress(0.0, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadImages(from: "https://charlie.kim/photo")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func loadImages(from url: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let imagesPath = documentsURL?.appendingPathComponent(self.title!).path
        
        let downloadedCount: Int

        do {
            try FileManager.default.createDirectory(atPath: imagesPath!, withIntermediateDirectories: false, attributes: nil)
            downloadedCount = 0
        } catch {
            downloadedCount = try! FileManager.default.contentsOfDirectory(atPath: imagesPath!).count
        }
        
        if let imageURL = URL(string: url) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            do {
                let contents = try String(contentsOf: imageURL)
                totalProgress = (contents.components(separatedBy: "jpg").count - 1) / 2
                
                if downloadedCount == totalProgress {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    dismiss(animated: true, completion: nil)
                    if let callback = delegate {
                        callback.downloadModalView(self, downloadFinished: true)
                    }
                    return
                }
                
                let splited = contents.split(separator: "\"")
                
                for subStr in splited {
                    if subStr.hasSuffix(".jpg") {
                        if !FileManager.default.fileExists(atPath: "\(imagesPath!)/\(subStr)") {
                            downloadImage(from: "\(url)/\(subStr)", named: "\(subStr)")
                        }
                    }
                }
            } catch {
                print("Cannot get contents from \(url)")
            }
        }
    }
    
    func downloadImage(from url: String, named imageName: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let imagesPath = documentsURL?.appendingPathComponent(self.navigationItem.title!)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                try data.write(to: (imagesPath?.appendingPathComponent(imageName))!, options: .atomic)
                self.currentProgress += 1
                
                DispatchQueue.main.async {
                    self.downloadProgressView.setProgress(Float(self.currentProgress) / Float(self.totalProgress), animated: true)
                    
                    if self.currentProgress == self.totalProgress {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.dismiss(animated: true, completion: nil)
                        if let callback = self.delegate {
                            callback.downloadModalView(self, downloadFinished: true)
                        }
                    }
                }
            } catch {
                print("Failed to save image named \(imageName)")
                self.downloadImage(from: url, named: imageName)
            }
        })

        task.resume()
    }
}

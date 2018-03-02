//
//  PhotoSelectViewController.swift
//  PicUp
//
//  Created by Charlie Kim on 2018. 2. 25..
//  Copyright © 2018년 Charlie Kim. All rights reserved.
//

import UIKit

class PhotoSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

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

    @IBAction func likeButtonPressed(_ sender: Any) {
        print("Like Button Pressed")
    }
    
    @IBAction func considerButtonPressed(_ sender: Any) {
        print("Hello")
    }
    
    @IBAction func dislikeButtonPressed(_ sender: Any) {
        print("Dislike Button Pressed")
    }
}

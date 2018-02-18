//
//  Album.swift
//  PicUp
//
//  Created by Charlie Kim on 2018. 2. 18..
//  Copyright © 2018년 Charlie Kim. All rights reserved.
//

import UIKit

class Album: NSObject {
    var albumName : String
    var albumImageName : String
    
    init(named: String, imageNamed: String) {
        albumName = named
        albumImageName = imageNamed
    }
}

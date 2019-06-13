//
//  Snack.swift
//  StretchySnacks
//
//  Created by Luiz on 6/13/19.
//  Copyright © 2019 Luiz. All rights reserved.
//


import UIKit

struct Snack {
    var name : String
    var image : UIImage?

    init(For name: String,  imageName : String) {
        self.name = name
        self.image = UIImage.init(named:  imageName)
    }
}

//
//  WebGalleryCellModel.swift
//  WebGallery
//
//  Created by kathelyss on 14/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

class WebGalleryCellModel {
    var image: UIImage!
    var name: String!
    
    init(image: UIImage, name: String) {
        self.image = image
        self.name = name
    }
}

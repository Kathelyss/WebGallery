//
//  WebGalleryDataSourse.swift
//  WebGallery
//
//  Created by kathelyss on 14/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

struct WebGalleryDataSourse {
    var cats: [WebGalleryCellModel] = []
    var dogs: [WebGalleryCellModel] = []
    
    mutating func createModels() {
        for _ in (0...11) {
            self.cats.append(WebGalleryCellModel(image: #imageLiteral(resourceName: "kitten"), name: "Kitten"))
            self.dogs.append(WebGalleryCellModel(image: #imageLiteral(resourceName: "dog"), name: "Puppy"))
        }
    }
}

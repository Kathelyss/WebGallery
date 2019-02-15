//
//  GalleryModel.swift
//  WebGallery
//
//  Created by kathelyss on 15/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import Foundation

struct GalleryModel: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [ImageModel]
}

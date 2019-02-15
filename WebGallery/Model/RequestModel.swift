//
//  RequestModel.swift
//  WebGallery
//
//  Created by kathelyss on 15/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import Foundation

struct RequestModel: Codable {
    let photos: GalleryModel
    let stat: String
}

//
//  ImageModel.swift
//  WebGallery
//
//  Created by kathelyss on 15/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import Foundation

struct ImageModel: Codable {
    let title: String
    let farm: Int
    let server: String
    let id: String
    let secret: String
}

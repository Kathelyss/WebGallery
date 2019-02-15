//
//  WebGalleryDataSourse.swift
//  WebGallery
//
//  Created by kathelyss on 14/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

class WebGalleryDataSourse {
    var items: [ImageModel] = []
    let connection = ServerConnection()
    
    var onLoadItems: (() -> Void)?
    
    func getItems(galleryId: String) {
        connection.requestGallery(id: galleryId) { response in
            self.items = response.photos.photo
            self.onLoadItems?()
        }
    }
    
    func clear() {
        items.removeAll()
        onLoadItems?()
    }

}

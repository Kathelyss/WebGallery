//
//  ImageVC.swift
//  WebGallery
//
//  Created by kathelyss on 15/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {
    @IBOutlet var backView: UIView!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20

    }
}

//
//  ImageVC.swift
//  WebGallery
//
//  Created by kathelyss on 15/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var imageView: UIImageView!
   
    var image: UIImage = #imageLiteral(resourceName: "logo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        imageView.image = image
//        let photoBlurEffect = UIBlurEffect(style: .light)
//        let photoBlurView = UIVisualEffectView(effect: photoBlurEffect)
//        photoBlurView.frame = imageView.bounds
//        imageView.addSubview(photoBlurView)
    }
    
    @objc
    func close() {
        dismiss(animated: true, completion: nil)
    }
}

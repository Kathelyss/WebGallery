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
   
    var serverImage: ServerImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        guard let image = serverImage else { return }

        let connection = ServerConnection()
        connection.getPhoto(image, size: .large) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
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

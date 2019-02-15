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
   
    var smallImage: UIImage?
    var imageModel: ImageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        imageView.image = smallImage
        let photoBlurEffect = UIBlurEffect(style: .light)
        let photoBlurView = UIVisualEffectView(effect: photoBlurEffect)
        photoBlurView.frame = imageView.bounds
        imageView.addSubview(photoBlurView)
        guard let image = imageModel else { return }

        let connection = ServerConnection()
        connection.requestImage(image, size: .large) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
                photoBlurView.removeFromSuperview()
            }
        }
    }
    
    @objc
    func close() {
        dismiss(animated: true, completion: nil)
    }
}

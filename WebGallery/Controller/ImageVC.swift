//
//  ImageVC.swift
//  WebGallery
//
//  Created by kathelyss on 15/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var smallImage: UIImage?
    var imageModel: ImageModel?
    var backGroundBlur: BlurView?
    var imageBlur: BlurView?
    let circlePulsatorView = CirclePulsator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        imageView.image = smallImage
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if backGroundBlur == nil {
            backGroundBlur = BlurView()
            backGroundBlur?.frame = view.bounds
            view.insertSubview(backGroundBlur!, belowSubview: imageView)
            backGroundBlur?.blur()
        }
        
        if imageBlur == nil {
            imageBlur = BlurView()
            imageBlur?.frame = imageView.bounds
            imageView.addSubview(imageBlur!)
            imageBlur?.blur()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let imageModel = imageModel else { return }
        
        let connection = ServerConnection()
        connection.requestImage(imageModel, size: .large) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
                self.circlePulsatorView.isPulsating = false
                self.imageBlur?.unblur()
            }
        }
    }
    
    @objc
    func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension ImageVC: UIViewControllerTransitioningDelegate {
    
}


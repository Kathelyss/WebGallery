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
    var backGroundBlur: BlurryOverlayView?
    var imageBlur: BlurryOverlayView?
    let circlePulsatorView = CirclePulsator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        imageView.image = smallImage
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if backGroundBlur == nil {
            backGroundBlur = BlurryOverlayView()
            backGroundBlur?.frame = view.bounds
            view.insertSubview(backGroundBlur!, belowSubview: imageView)
            backGroundBlur?.blurIn()
        }
        
        if imageBlur == nil {
            imageBlur = BlurryOverlayView()
            imageBlur?.frame = imageView.bounds
            imageView.addSubview(imageBlur!)
            imageBlur?.blurIn()
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
                self.imageBlur?.blurOut(duration: 0.2)
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

class BlurryOverlayView: UIVisualEffectView {
    private var animator: UIViewPropertyAnimator!
    private var delta: CGFloat = 0 // The amount to change fractionComplete for each tick
    private var target: CGFloat = 0 // The fractionComplete we're animating to
    private(set) var isBlurred = false
    private var displayLink: CADisplayLink!
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        effect = nil // Starts out with no blur
        isHidden = true // Enables user interaction through the view
        
        // The animation to add an effect
        animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
            self.effect = UIBlurEffect(style: .light)
        }
        animator.pausesOnCompletion = true // Fixes background bug
        
        // Using a display link to animate animator.fractionComplete
        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink.isPaused = true
        displayLink.add(to: .main, forMode: .common)
    }
    
    func blurIn(amount: CGFloat = 0.05, duration: TimeInterval = 0.01) {
        guard isBlurred == false else { return }
        
        isHidden = false // Disable user interaction
        
        target = amount
        delta = amount / (60 * CGFloat(duration)) // Assuming 60hz refresh rate
        
        // Start animating fractionComplete
        displayLink.isPaused = false
    }
    
    func blurOut(duration: TimeInterval = 0.01) {
        guard isBlurred else { return }
        
        target = 0
        delta = -1 * animator.fractionComplete / (60 * CGFloat(duration)) // Assuming 60hz refresh rate
        
        // Start animating fractionComplete
        displayLink.isPaused = false
    }
    
    @objc private func tick() {
        animator.fractionComplete += delta
        
        if isBlurred && animator.fractionComplete <= 0 {
            // Done blurring out
            isBlurred = false
            isHidden = true
            displayLink.isPaused = true
        } else if isBlurred == false && animator.fractionComplete >= target {
            // Done blurring in
            isBlurred = true
            displayLink.isPaused = true
        }
    }
}

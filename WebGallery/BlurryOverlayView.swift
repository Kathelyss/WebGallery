//
//  BlurryOverlayView.swift
//  WebGallery
//
//  Created by kathelyss on 18/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

class BlurView: UIVisualEffectView {
    private var animator: UIViewPropertyAnimator!
    private var delta: CGFloat = 0 // amount to change fractionComplete for each tick
    private var targetFractionComplete: CGFloat = 0
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
        effect = nil
        isHidden = true
        animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
            self.effect = UIBlurEffect(style: .light)
        }
        animator.pausesOnCompletion = true
        
        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink.isPaused = true
        displayLink.add(to: .main, forMode: .common)
    }
    
    func blurIn(amount: CGFloat, duration: TimeInterval) {
        guard isBlurred == false else { return }
        
        isHidden = false
        targetFractionComplete = amount
        delta = amount / (60 * CGFloat(duration)) // Assuming 60hz refresh rate
        displayLink.isPaused = false // start animating fractionComplete
    }
    
    func blurOut(duration: TimeInterval) {
        guard isBlurred else { return }
        
        targetFractionComplete = 0
        delta = -1 * animator.fractionComplete / (60 * CGFloat(duration)) // Assuming 60hz refresh rate
        displayLink.isPaused = false // start animating fractionComplete
    }
    
    @objc private func tick() {
        animator.fractionComplete += delta
        
        if isBlurred && animator.fractionComplete <= 0 { // done blurring out
            isBlurred = false
            isHidden = true
            displayLink.isPaused = true
        } else if isBlurred == false && animator.fractionComplete >= targetFractionComplete { // done blurring in
            isBlurred = true
            displayLink.isPaused = true
        }
    }
}

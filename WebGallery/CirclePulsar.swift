//
//  CirclePulsar.swift
//  WebGallery
//
//  Created by kathelyss on 18/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

struct CircleSize {
    static let min: CGFloat = 25.0
    static let max: CGFloat = 50.0
}

class CirclePulsator: UIView {
    var pulsarView = UIView()
    var isPulsating: Bool = true {
        didSet {
            endPulsations()
        }
    }
    
    func setupViews() {
        let pulsarOrigin = CGPoint(x: self.bounds.midX - CircleSize.min / 2,
                                   y: self.bounds.midY - CircleSize.min / 2)
        pulsarView.layer.masksToBounds = true
        pulsarView.layer.cornerRadius = CircleSize.min / 2
        pulsarView.layer.borderWidth = 3
        pulsarView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4).cgColor
        
        pulsarView.frame = CGRect(origin: pulsarOrigin, size: CGSize(width: CircleSize.min, height: CircleSize.min))
        self.addSubview(pulsarView)
        pulsarView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    }
    
    func startPulsations(from minSize: CGFloat, to maxSize: CGFloat) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                self.pulsarView.frame = CGRect(x: self.bounds.midX - minSize / 2, y: self.bounds.midY - minSize / 2,
                                               width: minSize, height: minSize)
                self.pulsarView.layer.cornerRadius = minSize / 2
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                
                self.pulsarView.frame = CGRect(x: self.bounds.midX - maxSize / 2, y: self.bounds.midY - maxSize / 2,
                                               width: maxSize, height: maxSize)
                self.pulsarView.layer.cornerRadius = maxSize / 2
            })
        }) { _ in
            if self.isPulsating {
                self.startPulsations(from: CircleSize.min, to: CircleSize.max)
            }
        }
    }
    
    func endPulsations() {
        let finalWidth = self.bounds.width
        let finalAnimation = UIViewPropertyAnimator.init(duration: 0.2, curve: .easeInOut) {
            self.pulsarView.frame = CGRect(x: self.bounds.midX - finalWidth / 2, y: self.bounds.midY - finalWidth / 2,
                                           width: finalWidth, height: finalWidth)
            self.pulsarView.layer.cornerRadius = finalWidth / 2
            self.pulsarView.alpha = 0.0
        }
        finalAnimation.addCompletion { _ in
            self.pulsarView.removeFromSuperview()
        }
        finalAnimation.startAnimation()
    }
    
}

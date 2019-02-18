//
//  CollectionViewLayout.swift
//  WebGallery
//
//  Created by kathelyss on 18/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

enum SlidingDirection {
    case left, right
}

class SlidingLayout: UICollectionViewFlowLayout {
    var reloadingIndexPath = Set<IndexPath>()
    var transitionDirection: SlidingDirection = .left
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        reloadingIndexPath.removeAll()
        
        for update in updateItems {
            if let indexPath = update.indexPathAfterUpdate,
                update.updateAction == .reload {
                reloadingIndexPath.insert(indexPath)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        reloadingIndexPath.removeAll()
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        if reloadingIndexPath.contains(itemIndexPath) {
            let x = transitionDirection == .left ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width
            let transform = CGAffineTransform(translationX: x, y: 0)
            attributes?.transform = transform
            attributes?.alpha = 1
        }
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        if reloadingIndexPath.contains(itemIndexPath) {
            let x = transitionDirection == .left ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width
            let transform = CGAffineTransform(translationX: x, y: 0)
            attributes?.transform = transform
            attributes?.alpha = 0
        }
        
        return attributes
    }
}

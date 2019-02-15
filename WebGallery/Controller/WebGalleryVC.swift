//
//  WebGalleryVC.swift
//  WebGallery
//
//  Created by kathelyss on 14/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

class WebGalleryVC: UIViewController {
    struct Constant {
        static let collectionViewColumnsCount: Int = 3
        static let collectionViewCellsSpacing: CGFloat = 8
        static let cellRatioHeightToWidth: CGFloat = 1.5
    }

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var firstCategoryButton: UIButton!
    @IBOutlet var secondCategoryButton: UIButton!
    @IBOutlet var selectionIndicator: UIView!
    @IBOutlet var selectorIndicatorFirstCategoryConstraint: NSLayoutConstraint!
    @IBOutlet var selectorIndicatorSecondCategoryConstraint: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    
    var dataSource = WebGalleryDataSourse()
    var choosenCategory = PhotoCategory.first
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        let cellNib = UINib.init(nibName: "WebGalleryCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "WebGalleryCell")
       
        dataSource.onLoadItems = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        dataSource.clear()
        dataSource.getItems(galleryId: "72157704515204635")
    }
    
    @IBAction func tapFirstCategoryButton(_ sender: UIButton) {
        choosenCategory = .first
        selectorIndicatorFirstCategoryConstraint.isActive = true
        selectorIndicatorSecondCategoryConstraint.isActive = false
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
        animator.startAnimation()
        firstCategoryButton.titleLabel?.font = UIFont.bold
        secondCategoryButton.titleLabel?.font = UIFont.normal
        
        dataSource.clear()
        dataSource.getItems(galleryId: "72157704515204635")
        // nice transition
    }
    
    @IBAction func tapSecondCategoryButton(_ sender: UIButton) {
        choosenCategory = .second
        selectorIndicatorFirstCategoryConstraint.isActive = false
        selectorIndicatorSecondCategoryConstraint.isActive = true
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
        animator.startAnimation()
        firstCategoryButton.titleLabel?.font = UIFont.normal
        secondCategoryButton.titleLabel?.font = UIFont.bold
        
        dataSource.clear()
        dataSource.getItems(galleryId: "72157662070816797")
        // nice transition
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ImageVC,
            let sender = sender as? IndexPath,
            let cell = collectionView.cellForItem(at: sender) as? WebGalleryCell {
            vc.imageModel = dataSource.items[sender.row]
            vc.smallImage = cell.imageView.image
        }
    }
}

extension WebGalleryVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToImageVC", sender: indexPath)
    }
    
}

extension WebGalleryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebGalleryCell",
                                                      for: indexPath) as! WebGalleryCell
        let model = dataSource.items[indexPath.row]
        cell.nameLabel.text = model.title.capitalized
        dataSource.connection.requestImage(model, size: .small) { image in
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        return cell
    }
    
}

extension WebGalleryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CGFloat(Int(collectionView.bounds.width / CGFloat(Constant.collectionViewColumnsCount)
            - Constant.collectionViewCellsSpacing))
        return CGSize(width: cellWidth, height: cellWidth * Constant.cellRatioHeightToWidth)
    }
}
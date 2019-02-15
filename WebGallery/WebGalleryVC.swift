//
//  WebGalleryVC.swift
//  WebGallery
//
//  Created by kathelyss on 14/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

enum PhotoCategory {
    case first, second
}

struct Constant {
    static let imageCornerRadius: CGFloat = 6
    static let collectionViewColumnsCount: Int = 3
    static let collectionViewCellsSpacing: CGFloat = 8
    static let cellRatioHeightToWidth: CGFloat = 1.5
}

class WebGalleryVC: UIViewController {
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
        dataSource.createModels()
        collectionView.register(cellNib, forCellWithReuseIdentifier: "WebGalleryCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func tapFirstCategoryButton(_ sender: UIButton) {
        firstCategoryButton.titleLabel?.font = UIFont.bold
        secondCategoryButton.titleLabel?.font = UIFont.normal
        choosenCategory = .first
        selectorIndicatorFirstCategoryConstraint.isActive = true
        selectorIndicatorSecondCategoryConstraint.isActive = false
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
        animator.startAnimation()
        
        // request first category
        // nice transition
        collectionView.reloadData()
    }
    
    @IBAction func tapSecondCategoryButton(_ sender: UIButton) {
        firstCategoryButton.titleLabel?.font = UIFont.normal
        secondCategoryButton.titleLabel?.font = UIFont.bold
        choosenCategory = .second
        selectorIndicatorFirstCategoryConstraint.isActive = false
        selectorIndicatorSecondCategoryConstraint.isActive = true
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
        animator.startAnimation()
        
        // request second category
        // nice transition
        collectionView.reloadData()
    }
}

extension WebGalleryVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToImageVC", sender: indexPath)
    }
    
}

extension WebGalleryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choosenCategory == .first ? dataSource.cats.count : dataSource.dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebGalleryCell",
                                                      for: indexPath) as! WebGalleryCell
        cell.imageView.layer.masksToBounds = true
        cell.imageView.layer.cornerRadius = Constant.imageCornerRadius
        
        cell.imageView.image = choosenCategory == .first ?
            dataSource.cats[indexPath.row].image : dataSource.dogs[indexPath.row].image
        cell.nameLabel.text = choosenCategory == .first ?
            dataSource.cats[indexPath.row].name : dataSource.dogs[indexPath.row].name
        
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

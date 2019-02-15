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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func tapFirstCategoryButton(_ sender: UIButton) {
        firstCategoryButton.titleLabel?.font = TextStyle.bold
        secondCategoryButton.titleLabel?.font = TextStyle.normal
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
        firstCategoryButton.titleLabel?.font = TextStyle.normal
        secondCategoryButton.titleLabel?.font = TextStyle.bold
        choosenCategory = .second
        selectorIndicatorFirstCategoryConstraint.isActive = false
        selectorIndicatorSecondCategoryConstraint.isActive = true
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
        animator.startAnimation()
//        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear], animations: {
//            self.backView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//            self.view.layoutIfNeeded()
//        }) { finished in
//
//        }
        // request second category
        // nice transition
        collectionView.reloadData()
    }
}

extension WebGalleryVC: UICollectionViewDelegate {
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //
    //    }
    //
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
        cell.imageView.layer.cornerRadius = 6
        
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
        let size = CGFloat(Int(collectionView.bounds.width / 3 - 8))
        return CGSize(width: size, height: size * 1.5)
    }
}

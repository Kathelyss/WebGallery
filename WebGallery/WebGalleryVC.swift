//
//  WebGalleryVC.swift
//  WebGallery
//
//  Created by kathelyss on 14/02/2019.
//  Copyright © 2019 Екатерина Рыжова. All rights reserved.
//

import UIKit

class WebGalleryVC: UIViewController {
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var firstCategoryButton: UIButton!
    @IBOutlet var secondCategoryButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib.init(nibName: "WebGalleryCell", bundle: nil)
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
    
}

extension WebGalleryVC: UICollectionViewDelegate {
    
}

extension WebGalleryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebGalleryCell",
                                                      for: indexPath) as! WebGalleryCell
        cell.imageView.layer.masksToBounds = true
        cell.imageView.layer.cornerRadius = 6
        cell.imageView.image = #imageLiteral(resourceName: "kitten")
        
        return cell
    }
    
}

extension WebGalleryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGFloat(Int(collectionView.bounds.width / 3 - 8))
        return CGSize(width: size, height: size * 2)
    }
}

//
//  ViewController.swift
//  ReaddleSample1
//
//  Created by Oleg Gnidets on 08.07.2022.
//

import UIKit

/* Horizontal View
    H: 150
 
    Vertical center
 */

class CollectionItem: UICollectionViewCell {
    
    
}

class ViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150, height: 150)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CollectionItem.self)", for: indexPath) as? CollectionItem else {
            return UICollectionViewCell()
        }
        
        cell.contentView.backgroundColor = .green
        
        return cell
    }
    

}


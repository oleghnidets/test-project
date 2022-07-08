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

class ItemsDataSource {
    
    private var _numberOfItems: Int = 0
    
    var numberOfItems: Int {
        queue.sync {
            _numberOfItems
        }
    }
    
    private let queue = DispatchQueue(label: "ItemsDataSource.queue")
    
    func removeItem() {
        queue.sync {
            _numberOfItems -= 1
        }
    }
    
    func addItem() {
        queue.sync {
            _numberOfItems += 1
        }
    }
}

class ViewController: UIViewController {
    
    private var numberOfItems = 0
    
    var source = ItemsDataSource()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var initialCenter: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func removeItem(at index: Int) {
        source.removeItem()
        
        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
    }
    
    @IBAction func addItem() {
        source.addItem()
        
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(item: numberOfItems - 1, section: 0), at: .right, animated: true)
    }
    
    @objc func moveCell(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let cell = gestureRecognizer.view else {
            return
        }
        
        let translation = gestureRecognizer.translation(in: view)

        
        if gestureRecognizer.state == .began {
            self.initialCenter = cell.center
        }
        
        if gestureRecognizer.state == .ended {
            if translation.y < 50 && translation.y > -50 {
                cell.center = initialCenter
                return
            } else {
                guard let indexPath = collectionView.indexPathForItem(at: initialCenter) else {
                    return
                }
                
                removeItem(at: indexPath.item)
            }
        }

        if gestureRecognizer.state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x, y: initialCenter.y + translation.y)
            cell.center = newCenter
        } else {
            cell.center = initialCenter
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        removeItem(at: indexPath.item)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        source.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CollectionItem.self)", for: indexPath) as? CollectionItem else {
            return UICollectionViewCell()
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveCell(_:)))
        cell.addGestureRecognizer(panGesture)
        
        cell.contentView.backgroundColor = .green
        
        return cell
    }
}

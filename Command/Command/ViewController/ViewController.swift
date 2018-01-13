//
//  ViewController.swift
//  Command
//
//  Created by Oleh Zayats on 1/12/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    lazy var cellViewModels: [CollectionCellViewModel] = {
        let factory = CollectionCellViewModelFactory()
        return CollectionDataProvider.imageDataArray.map {
            return factory.create(with: $0)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionCellNib = UINib(nibName: CollectionViewCell.identifier, bundle: nil)
        collectionView.register(collectionCellNib, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

//
//  CollectionViewPlantCell.swift
//  Command
//
//  Created by Oleh Zayats on 1/13/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, SingleReuseIdentifier {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = .scaleAspectFill
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
    }
}

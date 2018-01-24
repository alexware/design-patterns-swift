//
//  ViewController+UICollectionViewDelegate.swift
//  Command
//
//  Created by Oleh Zayats on 1/13/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else {
            return
        }
        cellViewModels[indexPath.item]
            .commands[CollectionCellViewModel.CommandKey.selection]?
            .execute(on: cell)
    }
}

//
//  ImagePickerViewDelegate.swift
//  Facade
//
//  Created by Oleh Zayats on 1/14/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

enum PickerImagesType {
    case remote, local
}

protocol PickerViewDelegate: class {
    func pickerViewDidSelect(row: Int, pickerType: PickerImagesType)
}

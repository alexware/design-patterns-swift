//
//  LoadedImagePickerDataSource.swift
//  Facade
//
//  Created by Oleh Zayats on 1/14/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

final class SavedImagePickerHandler: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var delegate: PickerViewDelegate?
    
    var urls: [URL] = []
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return urls.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return urls[row].imageName()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.pickerViewDidSelect(row: row, pickerType: .local)
    }
}

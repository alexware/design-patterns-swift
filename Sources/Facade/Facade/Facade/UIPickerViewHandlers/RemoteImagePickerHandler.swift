//
//  RemoteImagePickerDataSource.swift
//  Facade
//
//  Created by Oleh Zayats on 1/14/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

final class RemoteImagePickerHandler: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    weak var delegate: PickerViewDelegate?
    
    func defaultImagePickerURL() -> URL {
        return imageURLs.first!
    }
    
    func getURL(for row: Int) -> URL? {
        return imageURLs[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return imageURLs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return imageURLs[row].imageName()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.pickerViewDidSelect(row: row, pickerType: .remote)
    }
    
    private lazy var imageURLs: [URL] = {
        return [
            "https://upload.wikimedia.org/wikipedia/commons/f/fd/Meteor_Crater_-_Arizona.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/0/0d/Deepwater_Horizon_oil_spill_-_May_24%2C_2010.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/c/c3/Glacial_lakes%2C_Bhutan.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/c/c6/Jeju_Island.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/4/4a/MtCleveland_ISS013-E-24184.jpg"
            ].flatMap { return URL(string: $0) }
    }()
}

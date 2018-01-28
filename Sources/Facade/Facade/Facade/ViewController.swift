//
//  ViewController.swift
//  Facade
//
//  Created by Oleh Zayats on 1/14/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

enum PickerType {
    case remote, local
}

protocol PickerViewDelegate: class {
    func pickerViewDidSelect(row: Int, pickerType: PickerType)
}

class ViewController: UIViewController {
    @IBOutlet weak var wikiURLsPickerView: UIPickerView!
    @IBOutlet weak var savedImagesPickerView: UIPickerView!
    @IBOutlet weak var imageView: UIImageView!
    
    private let imageAPIFacade = ImageAPIFacade()
    private let remoteImagePickerHandler = RemoteImagePickerHandler()
    private let savedImagePickerHandler = SavedImagePickerHandler()
    
    private var pickedRemoteImageURL: URL!
    private var pickedSavedImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateSavedImagesPicker()
    }
    
    private func setup() {
        imageAPIFacade.removeSavedImages()
        imageView.contentMode = .scaleAspectFill
        pickedRemoteImageURL = remoteImagePickerHandler.defaultImagePickerURL()
        wikiURLsPickerView.delegate = remoteImagePickerHandler
        wikiURLsPickerView.dataSource = remoteImagePickerHandler
        savedImagesPickerView.delegate = savedImagePickerHandler
        savedImagesPickerView.dataSource = savedImagePickerHandler
        remoteImagePickerHandler.delegate = self
        savedImagePickerHandler.delegate = self
    }
    
    private func updateSavedImagesPicker() {
        savedImagePickerHandler.urls = imageAPIFacade.getSavedImageURLs()
        main { [weak self] in
            self?.savedImagesPickerView.reloadAllComponents()
        }
        if savedImagePickerHandler.urls.isEmpty == false {
            pickedSavedImageURL = savedImagePickerHandler.urls.first
        }
    }
    
    private func main(_ f: @escaping () -> Void) {
        DispatchQueue.main.async { f() }
    }
}

extension ViewController {
    @IBAction func saveRemoteImageToDiskDidTouchUpInside(_ sender: UIButton) {
        imageAPIFacade.saveRemoteImage(url: pickedRemoteImageURL,
                                       name: pickedRemoteImageURL.imageName(),
                                       format: .jpeg(quality: 0.8),
                                       callback: { [weak self] result in
                                        
            print(result.debugDescription)
            self?.updateSavedImagesPicker()
        })
    }
    
    @IBAction func showSavedImageDidTouchUpInside(_ sender: UIButton) {
        guard let url = pickedSavedImageURL else {
            return
        }
        imageView.image = imageAPIFacade.retrieveSavedImage(with: url)
    }
}

extension ViewController: PickerViewDelegate {
    func pickerViewDidSelect(row: Int, pickerType: PickerType) {
        switch pickerType {
        case .remote:
            if let url = remoteImagePickerHandler.getURL(for: row) {
                pickedRemoteImageURL = url
            }
        case .local:
            pickedSavedImageURL = savedImagePickerHandler.urls[row]
        }
    }
}

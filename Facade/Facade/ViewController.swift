//
//  ViewController.swift
//  Facade
//
//  Created by Oleh Zayats on 1/14/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

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
        cleanup()
        setup()
        updateSavedImagesPicker()
    }
    
    private func setup() {
        imageView.contentMode = .scaleAspectFill
        pickedRemoteImageURL = remoteImagePickerHandler.defaultImagePickerURL()
        wikiURLsPickerView.delegate = remoteImagePickerHandler
        wikiURLsPickerView.dataSource = remoteImagePickerHandler
        savedImagesPickerView.delegate = savedImagePickerHandler
        savedImagesPickerView.dataSource = savedImagePickerHandler
        remoteImagePickerHandler.delegate = self
        savedImagePickerHandler.delegate = self
    }
    
    private func cleanup() {
        imageAPIFacade.removeSavedImages()
    }
    
    private func updateSavedImagesPicker() {
        savedImagePickerHandler.urls = imageAPIFacade.getSavedImageURLs()
        savedImagesPickerView.reloadAllComponents()
        if savedImagePickerHandler.urls.isEmpty == false {
            pickedSavedImageURL =  savedImagePickerHandler.urls.first
        }
    }
}

extension ViewController {
    @IBAction func saveRemoteImageToDiskDidTouchUpInside(_ sender: UIButton) {
        let name = pickedRemoteImageURL.imageName()
        let format: ImageFormat = .jpeg(quality: 0.8)
        imageAPIFacade.saveRemoteImage(url: pickedRemoteImageURL, name: name, format: format, shouldOverwrite: true, callback: { [weak self] result in
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
    func pickerViewDidSelect(row: Int, pickerType: PickerImagesType) {
        switch pickerType {
        case .remote:
            let remoteURL = remoteImagePickerHandler.getURL(for: row)
            if let url = remoteURL { pickedRemoteImageURL = url }
        case .local:
            pickedSavedImageURL = savedImagePickerHandler.urls[row]
        }
    }
}

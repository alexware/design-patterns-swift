//
//  ViewController.swift
//  Caching
//
//  Created by Zayats Oleh on 1/28/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var imageLoader: ImageLoader!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        let cache = Cache()
        let http = HTTPClient()
        imageLoader = ImageLoader(with: http, cache: cache)
    }
}


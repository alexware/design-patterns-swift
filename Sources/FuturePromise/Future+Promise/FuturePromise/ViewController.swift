//
//  ViewController.swift
//  Future
//
//  Created by Zayats Oleh on 1/27/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    private let http = LittleHTTPClient()
    private let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/f/fd/Meteor_Crater_-_Arizona.jpg")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        http.loadImage(from: url).observe { result in
            switch result {
                
            case .success(let data):
                main {
                    self.imageView.image = UIImage(data: data)
                }
            case .fail(let error):
                print(error)
            }
        }
    }
}

func main(_ f: @escaping () -> Void) {
    DispatchQueue.main.async {
        f()
    }
}

//
//  CollectionCellSelectionCommand.swift
//  Command
//
//  Created by Oleh Zayats on 1/13/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

class CollectionCellSelectionCommand: Command<CollectionViewCell> {
    
    private let application: UIApplication
    private let pageURL: URL
    
    init(pageURL: URL, application: UIApplication) {
        self.application = application
        self.pageURL = pageURL
        
        super.init { cell in
            // ...
        }
    }
    
    override func execute(on receiver: AnyObject) {
        super.execute(on: receiver)
        
        if application.canOpenURL(pageURL) {
            application.open(pageURL, options: [:], completionHandler: nil)
        }
    }
}

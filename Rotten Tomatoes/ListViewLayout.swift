//
//  ListViewLayout.swift
//  Rotten Tomatoes
//
//  Created by Nicholas Long on 4/20/15.
//  Copyright (c) 2015 rdio. All rights reserved.
//

import UIKit

class ListViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        let width = UIScreen.mainScreen().bounds.width
        self.itemSize = CGSize(width:width, height:80)
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    required init(coder:NSCoder) {
        super.init(coder:coder)
        let width = UIScreen.mainScreen().bounds.width
        self.itemSize = CGSize(width:width, height:80)
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

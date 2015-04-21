//
//  GridViewLayout.swift
//  Rotten Tomatoes
//
//  Created by Nicholas Long on 4/20/15.
//  Copyright (c) 2015 rdio. All rights reserved.
//

import UIKit

class GridViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.itemSize = CGSize(width:155, height:270)
        self.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    required init(coder:NSCoder) {
        super.init(coder:coder)
        self.itemSize = CGSize(width:155, height:270)
        self.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
}

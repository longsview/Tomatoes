//
//  LargeMovieCollectionView.swift
//  Rotten Tomatoes
//
//  Created by Nicholas Long on 4/19/15.
//  Copyright (c) 2015 rdio. All rights reserved.
//

import UIKit

class LargeMovieCollectionView: UICollectionViewCell {
    
    enum LayoutType {
        case List
        case Grid
    }
    
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var rottenOrFreshImage: UIImageView!
    @IBOutlet weak var percent: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var tomatoMeterView: UIView!
    @IBOutlet weak var headerShield: UIImageView!
    
    var movie: NSDictionary!
    
    var layoutType: LayoutType {
        get {
            return .Grid
        }
        set {
            if(newValue == .List) {
                self.imageBackground.frame = CGRect(x:5, y:5, width:50, height:70)
                self.movieTitle.frame = CGRect(x:65, y:15, width:300, height:21)
                self.movieTitle.textAlignment = NSTextAlignment.Left
                self.addSubview(self.tomatoMeterView)
                self.tomatoMeterView.frame = CGRect(x:60, y:30, width:200, height: 20)
                self.headerShield.hidden = true
                self.percent.textColor = UIColor.blackColor()
            } else {
                self.imageBackground.frame = CGRect(x:0, y:0, width:155, height:230)
                self.movieTitle.frame = CGRect(x:5, y:231, width:145, height:21)
                self.movieTitle.textAlignment = NSTextAlignment.Center
                self.imageBackground.addSubview(self.tomatoMeterView)
                self.tomatoMeterView.frame = CGRect(x:00, y:200, width:155, height: 30)
                self.headerShield.hidden = false
                self.percent.textColor = UIColor.whiteColor()
            }
        }
    }
}

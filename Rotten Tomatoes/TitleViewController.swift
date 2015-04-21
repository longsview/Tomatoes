//
//  FirstViewController.swift
//  Rotten Tomatoes
//
//  Created by Nicholas Long on 4/19/15.
//  Copyright (c) 2015 rdio. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var synopsis: UILabel!
    
    @IBOutlet weak var scroller: UIScrollView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var criticsRating: UILabel!
    
    @IBOutlet weak var audienceRating: UILabel!
    
    var image: UIImage!
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieImage.loadLowAndHiRes(movie.valueForKeyPath("posters.thumbnail") as! String, fadeDelay: 0.5)
        
        let year = movie["year"] as! NSNumber
        let title = movie["title"] as! String
        self.title = title
        movieTitle.text = "\(title) (\(year.integerValue))"
        
        let criticsScore = movie.valueForKeyPath("ratings.critics_score") as! NSNumber
        let audienceScore = movie.valueForKeyPath("ratings.audience_score") as! NSNumber
        
        criticsRating.text = "Critics Rating: \(criticsScore.integerValue)"
        audienceRating.text = "Audience Rating: \(audienceScore.integerValue)"
        
        synopsis.text = movie["synopsis"] as? String
        synopsis.sizeToFit()
        
        scroller.contentInset = UIEdgeInsets(top: view.frame.size.height - 200, left: 0, bottom: 0, right: 0)
        scroller.contentSize.height = synopsis.frame.origin.y + synopsis.frame.size.height +
            navigationController!.tabBarController!.tabBar.frame.size.height + 10
    }
}
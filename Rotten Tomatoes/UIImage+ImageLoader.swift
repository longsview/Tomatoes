//
//  UIImage+Cropping.swift
//
//  Created by Fernando Paredes on 6/10/14.
//  License: MIT
//

import UIKit

extension UIImageView {
    
    func loadLowAndHiRes(url: String, fadeDelay: NSTimeInterval = 1.0) -> Void {
        self.alpha = 0.0
        let realUrl = NSURL(string: url) as NSURL!
        self.setImageWithURLRequest(NSURLRequest(URL: realUrl), placeholderImage: nil, success: { (request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
            self.image = image
            UIView.animateWithDuration(fadeDelay, animations: {
                self.alpha = 1.0
            })
            
            var hiUrl = url
            var range = url.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
            if let range = range {
                hiUrl = url.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
            }
            
            let hiRealUrl = NSURL(string: hiUrl) as NSURL!
            
            self.setImageWithURLRequest(NSURLRequest(URL: hiRealUrl), placeholderImage: image, success: { (request:NSURLRequest!,response:NSHTTPURLResponse!, hiImage:UIImage!) -> Void in
                self.image = hiImage
                }, failure: { (Bool) -> Void in
                    let i = 0
            })
            }, failure: nil)
    }
}
//
//  FirstViewController.swift
//  Rotten Tomatoes
//
//  Created by Nicholas Long on 4/19/15.
//  Copyright (c) 2015 rdio. All rights reserved.
//

import UIKit

class DVDViewController: BaseGridViewController {
    
    @IBOutlet weak var collectionGridView: UICollectionView!
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    @IBAction func viewTypeToggled(sender: AnyObject) {
        toggleViewLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = collectionGridView
        setFilter(movieSearchBar, filter:"")
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        setFilter(searchBar, filter:searchText)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func feedURL() -> String {
        return "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=US"
    }
}

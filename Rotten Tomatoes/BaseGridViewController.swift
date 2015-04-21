//
//  FirstViewController.swift
//  Rotten Tomatoes
//
//  Created by Nicholas Long on 4/19/15.
//  Copyright (c) 2015 rdio. All rights reserved.
//

import UIKit

class BaseGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
            collectionView.insertSubview(refreshControl, atIndex: 0)
            fetchFeed()
        }
    }
    
    var loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var refreshControl = UIRefreshControl()
    var filteredMovieList = NSArray()
    var movies = NSMutableArray()
    var madeRequest = false
    var listViewMode = LargeMovieCollectionView.LayoutType.Grid
    var errorView = UIView()
    var searchBar: UISearchBar!
    var filter = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.tintColor = UIColor.brownColor()
        
        loadingIndicator.color = UIColor.brownColor()
        loadingIndicator.frame = CGRect(x:(view.frame.width - loadingIndicator.frame.width) / 2, y:(view.frame.height - loadingIndicator.frame.height) / 2, width:loadingIndicator.frame.width, height:loadingIndicator.frame.height)
        
        view.addSubview(loadingIndicator)
        loadingIndicator.hidesWhenStopped = true
        
        errorView.backgroundColor = UIColor.brownColor()
        errorView.alpha = 0.0
        errorView.frame = CGRect(x: 0, y: 34, width: view.bounds.width, height: 30)
        let errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        errorLabel.backgroundColor = UIColor.clearColor()
        errorLabel.text = "Network Error"
        errorLabel.textColor = UIColor.whiteColor()
        errorLabel.textAlignment = NSTextAlignment.Center
        errorView.addSubview(errorLabel)
        view.addSubview(errorView)
    }
    
    func feedURL() -> String {
        fatalError("This method must be overridden")
    }
    
    func fetchFeed(index: Int = 0) {
        madeRequest = true
        if(index == 0) {
            self.movies.removeAllObjects()
        }
        
        loadingIndicator.startAnimating()
        
        var url = NSURL(string: feedURL()) as NSURL!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if(error != nil || response == nil) {
                self.loadingIndicator.stopAnimating()
                UIView.animateWithDuration(0.3, animations: { () in
                    self.errorView.alpha = 1.0
                    self.errorView.frame = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: 30)
                    }, completion: { (Bool) in
                        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hideError", userInfo: nil, repeats: false)
                })
                return
            }
            
            //var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
            
            let path = NSBundle.mainBundle().pathForResource(self.title, ofType: "json")!
            let jsonData = NSData(contentsOfFile: path)!
            let responseDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            self.movies.addObjectsFromArray(responseDictionary["movies"] as! NSArray as [AnyObject])
            self.filteredMovieList = self.movies
            self.madeRequest = false
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    func hideError() {
        UIView.animateWithDuration(0.3, animations: { () in
            self.errorView.alpha = 0.0
            self.errorView.frame = CGRect(x: 0, y: 34, width: self.view.bounds.width, height: 30)
            })
    }
    
    func onRefresh() {
        movies.removeAllObjects()
        filteredMovieList = movies
        collectionView.reloadData()
        fetchFeed()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovieList.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! LargeMovieCollectionView
    
        cell.movieImage.alpha = 0.0
        UIView.animateWithDuration(0.5, animations: { () in
            cell.movieImage.alpha = 1.0
        })
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! LargeMovieCollectionView
        cell.movieImage.layer.borderWidth = 10.0
        cell.movieImage.layer.borderColor = UIColor(red: 0, green: 0.45, blue: 0, alpha: 1).CGColor
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! LargeMovieCollectionView
        cell.movieImage.layer.borderWidth = 1.0
        cell.movieImage.layer.borderColor = UIColor.brownColor().CGColor
    }
    
    func collectionView(collectionView:UICollectionView, layout: UICollectionViewLayout, insetForSectionAtIndex: Int) -> UIEdgeInsets {
        // squeeze the grid closer to the edges on iPhone 5 and 4S
        // so that it doesn't skip to the next line
        if(view.frame.width <= 320) {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        } else {
            return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! LargeMovieCollectionView
        
        if (self.madeRequest) {
            return cell;
        }
        
        let movie = filteredMovieList[indexPath.indexAtPosition(0)+indexPath.indexAtPosition(1)] as! NSDictionary
        cell.movie = movie
        cell.movieTitle.text = movie["title"] as? String
        
        var url = movie.valueForKeyPath("posters.thumbnail") as! String
        
        cell.layoutType = listViewMode

        cell.imageBackground.layer.borderColor = UIColor.brownColor().CGColor
        cell.imageBackground.layer.borderWidth = 1.0
        cell.movieImage.image = nil
        cell.movieImage.cancelImageRequestOperation()
        cell.movieImage.loadLowAndHiRes(url)
        
        let criticsScore = movie.valueForKeyPath("ratings.critics_score") as! NSNumber
        cell.percent.text = "%\(criticsScore.integerValue)"
        if(criticsScore.integerValue >= 60) {
            cell.rottenOrFreshImage.image = UIImage(named:"fresh")
        } else {
            cell.rottenOrFreshImage.image = UIImage(named:"rotten")
        }
        
        return cell
    }
    
    func toggleViewLayout()
    {
        // re-layout the collection based on the toggle state
        // animate the visible cells to the new state
        if(listViewMode == .Grid) {
            let transition = ListViewLayout()
            collectionView.performBatchUpdates({ () in
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(transition, animated: true)
                for cell in self.collectionView.visibleCells() {
                    let largeCell = cell as! LargeMovieCollectionView
                    largeCell.layoutType = LargeMovieCollectionView.LayoutType.List
                }
                }, completion: { (Bool) in
                    self.listViewMode = LargeMovieCollectionView.LayoutType.List
            })
        } else {
            let transition = GridViewLayout()
            collectionView.performBatchUpdates({ () in
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(transition, animated: true)
                for cell in self.collectionView.visibleCells() {
                    let largeCell = cell as! LargeMovieCollectionView
                    largeCell.layoutType = LargeMovieCollectionView.LayoutType.Grid
                }
                }, completion: { (Bool) in
                    self.listViewMode = LargeMovieCollectionView.LayoutType.Grid
            })
        }
    }
    
    func setFilter(searchBar: UISearchBar, filter: String!) {
        self.filter = filter
        if(filter != nil && !filter.isEmpty) {
            // if we have a filter then apply it to our main list
            // using a predicate
            filteredMovieList = movies.filteredArrayUsingPredicate(NSPredicate(format: "title contains[cd] %@", filter))
        } else {
            filteredMovieList = movies
        }
        
        // set the search bar
        self.searchBar = searchBar
        self.collectionView.reloadData()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // if we start scrolling then dismiss the keyboard
        if(searchBar != nil) {
            searchBar.resignFirstResponder()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! TitleViewController
        let cell = sender as! LargeMovieCollectionView
        let indexPath = collectionView.indexPathForCell(cell)
        
        vc.image = cell.movieImage.image
        vc.movie = cell.movie
    }
}


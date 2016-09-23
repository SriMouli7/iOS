//
//  ViewController.swift
//  TheMovieDB-Sample
//
//  Created by Sri Mouli Puttege on 9/15/16.
//  Copyright © 2016 Orange Matrix. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // TableView that displays all the movies
    @IBOutlet weak var moviesTableView: UITableView!
    
    @IBOutlet weak var scrollToTopButton: CustomButton!
    // Data source array for the table view which holds Movie objects
    var moviesArray: [Movie]?
    
    // Refresh control for pull-to-refresh
    var refreshControl: UIRefreshControl!
    
    // Current page of results to be loaded.
    var pageNunm = 1
    
    // Variable to check if the data data fetch is under progress.
    var isDownloadingData: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Add refresh control as a subview to the TableView
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string:refreshControlLabelString)
        self.refreshControl.backgroundColor = lightGrayColor
        self.moviesTableView.addSubview(refreshControl)
        
        // Make initial request to download the data.
        self.loadData(pageNunm)
        
        // For auto-adjustable cell heights
        self.moviesTableView.rowHeight = UITableViewAutomaticDimension
        self.moviesTableView.estimatedRowHeight = 240
        
        self.moviesTableView.backgroundView?.hidden = true
        
    }
    
    
    func loadData(pageNum: Int) {
        
        // Mark that data fetching is under progress.
        self.isDownloadingData = true
        
        // Download the appropriate page results.
        HTTPServices.instance.getNowPlayingMovies(pageNum) {[unowned self] (recentMovies, success) in
            if success{
                
                // If initial data is being fetched then initialize moviesArray
                if pageNum == 1{
                    self.moviesArray?.removeAll()
                    if self.moviesArray == nil{
                        self.moviesArray = [Movie]()
                    }
                }
                // Success implies that data is available, so recentMovies can be unwrapped
                self.moviesArray?.appendContentsOf(recentMovies!)
                dispatch_async(dispatch_get_main_queue(), {
                    // Reload table view
                    self.moviesTableView.reloadData()
                    // End refreshing the refreshControl
                    self.refreshControl.endRefreshing()
                })
            }else{
                print("API Call failed")
            }
            // Mark that data download is finished
            self.isDownloadingData = false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //***************************** TableView Delegate Methods *****************************
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       tableView.backgroundView?.hidden = true
        if moviesArray != nil{
            moviesTableView.separatorStyle = .SingleLine
            scrollToTopButton.hidden = false
            
            return 1
        }
        
        // If thers is no data in the data source array, display the empty table message.
        let somethingWrongLabel = UILabel()
        somethingWrongLabel.text = emptyTableMessage
        somethingWrongLabel.numberOfLines = 0;
        somethingWrongLabel.textAlignment = .Center
        
        tableView.backgroundView = somethingWrongLabel
        moviesTableView.separatorStyle = .None
        
        // Hide scroll to top button when no results are being shown
        scrollToTopButton.hidden = true
        
        // Unhide the backgroundView
        tableView.backgroundView?.hidden = false
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Reaches here only if there is data in the data source array, so okay to unwrap it
        if moviesArray != nil{
            return (moviesArray?.count)!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // De-queue a  reusable cell and pass in the required data to configure it.
        if let cell = tableView.dequeueReusableCellWithIdentifier(movieTableViewCellIdentifier) as? MovieTableViewCell{
            if moviesArray != nil{
                cell.cellMovie = moviesArray![indexPath.row]
                
                // To display alternating cell background colors
                let isOddCell = indexPath.row % 2 == 0 ? false : true
                cell.configureCell(isOddCell)
                
                // While reaching the end of the tableview, request next page of results
                if indexPath.row == (moviesArray?.count)! - 2{
                    pageNunm += 1
                    loadData(pageNunm)
                }
                return cell
            }else{
                // Never reaches here, just fail proof
                return UITableViewCell()
            }
        }else{
            // Never reaches here, just fail proof
            return UITableViewCell()
        }

    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // When scrolling stopped, check if the refresh control is active and if there is already data fetch under progress
        // If so, then reset the page number of the required results and submit data fetch request.
        if refreshControl.refreshing {
            if !isDownloadingData {
                pageNunm = 1
                loadData(pageNunm)
            }
        }
    }
    
    //***************************** TableView Delegate Methods *****************************
    
    
    
    //***************************** EXTRA FEATURE *****************************
    
    
    // Provide a button to scroll to top of the list after scrolling through some results.
    @IBAction func scrollToTopTapped(sender: UIButton) {
        
        // Get the indexpath for the first cell
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        // Scroll to the indexpath with animation
        self.moviesTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        
    }
    
    //***************************** EXTRA FEATURE *****************************
}


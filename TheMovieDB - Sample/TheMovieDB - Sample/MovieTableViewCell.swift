//
//  MovieTableViewCell.swift
//  TheMovieDB-Sample
//
//  Created by Sri Mouli Puttege on 9/17/16.
//  Copyright © 2016 Orange Matrix. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    // Movie variable to hold the corresponding Movie to be displayed in the cell
    var cellMovie: Movie?
    
    // Title label
    @IBOutlet weak var titleLabel: UILabel!
    // Overview text label
    @IBOutlet weak var overviewTextlabel: UILabel!
    // Poster Image
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    // Assign corresponding data to the outlets to display in the cell
    func configureCell(isOdd: Bool){
        
        // Initialize the background color to white
        self.backgroundColor = UIColor.whiteColor()
        // Alternate to gray color
        if isOdd{
            self.backgroundColor = lightGrayColor
        }
        // Check if Movie data exists
        if let movie = cellMovie{
            // Initialize to the Placeholder Image
            self.posterImageView.image = UIImage(named: moviePlaceholderImageName)
            // Set title label text
            let titleText = "\(movie.title) (\(movie.getYear()))"
            self.titleLabel.text = titleText
            // Set overview label text
            self.overviewTextlabel.text = movie.overviewTextString
            
            // Debug - Print image relative path to console.
            print("In Movie - Image - \(movie.imageURLString)")
            
            // Submit request to download and apply poster image to the imageView outlet
            HTTPServices.instance.downloadImageTask(movie.imageURLString, completionHandler: { [weak self](image, success) in
                // Get hold of the cell so that tableView does not reuse it before the image is applied if the cell is not visible
                if let strongSelf = self{
                    if success{
                        // Get hold of main queue
                        dispatch_async(dispatch_get_main_queue(), {
                            // set image
                            strongSelf.posterImageView.image = image
                            // Animate to get a blend in appearance to increase UX
                            strongSelf.posterImageView.alpha = 0
                            UIView.animateWithDuration(posterImageAnimationDurattion, animations: {
                                self!.posterImageView.alpha = 1
                            })
                        })
                    }
                }
                
            })
            
        }
    }

    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

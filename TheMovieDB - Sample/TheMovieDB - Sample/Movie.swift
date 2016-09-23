//
//  Movie.swift
//  TheMovieDB-Sample
//
//  Created by Sri Mouli Puttege on 9/16/16.
//  Copyright © 2016 Orange Matrix. All rights reserved.
//

import UIKit

struct Movie{
    
    private var _title: String
    private var _imageURLString : String?
//    private var _yearReleased : String
    private var _dateReleased: String
    private var _overviewTextString: String?
    
    
    var title: String{
        return _title
    }
    
    var imageURLString: String?{
        return _imageURLString
    }
    
    var yearReleased: String{
        return getYear()
    }
    
    var overviewTextString: String?{
        return _overviewTextString
    }
    
    
    init(title: String, imageURLString: String?, dateReleased: String, overviewText: String?){
        
        _title = title
        
        if imageURLString != nil{
            _imageURLString = imageURLString
        }
        
        _dateReleased = dateReleased
        
        if overviewText != nil{
            _overviewTextString = overviewText
        }
        
    }
    
    func getYear()-> String{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-mm-DD"
        
        let date = dateFormatter.dateFromString(_dateReleased)
        
        
        
        let calender = NSCalendar.currentCalendar()
        
        let components = calender.components([.Day, .Month, .Year], fromDate: date!)
        
        print(components.year)
        return String(components.year)
        
    }

}

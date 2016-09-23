//
//  HTTPServices.swift
//  TheMovieDB-Sample
//
//  Created by Sri Mouli Puttege on 9/16/16.
//  Copyright © 2016 Orange Matrix. All rights reserved.
//

import Foundation
import UIKit


// List of required item keys in the data obtained from request call
struct APIResultKeys {
    static let Results = "results"
    static let Title = "title"
    static let OverviewText = "overview"
    static let ReleaseDate = "release_date"
    static let ImageRelativePath = "poster_path"
    
}


// Singleton to funnel all the network calls
class HTTPServices{
    
    static let instance = HTTPServices()
    
    private let apiKey = "d73db914dac006d1c918264e2b2e6517"
    private let baseURLString = "http://api.themoviedb.org/3/movie/now_playing"
    private let imageBaseURLString = "https://image.tmdb.org/t/p/w92"


    // Restrict creation of objects
    private init(){}
    
    // Get instance of NSURLSession
    let session = NSURLSession.sharedSession()
    
    
    // Pass in the page number of the now playing results required and get the data.
    // Takes in a closure as parameter providing the results obtained from the data task.
    func getNowPlayingMovies(page: Int, completionHandler: (recentMovies: Array<Movie>?, success: Bool) -> Void){
        
        // Form the URL from Components
        let components = NSURLComponents(string: baseURLString)
        var queryItems = [NSURLQueryItem]()
        
        // Specify parameters
        queryItems.append(NSURLQueryItem(name: "api_key", value: apiKey))
        queryItems.append(NSURLQueryItem(name: "page", value: String(page)))
        
        components?.queryItems = queryItems
        
        // Create a URL Request object
        let request = NSMutableURLRequest(URL: (components?.URL!)!)
        // Set the HTTP method
        request.HTTPMethod = "GET"
        
        // Create a data task to download the now playing
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // Ensure there is no error and the httpresponsecode is Success
            guard error == nil  && (response as? NSHTTPURLResponse)!.statusCode == 200 else {
                completionHandler(recentMovies: nil, success: false)
                return
            }
            
            
            // Debug - Print to console
            print(response.debugDescription)
            print("DATA- \(data)")
            
            do{
                // Serialize the data downloaded to JSON format
                let x = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]
                print(x)
                
                if let results = x![APIResultKeys.Results] as? [AnyObject]{
                    print("RESULTS - \(results)")
                    
                    var moviesArray = [Movie]()
                    for movie in results{
                        
                        // Retrieve the data required from the downloaded data
                        let overviewText = movie[APIResultKeys.OverviewText] as? String
                        let title = movie[APIResultKeys.Title] as? String
                        let yearReleased = movie[APIResultKeys.ReleaseDate] as? String
                        let imageURLString = movie[APIResultKeys.ImageRelativePath] as? String
                        
                        // Form a Movie value from the obtained data
                        let aMovie = Movie(title: title!, imageURLString: imageURLString, dateReleased: yearReleased!, overviewText: overviewText)
                        // Append it to the list of Movies
                        moviesArray.append(aMovie)
                    }
                    // Pass in the list of movies and a success true flag into the completion hadler(closure)
                    completionHandler(recentMovies: moviesArray, success: true)
                }else{
                    completionHandler(recentMovies: nil, success: false)
                }
                
            }catch{
                completionHandler(recentMovies: nil, success: false)
                
            }
            
            
        }
        
        task.resume()
    }
    
    
    
    // Pass in the relative path of the image and download the data.
    // Takes in a closure as parameter providing the results obtained from the data task.
    func downloadImageTask(imageRelativePath: String?, completionHandler: (image: UIImage?, success: Bool) -> Void){
        // Check if image path exists
        if imageRelativePath == nil{
            completionHandler(image: nil, success: false)
            return
        }
        
        // Form the complete URL string
        let url = "\(imageBaseURLString)\(imageRelativePath!)"
        
        // Form the URL
        guard let imageURL = NSURL(string: url) else{
            completionHandler(image: nil, success: false)
            return
        }
        
        // Debug - Print Image URL to the console.
        print("Image URL- \(url)")
        let dataTask = session.dataTaskWithURL(imageURL) { (data, response, error) in
            // Ensure there is no error and daat exists
            guard error == nil && data != nil else {
                completionHandler(image: nil, success: false)
                return
            }
            // Pass in the image to the colosure
            if let image = UIImage(data: data!){
                completionHandler(image: image, success: true)
            }else{
                completionHandler(image: nil, success: false)
            }
        }
        dataTask.resume()
    
    }
    
}
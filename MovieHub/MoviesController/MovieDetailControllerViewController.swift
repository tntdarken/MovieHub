//
//  MovieDetailControllerViewController.swift
//
//  Created by Arthur Luiz Lara Quites
//  Copyright © 2020 Arthur Luiz Lara Quites. All rights reserved.
//

import UIKit

class MovieDetailControllerViewController: UIViewController {
    @IBOutlet var overview: UILabel!
    @IBOutlet var poster: DownloadImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var genre: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    var detalhes: MovieDetails?
    
    // Set the UI properties. Used for setting what to display on each element
    func setProperties(poster: String, overview: String, name: String, releaseDate: String, genre: String){
        detalhes = MovieDetails(overview: overview, name: name, releaseDate: releaseDate, genre: genre, poster: poster)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style the text that is shown on the labels
        name.font = UIFont.boldSystemFont(ofSize: 24.0)
        releaseDateLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        releaseDate.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        genre.font = UIFont.boldSystemFont(ofSize: 12.0)
        
        // assign data into the variables to be shown to the user
        if let details = detalhes{
            self.overview.text = details.overview
            self.name.text = details.name
            self.releaseDate.text = details.releaseDate
            self.genre.text = details.genre
            self.poster.setUrl("https://image.tmdb.org/t/p/original\(details.poster)")
        }
    }
}

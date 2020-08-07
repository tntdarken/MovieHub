//
//  Urls.swift
//  MovieHub
//
//  Created by Arthur Luiz Lara Quites on 06/08/20.
//  Copyright © 2020 Arthur Luiz Lara Quites. All rights reserved.
//

import Foundation

struct Constants{
    static let api_key = "c5850ed73901b8d268d0898a8a9d8bff"
    static let url_upcoming_movies = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(Constants.api_key)&language=en-US&page="
    static let url_single_movie = "https://api.themoviedb.org/3/search/movie?api_key=\(Constants.api_key)&query="
    static let url_movie_genres = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(Constants.api_key)&language=en-US"
}

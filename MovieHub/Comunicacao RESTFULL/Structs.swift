//
//  ErroRest.swift
//
//  Created by Arthur Luiz Lara Quites
//  Copyright © 2020 Arthur Luiz Lara Quites. All rights reserved.
//

import Foundation

// struct for decoding errors
struct ErroRest: Codable, Error {
    let tipo: Int?
    let titulo: String?
    let mensagem: String?
}

// struct for decoding movies
struct Filmes: Codable, Error {
    var results: [FilmeConteudo]?
    let total_pages: Int?
}

// struct for decoding movies
struct FilmeConteudo: Codable, Error {
    let popularity: Float?
    let vote_count: Int?
    let original_title: String?
    let backdrop_path: String?
    let overview: String?
    let genre_ids: [Int]?
    let poster_path: String?
    let release_date: String?
}

// struct for decoding movie genres
struct Genres: Codable, Error {
    var genres: [GenresConteudo]?
}

// struct for decoding movie genres
struct GenresConteudo: Codable, Error {
    let id: Int?
    let name: String?
}

// struct for decoding movie details
struct MovieDetails {
    let overview: String
    let name: String
    let releaseDate: String
    let genre: String
    let poster: String
}

//
//  MovieHubTests.swift
//  MovieHubTests
//
//  Created by Arthur Luiz Lara Quites on 04/08/20.
//  Copyright © 2020 Arthur Luiz Lara Quites. All rights reserved.
//

import XCTest
@testable import MovieHub

class MovieHubTests: XCTestCase {
    var teste: MoviesViewController!
    
    override func setUpWithError() throws {
        super.setUp()
        teste = MoviesViewController()
    }

    override func tearDownWithError() throws {
        teste = nil
        super.tearDown()
    }

    func testIfMovieGetsDownloaded() {
        if let filmes_ = teste.filmes, let results_ = filmes_.results {
            XCTAssertGreaterThanOrEqual(results_.count, 1, "Movies loaded")
        }
    }
    
    func testIfGenresGetsDownloaded() {
        if let genres_ = teste.movieGenres, let results_ = genres_.genres {
            XCTAssertGreaterThanOrEqual(results_.count, 1, "Genres loaded")
        }
    }
    
    func testFetch() throws {
        teste.http.get(url: "https://api.themoviedb.org/3/movie/upcoming?api_key=c5850ed73901b8d268d0898a8a9d8bff&language=en-US&page=1", param: nil) { (filmes: Filmes?, erro: ErroRest?) in
            if let filmes_ = filmes, let results_ = filmes_.results {
                XCTAssertTrue(results_.count > 0, "Sucesso")
            } else {
                XCTFail()
            }
        }
    }

    func testPerformanceFetch() throws {
        self.measure {
            teste.http.get(url: "https://api.themoviedb.org/3/movie/upcoming?api_key=c5850ed73901b8d268d0898a8a9d8bff&language=en-US&page=1", param: nil) { (filmes: Filmes?, erro: ErroRest?) in
                if let filmes_ = filmes, let results_ = filmes_.results {
                    XCTAssertTrue(results_.count > 0, "Sucesso")
                } else {
                    XCTFail()
                }
            }
        }
    }

}

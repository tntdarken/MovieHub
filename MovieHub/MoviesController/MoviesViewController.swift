//
//  ComunicacaoRestViewController.swift
//
//  Created by Arthur Luiz Lara Quites
//  Copyright © 2020 Arthur Luiz Lara Quites. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchButton: UIButton!
    let queue = OperationQueue()
    let mainQueue = OperationQueue.main
    var filmes: Filmes?
    var movieGenres: Genres?
    var pagination = 1
    let http = RestService(parser: JsonParser())
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MovieHub"

        searchButton.backgroundColor = .white
        searchButton.layer.cornerRadius = 30
        searchButton.setTitle("", for: .normal)
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.addTarget(self, action: #selector(openMovieSearch), for: .touchUpInside)
        
        // setup the SearchBar
        setupSearchBar()
        
        // setup the tableview
        setupTableView()
        
        // setup the keyboard behavior
        setupKeyboardBehavior()
        
        // load upcoming movies from webservice
        loadUpcomingMovies()
        
        // load genres
        queue.addOperation {
            self.http.get(url: Constants.url_movie_genres, param: nil) { (genres: Genres?, nil) in
                self.movieGenres = genres
            }
        }
    }
    
    // set up the observers to observe on the keyboard events
    func setupKeyboardBehavior(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // return the view to the original position when the keyboard is hidden
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    // push the view up so it won't get overlapped by the keyboard
    @objc func keyboardWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if searchBar.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
    
    @objc
    func refreshUpcomingMovies(){
        pagination = 1
        loadUpcomingMovies()
    }
    
    func loadUpcomingMovies() {
        mainQueue.addOperation {
            self.http.get(url: "\(Constants.url_upcoming_movies)\(self.pagination)", param: nil) { (filmes: Filmes?, error) in
                if(error?.tipo != 1) {
                    self.filmes = filmes
                    DispatchQueue.main.async {
                        self.tableView.tableFooterView?.isHidden = false
                        self.tableView.backgroundView = nil
                        self.refreshControl.endRefreshing()
                        self.tableView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                        noDataLabel.text          = "Could not fetch the movies, check you internet"
                        noDataLabel.textColor     = UIColor.black
                        noDataLabel.textAlignment = .center
                        self.tableView.backgroundView  = noDataLabel
                        self.tableView.separatorStyle  = .none
                    }
                }
            }
        }
    }
    
    @objc
    func openMovieSearch(){
        // create the alert controller.
        let alert = UIAlertController(title: "Custom search", message: "Search the movie by entering it's name", preferredStyle: .alert)

        // add the placeholder for instructing the user of what to do
        alert.addTextField { (textField) in
            textField.placeholder = "full or partial name"
        }

        // add the action to fetch data from movies matching the word
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // can force unwrap because the text exists
            
            let str = textField!.text!
            self.mainQueue.addOperation {
                self.http.get(url: "\(Constants.url_single_movie)\(str.replace(" ", with: "+"))", param: nil) { (filmes: Filmes?, error) in
                    if(error?.tipo != 1) {
                        self.filmes = filmes
                        DispatchQueue.main.async {
                            self.tableView.tableFooterView?.isHidden = true
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: { (_) in
            return
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search in this list of movies"
    }
    
    private func setupTableView() {
        // setup the nib for cell reutilization
        let cell = UINib(nibName: "MainCellItem", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "cell")
        
        // setup the delegate and datasource for the tableview
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // setup the button that will be shown in the footer and will be responsible to load more movies
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        let bt = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        bt.setTitle("Load more", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        v.addSubview(bt)
        tableView.tableFooterView = v
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        bt.addTarget(self, action: #selector(loadMore), for: .touchUpInside)

        // setup the style of the tableView
        tableView.backgroundColor = .white
        tableView.backgroundView?.backgroundColor = .white

        // add the refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshUpcomingMovies), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        // set to be hidden until data gets fetched
        tableView.tableFooterView?.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filmes?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView!.dequeueReusableCell(withIdentifier: "cell") as! MainCellItem
        
        // reset the data so nothing gets reused in the wrong way
        cell.img.image = UIImage(named: "clacket")
        cell.img.imgUrl = nil
        cell.titulo.text = nil
        cell.genre.text = nil
        cell.releaseDate.text = nil
        
        // check if the variables exists so we don't crash the app or get an unexpected result
        if let filmes_ = filmes, let results_ = filmes_.results {
            
            // set the movie title
            if let title_ = results_[indexPath.row].original_title {
                cell.titulo.text = title_
            }
            
            // set the movie genre
            if let genreIds_ = results_[indexPath.row].genre_ids {
                cell.genre.text = getGenre(ids: genreIds_)
            }
            
            // set the movie genre
            if let releaseDate_ = results_[indexPath.row].release_date {
                cell.releaseDate.text = releaseDate_
            }
            
            // set the movie img
            if let thumb_ = results_[indexPath.row].backdrop_path {
                cell.img.setUrl("https://image.tmdb.org/t/p/original/\(thumb_)")
            }
        }
        
        return cell
    }
    
    private func getGenre(ids: [Int]) -> String {
        // since the movieGenries variable stores data fetched from an api, check in order to don't crash the app or get unexpected result.
        if let gen = movieGenres, let genres = gen.genres {
            var genre: [String] = []
            
            // iterate through the genres and find the one matching the movie
            for key in genres.enumerated() {
                if(ids.contains(key.element.id!)){
                    genre.append(key.element.name!)
                }
            }
            return genre.joined(separator: ", ")
        } else {
            return "No genre"
        }
    }
    
    @objc
    func loadMore() {
        // responsible for checking the pagination retrieved from the webserver and to load more data if possible
        if(pagination <= self.filmes!.total_pages!){        
            pagination += 1
            http.get(url: "https://api.themoviedb.org/3/movie/upcoming?api_key=c5850ed73901b8d268d0898a8a9d8bff&language=en-US&page=\(pagination)", param: nil) { (filmes: Filmes?, nil) in
                self.filmes!.results! += filmes!.results!
                self.tableView.reloadData()
            }
        }
    }
    
    // hides the keyboard when cancel button of the searchbar is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // iterates over the fetched movies and search for the pattern informed
        if let filmes_ = filmes, let results_ = filmes_.results {
            for (i, filme) in results_.enumerated() {
                if(filme.original_title?.lowercased() == searchBar.text!.lowercased()){
                    tableView.scrollToRow(at: IndexPath(item: i, section: 0), at: .middle, animated: false)
                    searchBar.text = nil
                    searchBar.resignFirstResponder()
                    return
                }
            }
        }
        
        // if the search results in nothing, present the viewcontroller
        searchBar.resignFirstResponder()
        let alert = UIAlertController(title: "Whoops", message: "The movie wasn't found on the list. Check the name and try again!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = filmes!.results![indexPath.row]
        searchBar.resignFirstResponder()
        // present the movie detail controller and sets it's properties
        let controller = MovieDetailControllerViewController()
        controller.setProperties(poster: movie.poster_path ?? "", overview: movie.overview ?? "", name: movie.original_title ?? "", releaseDate: movie.release_date ?? "", genre:  getGenre(ids: movie.genre_ids!))
        self.navigationController!.pushViewController(controller , animated: true)
    }
}

// generic controller for multiple purpose

////
////  MainViewController.swift
////
////  Created by Arthur Luiz Lara Quites
////  Copyright © 2020 Arthur Luiz Lara Quites. All rights reserved.
////
//
//import UIKit
//
//class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    @IBOutlet var tableView:UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // declara o título da NavigationBar
//        self.title = "Main"
//
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//
//        // cria o refreshcontrol para o tableview
//        let refresh = UIRefreshControl()
//        refresh.addTarget(self, action: #selector(teste), for: .valueChanged)
//        self.tableView.refreshControl = refresh
//
//        // declara a celula para ser utilizada na tableview
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
////        let cell = UINib(nibName: "MainCellItem", bundle: nil)
////        self.tableView.register(cell, forCellReuseIdentifier: "cell")
//
//        let configItem = UIBarButtonItem(image: .actions, style: .plain, target: nil, action: nil)
//        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = configItem
////        self.navigationController?.navigationBar.setItems([configItem], animated: true)
//    }
//
//    @objc func teste() {
//        for item in 0...Funct.dic.count-1 {
//            if(Funct.dic[item][0] as! String).contains("persistence"){
//                print(self.tableView.cellForRow(at: IndexPath.init(row: item, section: 1)))
//            }
//        }
//        self.tableView.refreshControl?.endRefreshing()
//    }
//
//    override func viewWillLayoutSubviews() {
//        let size = self.view.bounds
//
//        if(size.width >= size.height){
//
//        }
//    }
//
//    // define número de rows em uma seção.
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return Funct.dic.count
//    }
//
//    // define o estilo e o que fazer com cada célula da TableView
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = self.tableView!.dequeueReusableCell(withIdentifier: "cell")
//        cell?.textLabel?.text = Funct.dic[indexPath.item][0] as! String
//        return cell!
//    }
//
//    // define o que fazer quando tocar em alguma celula da TableView
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        (Funct.dic[indexPath.item][1] as! UIViewController).title = Funct.dic[indexPath.item][0] as! String
//        self.navigationController!.pushViewController(Funct.dic[indexPath.item][1] as! UIViewController, animated: true)
//    }
//}
//
//struct Funct {
//    static let dic = [
//        ["Comunicacao HTTP rest", MoviesViewController()],
////        ["Data persistence", DataPersistViewController()],
////        ["UIStackView Dinamic", UIStackViewDinamicController()]
////        ["InAppPurchase", InapppurchaseViewController()],
////        ["Socket", SocketViewController()]
//    ]
//}

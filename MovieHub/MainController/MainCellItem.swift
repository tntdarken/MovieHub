//
//  MainCellItem.swift
//
//  Created by Arthur Luiz Lara Quites
//  Copyright © 2020 Arthur Luiz Lara Quites. All rights reserved.
//

import UIKit

class MainCellItem: UITableViewCell {
    @IBOutlet var genre:UILabel!
    @IBOutlet var titulo:UILabel!
    @IBOutlet var releaseDate:UILabel!
    @IBOutlet var img: DownloadImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // customize cell appearence
        let bgColor = UIColor(red: 0.898, green: 0.9451, blue: 0.9882, alpha: 1.0)
        contentView.backgroundColor = bgColor
        titulo.font = UIFont.boldSystemFont(ofSize: 24.0)
        genre.font = UIFont.boldSystemFont(ofSize: 12.0)
        releaseDate.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        selectionStyle = .none
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
    }
}

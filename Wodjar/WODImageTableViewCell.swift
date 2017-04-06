//
//  WODImageTableViewCell.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/22/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit
import SDWebImage

class WODImageTableViewCell: UITableViewCell {

    @IBOutlet weak var wodImageView: UIImageView!
    
    func populate(with imageURL: String) {
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        wodImageView.sd_setImage(with: URL(string: imageURL))
    }
}

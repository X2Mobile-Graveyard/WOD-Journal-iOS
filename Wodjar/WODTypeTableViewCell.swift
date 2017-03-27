//
//  WODTypeTableViewCell.swift
//  Wodjar
//
//  Created by Bogdan Costea on 3/15/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import UIKit

class WODTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var wodTypeImageView: UIImageView!
    @IBOutlet weak var wodTypeLabel: UILabel!
    @IBOutlet weak var wodsCompletedLabel: UILabel!
    
    func populate(with wodType: WODType, completedWods: Int, totalWods: Int) {
        switch wodType {
        case .hero:
            wodTypeImageView.image = #imageLiteral(resourceName: "heroes")
        case .challenge:
            wodTypeImageView.image = #imageLiteral(resourceName: "challenge")
        case .girl:
            wodTypeImageView.image = #imageLiteral(resourceName: "girl")
        case .custom:
            wodTypeImageView.image = #imageLiteral(resourceName: "custom")
        case .open:
            wodTypeImageView.image = #imageLiteral(resourceName: "crossFitGamesLogo")
        }
        
        wodTypeLabel.text = wodType.rawValue
        
        if wodType == .custom {
            wodsCompletedLabel.text = ""
        } else {
            wodsCompletedLabel.text = "\(completedWods)/\(totalWods)"
        }
    }
    
    func populateFavorites(with wodsCount: Int) {
        wodTypeImageView.image = #imageLiteral(resourceName: "favorites")
        wodTypeLabel.text = "Favorites"
        wodsCompletedLabel.text = "\(wodsCount)"
    }
    
}

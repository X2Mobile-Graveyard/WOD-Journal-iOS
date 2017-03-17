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
            wodTypeLabel.text = "Heroes"
        case .challenge:
            wodTypeImageView.image = #imageLiteral(resourceName: "challenge")
            wodTypeLabel.text = "Challenges"
        case .girl:
            wodTypeImageView.image = #imageLiteral(resourceName: "girl")
            wodTypeLabel.text = "Girls"
        case .custom:
            wodTypeImageView.image = #imageLiteral(resourceName: "custom")
            wodTypeLabel.text = "Custom"
        case .open:
            wodTypeImageView.image = #imageLiteral(resourceName: "crossFitGamesLogo")
            wodTypeLabel.text = "Open"
        }
        
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
